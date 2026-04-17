/********************************************************************************
** Form generated from reading UI file 'mainwindow.ui'
**
** Created by: Qt User Interface Compiler version 6.10.2
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_MAINWINDOW_H
#define UI_MAINWINDOW_H

#include <QtCore/QVariant>
#include <QtWidgets/QApplication>
#include <QtWidgets/QCheckBox>
#include <QtWidgets/QGridLayout>
#include <QtWidgets/QHBoxLayout>
#include <QtWidgets/QHeaderView>
#include <QtWidgets/QLabel>
#include <QtWidgets/QMainWindow>
#include <QtWidgets/QPushButton>
#include <QtWidgets/QSlider>
#include <QtWidgets/QSpinBox>
#include <QtWidgets/QSplitter>
#include <QtWidgets/QTableView>
#include <QtWidgets/QTextBrowser>
#include <QtWidgets/QVBoxLayout>
#include <QtWidgets/QWidget>
#include "vgaview.h"

QT_BEGIN_NAMESPACE

class Ui_MainWindow
{
public:
    QWidget *centralwidget;
    QHBoxLayout *horizontalLayout_7;
    QSplitter *splitter_2;
    QSplitter *splitter;
    QWidget *verticalLayoutWidget;
    QVBoxLayout *verticalLayout;
    VGAView *vgaView;
    QHBoxLayout *horizontalLayout;
    QCheckBox *onlyViewCheck;
    QPushButton *refreshViews;
    QPushButton *resetButton;
    QHBoxLayout *horizontalLayout_10;
    QGridLayout *gridLayout;
    QPushButton *p1Down;
    QPushButton *p1Left;
    QPushButton *p1Right;
    QPushButton *p1Up;
    QGridLayout *gridLayout_2;
    QPushButton *p2Down;
    QPushButton *p2Left;
    QPushButton *p2Right;
    QPushButton *p2Up;
    QPushButton *start;
    QGridLayout *gridLayout_3;
    QPushButton *p4Left;
    QPushButton *p3Right;
    QGridLayout *gridLayout_4;
    QPushButton *p3Left;
    QPushButton *p3Down;
    QPushButton *p3Up;
    QPushButton *p4Down;
    QPushButton *p4Right;
    QPushButton *p4Up;
    QPushButton *select;
    QTextBrowser *sourceView;
    QWidget *layoutWidget;
    QVBoxLayout *verticalLayout_2;
    QHBoxLayout *horizontalLayout_4;
    QPushButton *loadButton;
    QPushButton *reloadButton;
    QHBoxLayout *horizontalLayout_5;
    QPushButton *stepButton;
    QSlider *stepAmount;
    QHBoxLayout *horizontalLayout_6;
    QPushButton *playButton;
    QSlider *frameDelay;
    QHBoxLayout *horizontalLayout_2;
    QCheckBox *breakOn;
    QSpinBox *breakPoint;
    QHBoxLayout *horizontalLayout_9;
    QLabel *label;
    QSlider *instructionsPerFrame;
    QCheckBox *vsyncCheckBox;
    QHBoxLayout *horizontalLayout_3;
    QLabel *programCounter;
    QLabel *flags;
    QTableView *registerView;
    QHBoxLayout *horizontalLayout_8;
    QPushButton *stackJump;
    QPushButton *RectJump;
    QPushButton *playerJump;
    QCheckBox *followPC;
    QTableView *memoryView;

    void setupUi(QMainWindow *MainWindow)
    {
        if (MainWindow->objectName().isEmpty())
            MainWindow->setObjectName("MainWindow");
        MainWindow->resize(1329, 600);
        centralwidget = new QWidget(MainWindow);
        centralwidget->setObjectName("centralwidget");
        horizontalLayout_7 = new QHBoxLayout(centralwidget);
        horizontalLayout_7->setObjectName("horizontalLayout_7");
        splitter_2 = new QSplitter(centralwidget);
        splitter_2->setObjectName("splitter_2");
        splitter_2->setOrientation(Qt::Orientation::Horizontal);
        splitter = new QSplitter(splitter_2);
        splitter->setObjectName("splitter");
        splitter->setOrientation(Qt::Orientation::Vertical);
        verticalLayoutWidget = new QWidget(splitter);
        verticalLayoutWidget->setObjectName("verticalLayoutWidget");
        verticalLayout = new QVBoxLayout(verticalLayoutWidget);
        verticalLayout->setObjectName("verticalLayout");
        verticalLayout->setContentsMargins(0, 0, 0, 0);
        vgaView = new VGAView(verticalLayoutWidget);
        vgaView->setObjectName("vgaView");

        verticalLayout->addWidget(vgaView);

        horizontalLayout = new QHBoxLayout();
        horizontalLayout->setObjectName("horizontalLayout");
        onlyViewCheck = new QCheckBox(verticalLayoutWidget);
        onlyViewCheck->setObjectName("onlyViewCheck");

        horizontalLayout->addWidget(onlyViewCheck);

        refreshViews = new QPushButton(verticalLayoutWidget);
        refreshViews->setObjectName("refreshViews");

        horizontalLayout->addWidget(refreshViews);

        resetButton = new QPushButton(verticalLayoutWidget);
        resetButton->setObjectName("resetButton");

        horizontalLayout->addWidget(resetButton);


        verticalLayout->addLayout(horizontalLayout);

        horizontalLayout_10 = new QHBoxLayout();
        horizontalLayout_10->setObjectName("horizontalLayout_10");
        gridLayout = new QGridLayout();
        gridLayout->setObjectName("gridLayout");
        p1Down = new QPushButton(verticalLayoutWidget);
        p1Down->setObjectName("p1Down");

        gridLayout->addWidget(p1Down, 3, 1, 1, 1);

        p1Left = new QPushButton(verticalLayoutWidget);
        p1Left->setObjectName("p1Left");

        gridLayout->addWidget(p1Left, 3, 0, 1, 1);

        p1Right = new QPushButton(verticalLayoutWidget);
        p1Right->setObjectName("p1Right");

        gridLayout->addWidget(p1Right, 3, 2, 1, 1);

        p1Up = new QPushButton(verticalLayoutWidget);
        p1Up->setObjectName("p1Up");

        gridLayout->addWidget(p1Up, 0, 1, 1, 1);


        horizontalLayout_10->addLayout(gridLayout);

        gridLayout_2 = new QGridLayout();
        gridLayout_2->setObjectName("gridLayout_2");
        p2Down = new QPushButton(verticalLayoutWidget);
        p2Down->setObjectName("p2Down");

        gridLayout_2->addWidget(p2Down, 1, 1, 1, 1);

        p2Left = new QPushButton(verticalLayoutWidget);
        p2Left->setObjectName("p2Left");

        gridLayout_2->addWidget(p2Left, 1, 0, 1, 1);

        p2Right = new QPushButton(verticalLayoutWidget);
        p2Right->setObjectName("p2Right");

        gridLayout_2->addWidget(p2Right, 1, 2, 1, 1);

        p2Up = new QPushButton(verticalLayoutWidget);
        p2Up->setObjectName("p2Up");

        gridLayout_2->addWidget(p2Up, 0, 1, 1, 1);

        start = new QPushButton(verticalLayoutWidget);
        start->setObjectName("start");

        gridLayout_2->addWidget(start, 0, 2, 1, 1);


        horizontalLayout_10->addLayout(gridLayout_2);

        gridLayout_3 = new QGridLayout();
        gridLayout_3->setObjectName("gridLayout_3");
        p4Left = new QPushButton(verticalLayoutWidget);
        p4Left->setObjectName("p4Left");

        gridLayout_3->addWidget(p4Left, 1, 3, 1, 1);

        p3Right = new QPushButton(verticalLayoutWidget);
        p3Right->setObjectName("p3Right");

        gridLayout_3->addWidget(p3Right, 1, 2, 1, 1);

        gridLayout_4 = new QGridLayout();
        gridLayout_4->setObjectName("gridLayout_4");

        gridLayout_3->addLayout(gridLayout_4, 1, 6, 1, 1);

        p3Left = new QPushButton(verticalLayoutWidget);
        p3Left->setObjectName("p3Left");

        gridLayout_3->addWidget(p3Left, 1, 0, 1, 1);

        p3Down = new QPushButton(verticalLayoutWidget);
        p3Down->setObjectName("p3Down");

        gridLayout_3->addWidget(p3Down, 1, 1, 1, 1);

        p3Up = new QPushButton(verticalLayoutWidget);
        p3Up->setObjectName("p3Up");

        gridLayout_3->addWidget(p3Up, 0, 1, 1, 1);

        p4Down = new QPushButton(verticalLayoutWidget);
        p4Down->setObjectName("p4Down");

        gridLayout_3->addWidget(p4Down, 1, 4, 1, 1);

        p4Right = new QPushButton(verticalLayoutWidget);
        p4Right->setObjectName("p4Right");

        gridLayout_3->addWidget(p4Right, 1, 5, 1, 1);

        p4Up = new QPushButton(verticalLayoutWidget);
        p4Up->setObjectName("p4Up");

        gridLayout_3->addWidget(p4Up, 0, 4, 1, 1);

        select = new QPushButton(verticalLayoutWidget);
        select->setObjectName("select");

        gridLayout_3->addWidget(select, 0, 0, 1, 1);


        horizontalLayout_10->addLayout(gridLayout_3);


        verticalLayout->addLayout(horizontalLayout_10);

        splitter->addWidget(verticalLayoutWidget);
        sourceView = new QTextBrowser(splitter);
        sourceView->setObjectName("sourceView");
        splitter->addWidget(sourceView);
        splitter_2->addWidget(splitter);
        layoutWidget = new QWidget(splitter_2);
        layoutWidget->setObjectName("layoutWidget");
        verticalLayout_2 = new QVBoxLayout(layoutWidget);
        verticalLayout_2->setObjectName("verticalLayout_2");
        verticalLayout_2->setContentsMargins(0, 0, 0, 0);
        horizontalLayout_4 = new QHBoxLayout();
        horizontalLayout_4->setObjectName("horizontalLayout_4");
        loadButton = new QPushButton(layoutWidget);
        loadButton->setObjectName("loadButton");

        horizontalLayout_4->addWidget(loadButton);

        reloadButton = new QPushButton(layoutWidget);
        reloadButton->setObjectName("reloadButton");

        horizontalLayout_4->addWidget(reloadButton);


        verticalLayout_2->addLayout(horizontalLayout_4);

        horizontalLayout_5 = new QHBoxLayout();
        horizontalLayout_5->setObjectName("horizontalLayout_5");
        stepButton = new QPushButton(layoutWidget);
        stepButton->setObjectName("stepButton");

        horizontalLayout_5->addWidget(stepButton);

        stepAmount = new QSlider(layoutWidget);
        stepAmount->setObjectName("stepAmount");
        stepAmount->setMinimum(1);
        stepAmount->setMaximum(100);
        stepAmount->setOrientation(Qt::Orientation::Horizontal);
        stepAmount->setTickPosition(QSlider::TickPosition::TicksBelow);

        horizontalLayout_5->addWidget(stepAmount);


        verticalLayout_2->addLayout(horizontalLayout_5);

        horizontalLayout_6 = new QHBoxLayout();
        horizontalLayout_6->setObjectName("horizontalLayout_6");
        playButton = new QPushButton(layoutWidget);
        playButton->setObjectName("playButton");

        horizontalLayout_6->addWidget(playButton);

        frameDelay = new QSlider(layoutWidget);
        frameDelay->setObjectName("frameDelay");
        frameDelay->setOrientation(Qt::Orientation::Horizontal);

        horizontalLayout_6->addWidget(frameDelay);


        verticalLayout_2->addLayout(horizontalLayout_6);

        horizontalLayout_2 = new QHBoxLayout();
        horizontalLayout_2->setObjectName("horizontalLayout_2");
        breakOn = new QCheckBox(layoutWidget);
        breakOn->setObjectName("breakOn");

        horizontalLayout_2->addWidget(breakOn);

        breakPoint = new QSpinBox(layoutWidget);
        breakPoint->setObjectName("breakPoint");
        breakPoint->setMaximum(4096);

        horizontalLayout_2->addWidget(breakPoint);


        verticalLayout_2->addLayout(horizontalLayout_2);

        horizontalLayout_9 = new QHBoxLayout();
        horizontalLayout_9->setObjectName("horizontalLayout_9");

        verticalLayout_2->addLayout(horizontalLayout_9);

        label = new QLabel(layoutWidget);
        label->setObjectName("label");

        verticalLayout_2->addWidget(label);

        instructionsPerFrame = new QSlider(layoutWidget);
        instructionsPerFrame->setObjectName("instructionsPerFrame");
        instructionsPerFrame->setMinimum(25);
        instructionsPerFrame->setMaximum(100000);
        instructionsPerFrame->setOrientation(Qt::Orientation::Horizontal);

        verticalLayout_2->addWidget(instructionsPerFrame);

        vsyncCheckBox = new QCheckBox(layoutWidget);
        vsyncCheckBox->setObjectName("vsyncCheckBox");

        verticalLayout_2->addWidget(vsyncCheckBox);

        horizontalLayout_3 = new QHBoxLayout();
        horizontalLayout_3->setObjectName("horizontalLayout_3");
        programCounter = new QLabel(layoutWidget);
        programCounter->setObjectName("programCounter");

        horizontalLayout_3->addWidget(programCounter);

        flags = new QLabel(layoutWidget);
        flags->setObjectName("flags");

        horizontalLayout_3->addWidget(flags);


        verticalLayout_2->addLayout(horizontalLayout_3);

        registerView = new QTableView(layoutWidget);
        registerView->setObjectName("registerView");

        verticalLayout_2->addWidget(registerView);

        horizontalLayout_8 = new QHBoxLayout();
        horizontalLayout_8->setObjectName("horizontalLayout_8");
        stackJump = new QPushButton(layoutWidget);
        stackJump->setObjectName("stackJump");

        horizontalLayout_8->addWidget(stackJump);

        RectJump = new QPushButton(layoutWidget);
        RectJump->setObjectName("RectJump");

        horizontalLayout_8->addWidget(RectJump);

        playerJump = new QPushButton(layoutWidget);
        playerJump->setObjectName("playerJump");

        horizontalLayout_8->addWidget(playerJump);

        followPC = new QCheckBox(layoutWidget);
        followPC->setObjectName("followPC");

        horizontalLayout_8->addWidget(followPC);


        verticalLayout_2->addLayout(horizontalLayout_8);

        memoryView = new QTableView(layoutWidget);
        memoryView->setObjectName("memoryView");

        verticalLayout_2->addWidget(memoryView);

        splitter_2->addWidget(layoutWidget);

        horizontalLayout_7->addWidget(splitter_2);

        MainWindow->setCentralWidget(centralwidget);

        retranslateUi(MainWindow);

        QMetaObject::connectSlotsByName(MainWindow);
    } // setupUi

    void retranslateUi(QMainWindow *MainWindow)
    {
        MainWindow->setWindowTitle(QCoreApplication::translate("MainWindow", "MainWindow", nullptr));
        onlyViewCheck->setText(QCoreApplication::translate("MainWindow", "Only Update View", nullptr));
        refreshViews->setText(QCoreApplication::translate("MainWindow", "Refresh Views", nullptr));
        resetButton->setText(QCoreApplication::translate("MainWindow", "Reset", nullptr));
        p1Down->setText(QCoreApplication::translate("MainWindow", "s", nullptr));
        p1Left->setText(QCoreApplication::translate("MainWindow", "a", nullptr));
        p1Right->setText(QCoreApplication::translate("MainWindow", "d", nullptr));
        p1Up->setText(QCoreApplication::translate("MainWindow", "w", nullptr));
        p2Down->setText(QCoreApplication::translate("MainWindow", "v", nullptr));
        p2Left->setText(QCoreApplication::translate("MainWindow", "<", nullptr));
        p2Right->setText(QCoreApplication::translate("MainWindow", ">", nullptr));
        p2Up->setText(QCoreApplication::translate("MainWindow", "^", nullptr));
        start->setText(QCoreApplication::translate("MainWindow", "Start", nullptr));
        p4Left->setText(QCoreApplication::translate("MainWindow", "F", nullptr));
        p3Right->setText(QCoreApplication::translate("MainWindow", "l", nullptr));
        p3Left->setText(QCoreApplication::translate("MainWindow", "j", nullptr));
        p3Down->setText(QCoreApplication::translate("MainWindow", "k", nullptr));
        p3Up->setText(QCoreApplication::translate("MainWindow", "i", nullptr));
        p4Down->setText(QCoreApplication::translate("MainWindow", "G", nullptr));
        p4Right->setText(QCoreApplication::translate("MainWindow", "H", nullptr));
        p4Up->setText(QCoreApplication::translate("MainWindow", "T", nullptr));
        select->setText(QCoreApplication::translate("MainWindow", "Select", nullptr));
        loadButton->setText(QCoreApplication::translate("MainWindow", "Load", nullptr));
        reloadButton->setText(QCoreApplication::translate("MainWindow", "Reload", nullptr));
        stepButton->setText(QCoreApplication::translate("MainWindow", "Step", nullptr));
        playButton->setText(QCoreApplication::translate("MainWindow", "Play", nullptr));
        breakOn->setText(QCoreApplication::translate("MainWindow", "BreakPoints", nullptr));
        label->setText(QCoreApplication::translate("MainWindow", "Steps Per Play Frame", nullptr));
        vsyncCheckBox->setText(QCoreApplication::translate("MainWindow", "Vsync Signal", nullptr));
        programCounter->setText(QCoreApplication::translate("MainWindow", "Program Counter: ", nullptr));
        flags->setText(QCoreApplication::translate("MainWindow", "Flags: ", nullptr));
        stackJump->setText(QCoreApplication::translate("MainWindow", "Stack", nullptr));
        RectJump->setText(QCoreApplication::translate("MainWindow", "Rect", nullptr));
        playerJump->setText(QCoreApplication::translate("MainWindow", "Player", nullptr));
        followPC->setText(QCoreApplication::translate("MainWindow", "Follow PC", nullptr));
    } // retranslateUi

};

namespace Ui {
    class MainWindow: public Ui_MainWindow {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_MAINWINDOW_H
