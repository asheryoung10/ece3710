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
#include <QRegularExpression>
#include <QTextBlock>
#include <QTextStream>
#include <QPropertyAnimation>
#include <QAbstractAnimation>
#include <iostream>

QString MainWindow::currentFileShown;
int MainWindow::currentLineShown = -1;

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    ui->jumpAddress->setValue(32768);

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
    connect(ui->jumptoAddressButton, &QPushButton::pressed, this, [this]{ this->jumpAddress(); });

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
    //connect(ui->sourceView, &QTextEdit::cursorPositionChanged,
     //       this, &MainWindow::onSourceCursorChanged);

    // Connect VGA view if needed
    ui->vgaView->setModel(&model);
    connect(ui->stepAmount,&QSlider::valueChanged,  this, &MainWindow::slidersChanged);
    connect(ui->frameDelay,&QSlider::valueChanged, this, &MainWindow::slidersChanged);
    connect(ui->vsyncCheckBox,&QCheckBox::clicked, this, &MainWindow::setVsync);
    ui->leftButton->setFocusPolicy(Qt::NoFocus);
    ui->onlyViewCheck->setFocusPolicy(Qt::NoFocus);
    ui->rightButton->setFocusPolicy(Qt::NoFocus);
    ui->jumpButton->setFocusPolicy(Qt::NoFocus);
    ui->breakPoint->setFocusPolicy(Qt::ClickFocus);
    ui->resetButton->setFocusPolicy(Qt::NoFocus);
    ui->playButton->setFocusPolicy(Qt::NoFocus);
    ui->stepButton->setFocusPolicy(Qt::NoFocus);
    ui->loadButton->setFocusPolicy(Qt::NoFocus);
    ui->vsyncCheckBox->setFocusPolicy(Qt::NoFocus);
    ui->sourceView->setFocusPolicy(Qt::NoFocus);
    ui->reloadButton->setFocusPolicy(Qt::NoFocus);

    ui->sourceView->setReadOnly(true);  // QTextBrowser or QTextEdit
    ui->sourceView->setFont(QFont("Courier", 10)); // monospaced for code
    ui->sourceView->setLineWrapMode(QTextEdit::NoWrap); // prevent wrapping
    ui->splitter->setSizes({1000,1000});
    ui->splitter_2->setSizes({1000,1000});

    // Initial UI update
    slidersChanged();
    updateViews();
}

