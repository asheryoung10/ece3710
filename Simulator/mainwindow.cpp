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
#include <QElapsedTimer>

QString MainWindow::currentFileShown;
int MainWindow::currentLineShown = -1;

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

    // --- Player 1 ---
    connect(ui->p1Left,  &QPushButton::pressed,  this, [this]{ model.setP1Left(true); });
    connect(ui->p1Left,  &QPushButton::released, this, [this]{ model.setP1Left(false); });

    connect(ui->p1Right, &QPushButton::pressed,  this, [this]{ model.setP1Right(true); });
    connect(ui->p1Right, &QPushButton::released, this, [this]{ model.setP1Right(false); });

    connect(ui->p1Up,    &QPushButton::pressed,  this, [this]{ model.setP1Up(true); });
    connect(ui->p1Up,    &QPushButton::released, this, [this]{ model.setP1Up(false); });

    connect(ui->p1Down,  &QPushButton::pressed,  this, [this]{ model.setP1Down(true); });
    connect(ui->p1Down,  &QPushButton::released, this, [this]{ model.setP1Down(false); });


    // --- Player 2 ---
    connect(ui->p2Left,  &QPushButton::pressed,  this, [this]{ model.setP2Left(true); });
    connect(ui->p2Left,  &QPushButton::released, this, [this]{ model.setP2Left(false); });

    connect(ui->p2Right, &QPushButton::pressed,  this, [this]{ model.setP2Right(true); });
    connect(ui->p2Right, &QPushButton::released, this, [this]{ model.setP2Right(false); });

    connect(ui->p2Up,    &QPushButton::pressed,  this, [this]{ model.setP2Up(true); });
    connect(ui->p2Up,    &QPushButton::released, this, [this]{ model.setP2Up(false); });

    connect(ui->p2Down,  &QPushButton::pressed,  this, [this]{ model.setP2Down(true); });
    connect(ui->p2Down,  &QPushButton::released, this, [this]{ model.setP2Down(false); });


    // --- Player 3 ---
    connect(ui->p3Left,  &QPushButton::pressed,  this, [this]{ model.setP3Left(true); });
    connect(ui->p3Left,  &QPushButton::released, this, [this]{ model.setP3Left(false); });

    connect(ui->p3Right, &QPushButton::pressed,  this, [this]{ model.setP3Right(true); });
    connect(ui->p3Right, &QPushButton::released, this, [this]{ model.setP3Right(false); });

    connect(ui->p3Up,    &QPushButton::pressed,  this, [this]{ model.setP3Up(true); });
    connect(ui->p3Up,    &QPushButton::released, this, [this]{ model.setP3Up(false); });

    connect(ui->p3Down,  &QPushButton::pressed,  this, [this]{ model.setP3Down(true); });
    connect(ui->p3Down,  &QPushButton::released, this, [this]{ model.setP3Down(false); });


    // --- Player 4 ---
    connect(ui->p4Left,  &QPushButton::pressed,  this, [this]{ model.setP4Left(true); });
    connect(ui->p4Left,  &QPushButton::released, this, [this]{ model.setP4Left(false); });

    connect(ui->p4Right, &QPushButton::pressed,  this, [this]{ model.setP4Right(true); });
    connect(ui->p4Right, &QPushButton::released, this, [this]{ model.setP4Right(false); });

    connect(ui->p4Up,    &QPushButton::pressed,  this, [this]{ model.setP4Up(true); });
    connect(ui->p4Up,    &QPushButton::released, this, [this]{ model.setP4Up(false); });

    connect(ui->p4Down,  &QPushButton::pressed,  this, [this]{ model.setP4Down(true); });
    connect(ui->p4Down,  &QPushButton::released, this, [this]{ model.setP4Down(false); });;

    connect(ui->resetButton, &QPushButton::pressed,  this, [this]{ model.setResetButton(true); });
    connect(ui->resetButton, &QPushButton::released, this, [this]{ model.setResetButton(false); });
    connect(ui->RectJump, &QPushButton::pressed, this, [this]{ this->jumpAddress(32768); });
    connect(ui->playerJump, &QPushButton::pressed, this, [this]{ this->jumpAddress(49152); });
    connect(ui->stackJump, &QPushButton::pressed, this, [this]{ this->jumpAddress(model.registers[14]); });
    connect(ui->refreshViews, &QPushButton::pressed, this, [this]{ this->updateViews(); });

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
    ui->breakPoint->setValue(10000);
    ui->registerView->setFocusPolicy(Qt::NoFocus);
    ui->memoryView->setFocusPolicy(Qt::NoFocus);
    ui->onlyViewCheck->setFocusPolicy(Qt::NoFocus);
    ui->breakPoint->setFocusPolicy(Qt::ClickFocus);
    ui->resetButton->setFocusPolicy(Qt::NoFocus);
    ui->playButton->setFocusPolicy(Qt::NoFocus);
    ui->stepButton->setFocusPolicy(Qt::NoFocus);
    ui->loadButton->setFocusPolicy(Qt::NoFocus);
    ui->vsyncCheckBox->setFocusPolicy(Qt::NoFocus);
    ui->sourceView->setFocusPolicy(Qt::NoFocus);
    ui->reloadButton->setFocusPolicy(Qt::NoFocus);

    // Player 1
    ui->p1Left->setFocusPolicy(Qt::NoFocus);
    ui->p1Right->setFocusPolicy(Qt::NoFocus);
    ui->p1Up->setFocusPolicy(Qt::NoFocus);
    ui->p1Down->setFocusPolicy(Qt::NoFocus);

    // Player 2
    ui->p2Left->setFocusPolicy(Qt::NoFocus);
    ui->p2Right->setFocusPolicy(Qt::NoFocus); // rename from pushButton_9 if you haven’t
    ui->p2Up->setFocusPolicy(Qt::NoFocus);
    ui->p2Down->setFocusPolicy(Qt::NoFocus);

    // Player 3
    ui->p3Left->setFocusPolicy(Qt::NoFocus);
    ui->p3Right->setFocusPolicy(Qt::NoFocus);
    ui->p3Up->setFocusPolicy(Qt::NoFocus);
    ui->p3Down->setFocusPolicy(Qt::NoFocus);

    // Player 4
    ui->p4Left->setFocusPolicy(Qt::NoFocus);
    ui->p4Right->setFocusPolicy(Qt::NoFocus);
    ui->p4Up->setFocusPolicy(Qt::NoFocus);
    ui->p4Down->setFocusPolicy(Qt::NoFocus);

    ui->sourceView->setReadOnly(true);  // QTextBrowser or QTextEdit
    ui->sourceView->setFont(QFont("Courier", 10)); // monospaced for code
    ui->sourceView->setLineWrapMode(QTextEdit::NoWrap); // prevent wrapping
    ui->splitter->setSizes({1000,1000});
    ui->splitter_2->setSizes({1000,1000});
    ui->frameDelay->setValue(8);
    ui->instructionsPerFrame->setValue(1000);
    this->setWindowIcon(QIcon(":/data/assets/windowIcon.svg"));

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
    return;}

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
                                                    tr("Open Memory File"), "../../",
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
        advanceModel(false);
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

