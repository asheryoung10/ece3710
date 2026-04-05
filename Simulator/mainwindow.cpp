#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QFileDialog>
#include <QMessageBox>
#include <QTimer>
#include <QStandardItemModel>
#include <QHeaderView>
#include <QScrollBar>
#include <QThread>
#include <QKeyEvent>

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);

    // Initialize CPU timer
    cpuTimer = new QTimer(this);
    connect(cpuTimer, &QTimer::timeout, this, &MainWindow::tickModel);
    cpuTimer->setInterval(0); // 0 ms → as fast as possible

    // Load memory file
    connect(ui->loadButton, &QPushButton::clicked, this, &MainWindow::loadFileIntoModel);
    ui->reloadButton->setEnabled(false);

    // Input buttons
    connect(ui->leftButton, &QPushButton::pressed,  this, [this]{ model.setLeftButton(true); });
    connect(ui->leftButton, &QPushButton::released, this, [this]{ model.setLeftButton(false); });

    connect(ui->rightButton, &QPushButton::pressed,  this, [this]{ model.setRightButton(true); });
    connect(ui->rightButton, &QPushButton::released, this, [this]{ model.setRightButton(false); });

    connect(ui->jumpButton, &QPushButton::pressed,  this, [this]{ model.setJumpButton(true); });
    connect(ui->jumpButton, &QPushButton::released, this, [this]{ model.setJumpButton(false); });

    connect(ui->resetButton, &QPushButton::pressed,  this, [this]{ model.setResetButton(true); });
    connect(ui->resetButton, &QPushButton::released, this, [this]{ model.setResetButton(false); });

    // Step / play / pause
    connect(ui->stepButton, &QPushButton::clicked, this, &MainWindow::stepModel);
    connect(ui->playButton, &QPushButton::clicked, this, &MainWindow::pausePlaySimulation);
    connect(ui->reloadButton, &QPushButton::clicked, this, &MainWindow::reloadSimulation);

    // Setup memory model: 65536 rows, 1 column
    memoryModelQt = new QStandardItemModel(65536, 1, this);
    ui->memoryView->setModel(memoryModelQt);
    ui->memoryView->horizontalHeader()->setStretchLastSection(true);
    ui->memoryView->verticalHeader()->setSectionResizeMode(QHeaderView::Fixed);
    ui->memoryView->setEditTriggers(QAbstractItemView::NoEditTriggers);
    ui->memoryView->setSelectionBehavior(QAbstractItemView::SelectRows);

    // Setup register model: 16 rows, 1 column
    registerModelQt = new QStandardItemModel(16, 1, this);
    ui->registerView->setModel(registerModelQt);
    ui->registerView->horizontalHeader()->setStretchLastSection(true);
    ui->registerView->verticalHeader()->setSectionResizeMode(QHeaderView::Fixed);
    ui->registerView->setEditTriggers(QAbstractItemView::NoEditTriggers);
    ui->registerView->setSelectionBehavior(QAbstractItemView::SelectRows);
    // Trigger memory update when user scrolls
    connect(ui->memoryView->verticalScrollBar(), &QScrollBar::valueChanged,
            this, &MainWindow::updateMemoryViewPartial);

    // Connect VGA view if needed
    ui->vgaView->setModel(&model);
    connect(ui->stepAmount,&QSlider::valueChanged,  this, &MainWindow::slidersChanged);
    connect(ui->frameDelay,&QSlider::valueChanged, this, &MainWindow::slidersChanged);
    ui->leftButton->setFocusPolicy(Qt::NoFocus);
    ui->rightButton->setFocusPolicy(Qt::NoFocus);
    ui->jumpButton->setFocusPolicy(Qt::NoFocus);
    ui->resetButton->setFocusPolicy(Qt::NoFocus);
    ui->playButton->setFocusPolicy(Qt::NoFocus);
    ui->stepButton->setFocusPolicy(Qt::NoFocus);
    ui->loadButton->setFocusPolicy(Qt::NoFocus);
    ui->reloadButton->setFocusPolicy(Qt::NoFocus);

    // Initial UI update
    slidersChanged();
    updateViews();
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::slidersChanged() {
    ui->stepButton->setText(QString("Step %1").arg(ui->stepAmount->value()));

    if (isPlaying) {
        ui->playButton->setText("Pause");
    } else {
        ui->playButton->setText(QString("Play %1 ms").arg(ui->frameDelay->value()));
    }
}
void MainWindow::reloadSimulation() {
    model.initMemory(filepath);
    pauseSimulation();
}
// Load memory from file
void MainWindow::loadFileIntoModel()
{
    QString filePath = QFileDialog::getOpenFileName(this,
                                                    tr("Open Memory File"), "",
                                                    tr("Binary Files (*.bin);;All Files (*)"));
    if (filePath.isEmpty()) return;

    try {
        model.initMemory(filePath.toStdString());
        QMessageBox::information(this, tr("Memory Loaded"),
                                 tr("Memory successfully loaded from:\n%1").arg(filePath));
        filepath = filePath.toStdString();
        ui->reloadButton->setEnabled(true);
        pauseSimulation();
        updateViews();
    } catch (const std::exception& e) {
        QMessageBox::critical(this, tr("Error"), tr("Failed to load file:\n%1").arg(e.what()));
    }
}