void MainWindow::onSourceCursorChanged()
{
    if (currentFileShown.isEmpty()) return;

    QTextCursor cursor = ui->sourceView->textCursor();
    int line = cursor.blockNumber() + 1; // QTextBlock is 0-based
    std::cout << line << std::endl;
    return;

    //if (sourceToPC.contains({currentSourceFile, line}) &&
     //   sourceToPC[{currentSourceFile, line}].contains(line)) {

        //int pc = sourceToPC[currentFileShown][line];
        //ui->breakPoint->setValue(pc);
   // }
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
    currentFileShown.clear();
    currentLineShown = -1;
    parsePCMappingAndLoadSources(QString::fromStdString(filepath));
    pauseSimulation();
    updateViews();
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
        parsePCMappingAndLoadSources(filePath);
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

void MainWindow::parsePCMappingAndLoadSources(const QString &binFilePath)
{
    pcToSource.clear();
    sourceToPC.clear();
    fileToLines.clear();

    QFile file(binFilePath);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
        return;

    QString baseDir = QFileInfo(file).absolutePath();
    QTextStream in(&file);

    int pc = 0; // start at program counter 0
    QRegularExpression rx("^\\s*([0-9A-Fa-f]+)\\s*//\\s*(\\S+)\\s+(\\d+)\\s*$");

    while (!in.atEnd()) {
        QString line = in.readLine().trimmed();
        if (line.isEmpty()) continue;

        QRegularExpressionMatch match = rx.match(line);
        if (!match.hasMatch()) {
            ++pc;
            continue;
        }

        QString filename = match.captured(2);
        int lineno = match.captured(3).toInt();

        pcToSource[pc] = {filename, lineno};

        // Load the file contents if not already loaded
        if (!fileToLines.contains(filename)) {
            QString filePath = QDir(baseDir).filePath(filename);
            QFile srcFile(filePath);
            if (!srcFile.open(QIODevice::ReadOnly | QIODevice::Text)) {
                ++pc;
                continue;
            }

            QTextStream srcIn(&srcFile);
            QStringList lines;
            while (!srcIn.atEnd())
                lines.append(srcIn.readLine());

            fileToLines[filename] = lines;
        }

        ++pc;
    }
}

// Single step CPU
void MainWindow::stepModel()
{
    for(int i = 0; i < ui->stepAmount->value(); i++) {
        advanceModel();
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

void MainWindow::advanceModel() {
    if(model.programCounter == (uint16_t)ui->breakPoint->value()) {
        flash();
        pauseSimulation();
        return;
    }
    model.tick();

}

void MainWindow::flash() {
    QWidget* w = ui->breakPoint;

    QRect start = w->geometry();
    QRect big   = start.adjusted(-3, -3, 3, 3); // grow by 3px

    QPropertyAnimation* anim = new QPropertyAnimation(w, "geometry");
    anim->setDuration(150);
    anim->setKeyValueAt(0.0, start);
    anim->setKeyValueAt(0.5, big);
    anim->setKeyValueAt(1.0, start);
    anim->setEasingCurve(QEasingCurve::OutQuad);

    anim->start(QAbstractAnimation::DeleteWhenStopped);
}
// Timer slot: tick CPU
void MainWindow::tickModel()
{
    for (int i = 0; i < ui->instructionsPerFrame->value(); ++i) {
        advanceModel();
    }
    	
    setVsyncOn();
    for (int i = 0; i < 10; ++i) {
        advanceModel();
    }
    setVsyncOff();
    cpuTimer->setInterval(ui->frameDelay->value());
    updateViews();
}

void MainWindow::setVsyncOn() {
    ui->vsyncCheckBox->setCheckState(Qt::CheckState::Checked);
    model.setVSync(true);
}

void MainWindow::setVsync(bool on) {
    if(on) {
        setVsyncOn();
    }
    else{
        setVsyncOff();
    }
}

void MainWindow::setVsyncOff() {
    ui->vsyncCheckBox->setCheckState(Qt::CheckState::Unchecked);
    model.setVSync(false);
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

void MainWindow::jumpAddress() {
    int targetRow = ui->jumpAddress->value();
    ui->memoryView->scrollTo(memoryModelQt->index(targetRow, 0),
                             QAbstractItemView::PositionAtTop);

    // Optionally, select the row so it's highlighted
    ui->memoryView->selectionModel()->select(
        memoryModelQt->index(targetRow, 0),
        QItemSelectionModel::ClearAndSelect | QItemSelectionModel::Rows
        );
}
void MainWindow::updateViews()
{
    ui->vgaView->update();
    if(ui->onlyViewCheck->isChecked()) return;
    // -------------------
    // Update registers
    // -------------------
    for (int i = 0; i < 16; ++i) {
        registerModelQt->setItem(i, 0, new QStandardItem(
                                           QString("R%1: %2").arg(i).arg(model.registers[i], 4, 16, QChar('0')).toUpper()
                                           ));
    }

    // -------------------
    // Update only visible memory
    // -------------------
    updateMemoryViewPartial();

    // -------------------
    // Update PC and flags
    // -------------------
    ui->programCounter->setText(
        QString("PC: %1").arg(model.programCounter, 2, 10).toUpper()
        );
    ui->flags->setText(
        QString("Flags: C=%1 L=%2 F=%3 Z=%4 N=%5")
            .arg(model.cFlag)
            .arg(model.lFlag)
            .arg(model.fFlag)
            .arg(model.zFlag)
            .arg(model.nFlag)
        );


    if (pcToSource.contains(model.programCounter)) {
        const SourceInfo &src = pcToSource[model.programCounter];
        const QString &filename = src.file;
        int lineNo = src.line;

        if (filename != currentFileShown) {
            // Load new file text
            if (fileToLines.contains(filename)) {
                ui->sourceView->setPlainText(fileToLines[filename].join("\n"));
                currentFileShown = filename;
            }
        }

        // Highlight current line if it changed
        if (lineNo != currentLineShown) {
            QTextCursor cursor(ui->sourceView->document());
            int blockIndex = lineNo - 1;
            if (blockIndex >= 0 && blockIndex < fileToLines[filename].size()) {
                QTextBlock block = ui->sourceView->document()->findBlockByNumber(blockIndex);
                cursor.setPosition(block.position());
                cursor.movePosition(QTextCursor::EndOfBlock, QTextCursor::KeepAnchor);
                ui->sourceView->setTextCursor(cursor);
                ui->sourceView->ensureCursorVisible();
                currentLineShown = lineNo;
            }
        }
    }
    // -------------------
    // Update VGA view
    // -------------------
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