void MainWindow::advanceModel(bool breakOn) {
    if(breakOn && ui->breakOn->isChecked() && model.programCounter == (uint16_t)ui->breakPoint->value()) {
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
    // Capture the start time for this frame
    static QElapsedTimer frameTimer;
    static bool firstCall = true;
    if (firstCall) {
        frameTimer.start();
        firstCall = false;
    }


    advanceModel(false);
    // Advance model for the main instructions
    for (int i = 0; i < ui->instructionsPerFrame->value()-1; ++i) {
        advanceModel(true);
    }

    // Optional extra steps with VSync
    setVsyncOn();
    for (int i = 0; i < 10; ++i) {
        advanceModel(true);
    }
    setVsyncOff();

    // Update views
    updateViews();

    // Restart timer for next tick

    // Set CPU timer interval for next tick
    cpuTimer->setInterval(ui->frameDelay->value());
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

void MainWindow::updateMemoryViewPartial()
{
    if (!ui->memoryView->model()) return;

    int firstRow = ui->memoryView->verticalScrollBar()->value();
    int visibleRows = ui->memoryView->viewport()->height() / ui->memoryView->rowHeight(0);
    int lastRow = std::min(firstRow + visibleRows, 65536);

    for (int row = firstRow; row < lastRow; ++row) {
        uint16_t val = model.memory[row];

        // Combine address and value in hex + decimal
        QString displayText = QString("Addr: 0x%1  Val: %2 (0x%3)")
                                  .arg(row, 4, 16, QChar('0')).toUpper() // address in hex
                                  .arg(val)                                // value decimal
                                  .arg(val, 4, 16, QChar('0')).toUpper(); // value hex

        memoryModelQt->setItem(row, 0, new QStandardItem(displayText));
    }
}

void MainWindow::jumpAddress(int targetRow) {
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
    if(ui->followPC->isChecked()) {
        jumpAddress(model.programCounter);
    }
    for (int i = 0; i < 16; ++i) {
        uint16_t value = model.registers[i];

        QString hex = QString("%1")
                          .arg(value, 4, 16, QChar('0'))
                          .toUpper();

        QString dec = QString::number(value);

        QString bin = QString("%1")
                          .arg(value, 16, 2, QChar('0'));  // 16-bit binary

        registerModelQt->setItem(i, 0, new QStandardItem(
                                           QString("R%1: HEX=%2 DEC=%3 BIN=%4")
                                               .arg(i)
                                               .arg(hex)
                                               .arg(dec)
                                               .arg(bin)
                                           ));
    }

    updateMemoryViewPartial();

    ui->programCounter->setText(
        QString("PC: %1").arg(model.programCounter, 2, 10).toUpper()
    );
    ui->flags->setText(
        QString("INSTR: %1 Flags: C=%2 L=%3 F=%4 Z=%5 N=%6")
            .arg(model.memory[model.programCounter], 4,16)
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
}


void MainWindow::keyPressEvent(QKeyEvent *event)
{
    if (event->isAutoRepeat()) return;

    switch (event->key()) {

    // --- Player 1 (WASD) ---
    case Qt::Key_A:
        model.setP1Left(true);
        break;
    case Qt::Key_D:
        model.setP1Right(true);
        break;
    case Qt::Key_W:
        model.setP1Up(true);
        break;
    case Qt::Key_S:
        model.setP1Down(true);
        break;

    // --- Player 2 (Arrow Keys) ---
    case Qt::Key_Left:
        model.setP2Left(true);
        break;
    case Qt::Key_Right:
        model.setP2Right(true);
        break;
    case Qt::Key_Up:
        model.setP2Up(true);
        break;
    case Qt::Key_Down:
        model.setP2Down(true);
        break;

    // --- Player 3 (IJKL) ---
    case Qt::Key_J:
        model.setP3Left(true);
        break;
    case Qt::Key_L:
        model.setP3Right(true);
        break;
    case Qt::Key_I:
        model.setP3Up(true);
        break;
    case Qt::Key_K:
        model.setP3Down(true);
        break;

    // --- Player 4 (Numpad) ---
    case Qt::Key_4:
        model.setP4Left(true);
        break;
    case Qt::Key_6:
        model.setP4Right(true);
        break;
    case Qt::Key_8:
        model.setP4Up(true);
        break;
    case Qt::Key_5:
        model.setP4Down(true);
        break;

    default:
        QMainWindow::keyPressEvent(event);
    }
}

void MainWindow::keyReleaseEvent(QKeyEvent *event)
{
    if (event->isAutoRepeat()) return;

    switch (event->key()) {

    // --- Player 1 (WASD) ---
    case Qt::Key_A:
        model.setP1Left(false);
        break;
    case Qt::Key_D:
        model.setP1Right(false);
        break;
    case Qt::Key_W:
        model.setP1Up(false);
        break;
    case Qt::Key_S:
        model.setP1Down(false);
        break;

    // --- Player 2 (Arrow Keys) ---
    case Qt::Key_Left:
        model.setP2Left(false);
        break;
    case Qt::Key_Right:
        model.setP2Right(false);
        break;
    case Qt::Key_Up:
        model.setP2Up(false);
        break;
    case Qt::Key_Down:
        model.setP2Down(false);
        break;

    // --- Player 3 (IJKL) ---
    case Qt::Key_J:
        model.setP3Left(false);
        break;
    case Qt::Key_L:
        model.setP3Right(false);
        break;
    case Qt::Key_I:
        model.setP3Up(false);
        break;
    case Qt::Key_K:
        model.setP3Down(false);
        break;

    // --- Player 4 (Numpad) ---
    case Qt::Key_4:
        model.setP4Left(false);
        break;
    case Qt::Key_6:
        model.setP4Right(false);
        break;
    case Qt::Key_8:
        model.setP4Up(false);
        break;
    case Qt::Key_5:
        model.setP4Down(false);
        break;

    default:
        QMainWindow::keyReleaseEvent(event);
    }
}