// Single step CPU
void MainWindow::stepModel()
{
    for(int i = 0; i < ui->stepAmount->value(); i++) {
        model.tick();
        updateViews();
        QThread::sleep(1.0/60.0);
    }
}

// Start continuous simulation
void MainWindow::pausePlaySimulation()
{
    if(isPlaying) {
        pauseSimulation();
       }else {
        playSimulation();
     }
}
void MainWindow::playSimulation() {
       isPlaying = true;
    slidersChanged();
        cpuTimer->start();

}
void MainWindow::pauseSimulation() {
     cpuTimer->stop();
        ui->playButton->setText("Play");
        isPlaying = false;
     slidersChanged();

}
// Timer slot: tick CPU
void MainWindow::tickModel()
{
    constexpr int batchTicks = 256;
    for (int i = 0; i < batchTicks; ++i)
        model.tick();
    model.setVSync(true);
    for (int i = 0; i < 10; ++i)
        model.tick();
    model.setVSync(false);
    cpuTimer->setInterval(ui->frameDelay->value());
    updateViews();
}

// Update only visible memory rows
void MainWindow::updateMemoryViewPartial()
{
    if (!ui->memoryView->model()) return;

    int firstRow = ui->memoryView->verticalScrollBar()->value();
    int visibleRows = ui->memoryView->viewport()->height() / ui->memoryView->rowHeight(0);
    int lastRow = std::min(firstRow + visibleRows, 65536);

    for (int row = firstRow; row < lastRow; ++row) {
        uint16_t val = model.memory[row];
        memoryModelQt->setItem(row, 0, new QStandardItem(
                                           QString("%1").arg(val, 4, 16, QChar('0')).toUpper()
                                           ));
    }
}

// Update all views
void MainWindow::updateViews()
{
    // Update registers
    for (int i = 0; i < 16; ++i) {
        registerModelQt->setItem(i, 0, new QStandardItem(
                                           QString("R%1: %2").arg(i).arg(model.registers[i], 4, 16, QChar('0')).toUpper()
                                           ));
    }

    // Update only visible memory
    updateMemoryViewPartial();

    // Update PC and flags
    ui->programCounter->setText(
        QString("PC: %1").arg(model.programCounter, 0, 10)
        );
    ui->flags->setText(
        QString("Flags: C=%1 L=%2 F=%3 Z=%4 N=%5")
            .arg(model.cFlag)
            .arg(model.lFlag)
            .arg(model.fFlag)
            .arg(model.zFlag)
            .arg(model.nFlag)
        );

    ui->vgaView->update();
}


void MainWindow::keyPressEvent(QKeyEvent *event)
{
    if (event->isAutoRepeat()) return;

    switch (event->key()) {
    case Qt::Key_A:
        model.setLeftButton(true);
        break;
    case Qt::Key_D:
        model.setRightButton(true);
        break;
    case Qt::Key_Space:
        model.setJumpButton(true);
        break;
    default:
        QMainWindow::keyPressEvent(event);
    }
}

void MainWindow::keyReleaseEvent(QKeyEvent *event)
{
    if (event->isAutoRepeat()) return;

    switch (event->key()) {
    case Qt::Key_A:
        model.setLeftButton(false);
        break;
    case Qt::Key_D:
        model.setRightButton(false);
        break;
    case Qt::Key_Space:
        model.setJumpButton(false);
        break;
    default:
        QMainWindow::keyReleaseEvent(event);
    }
}
