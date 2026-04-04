#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QFileDialog>
#include <QMessageBox>
#include <QTimer>
#include <QStandardItemModel>
#include <QHeaderView>
#include <QScrollBar>
#include <QThread>

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
    connect(ui->playButton, &QPushButton::clicked, this, &MainWindow::startSimulation);
    connect(ui->pauseButton, &QPushButton::clicked, this, &MainWindow::pauseSimulation);

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

    // Initial UI update
    updateViews();
}

MainWindow::~MainWindow()
{
    delete ui;
}

// Load memory from file
void MainWindow::loadFileIntoModel()
{
    model.initMemory("C:\\Users\\asher\\Desktop\\SchoolWork\\ece3710\\Assembler\\testMover2.bin");
    return;
    QString filePath = QFileDialog::getOpenFileName(this,
                                                    tr("Open Memory File"), "",
                                                    tr("Binary Files (*.bin);;All Files (*)"));
    if (filePath.isEmpty()) return;

    try {
        model.initMemory(filePath.toStdString());
        QMessageBox::information(this, tr("Memory Loaded"),
                                 tr("Memory successfully loaded from:\n%1").arg(filePath));
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
void MainWindow::startSimulation()
{
    cpuTimer->start();
}

// Pause simulation
void MainWindow::pauseSimulation()
{
    cpuTimer->stop();
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
