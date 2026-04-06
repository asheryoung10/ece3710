/********************************************************************************
** Form generated from reading UI file 'mainwindow.ui'
**
** Created by: Qt User Interface Compiler version 5.15.3
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_MAINWINDOW_H
#define UI_MAINWINDOW_H

#include <QtCore/QVariant>
#include <QtWidgets/QApplication>
#include <QtWidgets/QCheckBox>
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
    QPushButton *leftButton;
    QPushButton *rightButton;
    QPushButton *jumpButton;
    QPushButton *resetButton;
    QTextBrowser *sourceView;
    QWidget *layoutWidget;
    QVBoxLayout *verticalLayout_2;
    QHBoxLayout *horizontalLayout_4;
    QPushButton *loadButton;
    QPushButton *reloadButton;
    QHBoxLayout *horizontalLayout_2;
    QHBoxLayout *horizontalLayout_5;
    QPushButton *stepButton;
    QSlider *stepAmount;
    QHBoxLayout *horizontalLayout_6;
    QPushButton *playButton;
    QSlider *frameDelay;
    QLabel *label;
    QSlider *instructionsPerFrame;
    QCheckBox *vsyncCheckBox;
    QHBoxLayout *horizontalLayout_3;
    QLabel *programCounter;
    QLabel *flags;
    QTableView *registerView;
    QHBoxLayout *horizontalLayout_8;
    QPushButton *jumptoAddressButton;
    QSpinBox *jumpAddress;
    QTableView *memoryView;

    void setupUi(QMainWindow *MainWindow)
    {
        if (MainWindow->objectName().isEmpty())
            MainWindow->setObjectName(QString::fromUtf8("MainWindow"));
        MainWindow->resize(800, 600);
        centralwidget = new QWidget(MainWindow);
        centralwidget->setObjectName(QString::fromUtf8("centralwidget"));
        horizontalLayout_7 = new QHBoxLayout(centralwidget);
        horizontalLayout_7->setObjectName(QString::fromUtf8("horizontalLayout_7"));
        splitter_2 = new QSplitter(centralwidget);
        splitter_2->setObjectName(QString::fromUtf8("splitter_2"));
        splitter_2->setOrientation(Qt::Orientation::Horizontal);
        splitter = new QSplitter(splitter_2);
        splitter->setObjectName(QString::fromUtf8("splitter"));
        splitter->setOrientation(Qt::Orientation::Vertical);
        verticalLayoutWidget = new QWidget(splitter);
        verticalLayoutWidget->setObjectName(QString::fromUtf8("verticalLayoutWidget"));
        verticalLayout = new QVBoxLayout(verticalLayoutWidget);
        verticalLayout->setObjectName(QString::fromUtf8("verticalLayout"));
        verticalLayout->setContentsMargins(0, 0, 0, 0);
        vgaView = new VGAView(verticalLayoutWidget);
        vgaView->setObjectName(QString::fromUtf8("vgaView"));

        verticalLayout->addWidget(vgaView);

        horizontalLayout = new QHBoxLayout();
        horizontalLayout->setObjectName(QString::fromUtf8("horizontalLayout"));
        onlyViewCheck = new QCheckBox(verticalLayoutWidget);
        onlyViewCheck->setObjectName(QString::fromUtf8("onlyViewCheck"));

        horizontalLayout->addWidget(onlyViewCheck);

        leftButton = new QPushButton(verticalLayoutWidget);
        leftButton->setObjectName(QString::fromUtf8("leftButton"));

        horizontalLayout->addWidget(leftButton);

        rightButton = new QPushButton(verticalLayoutWidget);
        rightButton->setObjectName(QString::fromUtf8("rightButton"));

        horizontalLayout->addWidget(rightButton);

        jumpButton = new QPushButton(verticalLayoutWidget);
        jumpButton->setObjectName(QString::fromUtf8("jumpButton"));

        horizontalLayout->addWidget(jumpButton);

        resetButton = new QPushButton(verticalLayoutWidget);
        resetButton->setObjectName(QString::fromUtf8("resetButton"));

        horizontalLayout->addWidget(resetButton);


        verticalLayout->addLayout(horizontalLayout);

        splitter->addWidget(verticalLayoutWidget);
        sourceView = new QTextBrowser(splitter);
        sourceView->setObjectName(QString::fromUtf8("sourceView"));
        splitter->addWidget(sourceView);
        splitter_2->addWidget(splitter);
        layoutWidget = new QWidget(splitter_2);
        layoutWidget->setObjectName(QString::fromUtf8("layoutWidget"));
        verticalLayout_2 = new QVBoxLayout(layoutWidget);
        verticalLayout_2->setObjectName(QString::fromUtf8("verticalLayout_2"));
        verticalLayout_2->setContentsMargins(0, 0, 0, 0);
        horizontalLayout_4 = new QHBoxLayout();
        horizontalLayout_4->setObjectName(QString::fromUtf8("horizontalLayout_4"));
        loadButton = new QPushButton(layoutWidget);
        loadButton->setObjectName(QString::fromUtf8("loadButton"));

        horizontalLayout_4->addWidget(loadButton);

        reloadButton = new QPushButton(layoutWidget);
        reloadButton->setObjectName(QString::fromUtf8("reloadButton"));

        horizontalLayout_4->addWidget(reloadButton);


        verticalLayout_2->addLayout(horizontalLayout_4);

        horizontalLayout_2 = new QHBoxLayout();
        horizontalLayout_2->setObjectName(QString::fromUtf8("horizontalLayout_2"));

        verticalLayout_2->addLayout(horizontalLayout_2);

        horizontalLayout_5 = new QHBoxLayout();
        horizontalLayout_5->setObjectName(QString::fromUtf8("horizontalLayout_5"));
        stepButton = new QPushButton(layoutWidget);
        stepButton->setObjectName(QString::fromUtf8("stepButton"));

        horizontalLayout_5->addWidget(stepButton);

        stepAmount = new QSlider(layoutWidget);
        stepAmount->setObjectName(QString::fromUtf8("stepAmount"));
        stepAmount->setMinimum(1);
        stepAmount->setMaximum(100);
        stepAmount->setOrientation(Qt::Orientation::Horizontal);
        stepAmount->setTickPosition(QSlider::TickPosition::TicksBelow);

        horizontalLayout_5->addWidget(stepAmount);


        verticalLayout_2->addLayout(horizontalLayout_5);

        horizontalLayout_6 = new QHBoxLayout();
        horizontalLayout_6->setObjectName(QString::fromUtf8("horizontalLayout_6"));
        playButton = new QPushButton(layoutWidget);
        playButton->setObjectName(QString::fromUtf8("playButton"));

        horizontalLayout_6->addWidget(playButton);

        frameDelay = new QSlider(layoutWidget);
        frameDelay->setObjectName(QString::fromUtf8("frameDelay"));
        frameDelay->setOrientation(Qt::Orientation::Horizontal);

        horizontalLayout_6->addWidget(frameDelay);


        verticalLayout_2->addLayout(horizontalLayout_6);

        label = new QLabel(layoutWidget);
        label->setObjectName(QString::fromUtf8("label"));

        verticalLayout_2->addWidget(label);

        instructionsPerFrame = new QSlider(layoutWidget);
        instructionsPerFrame->setObjectName(QString::fromUtf8("instructionsPerFrame"));
        instructionsPerFrame->setMinimum(25);
        instructionsPerFrame->setMaximum(500);
        instructionsPerFrame->setOrientation(Qt::Orientation::Horizontal);

        verticalLayout_2->addWidget(instructionsPerFrame);

        vsyncCheckBox = new QCheckBox(layoutWidget);
        vsyncCheckBox->setObjectName(QString::fromUtf8("vsyncCheckBox"));

        verticalLayout_2->addWidget(vsyncCheckBox);

        horizontalLayout_3 = new QHBoxLayout();
        horizontalLayout_3->setObjectName(QString::fromUtf8("horizontalLayout_3"));
        programCounter = new QLabel(layoutWidget);
        programCounter->setObjectName(QString::fromUtf8("programCounter"));

        horizontalLayout_3->addWidget(programCounter);

        flags = new QLabel(layoutWidget);
        flags->setObjectName(QString::fromUtf8("flags"));

        horizontalLayout_3->addWidget(flags);


        verticalLayout_2->addLayout(horizontalLayout_3);

        registerView = new QTableView(layoutWidget);
        registerView->setObjectName(QString::fromUtf8("registerView"));

        verticalLayout_2->addWidget(registerView);

        horizontalLayout_8 = new QHBoxLayout();
        horizontalLayout_8->setObjectName(QString::fromUtf8("horizontalLayout_8"));
        jumptoAddressButton = new QPushButton(layoutWidget);
        jumptoAddressButton->setObjectName(QString::fromUtf8("jumptoAddressButton"));

        horizontalLayout_8->addWidget(jumptoAddressButton);

        jumpAddress = new QSpinBox(layoutWidget);
        jumpAddress->setObjectName(QString::fromUtf8("jumpAddress"));
        jumpAddress->setMaximum(65535);

        horizontalLayout_8->addWidget(jumpAddress);


        verticalLayout_2->addLayout(horizontalLayout_8);

        memoryView = new QTableView(layoutWidget);
        memoryView->setObjectName(QString::fromUtf8("memoryView"));

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
        leftButton->setText(QCoreApplication::translate("MainWindow", "Left", nullptr));
        rightButton->setText(QCoreApplication::translate("MainWindow", "Right", nullptr));
        jumpButton->setText(QCoreApplication::translate("MainWindow", "Jump", nullptr));
        resetButton->setText(QCoreApplication::translate("MainWindow", "Reset", nullptr));
        loadButton->setText(QCoreApplication::translate("MainWindow", "Load", nullptr));
        reloadButton->setText(QCoreApplication::translate("MainWindow", "Reload", nullptr));
        stepButton->setText(QCoreApplication::translate("MainWindow", "Step", nullptr));
        playButton->setText(QCoreApplication::translate("MainWindow", "Play", nullptr));
        label->setText(QCoreApplication::translate("MainWindow", "Steps Per Play Frame", nullptr));
        vsyncCheckBox->setText(QCoreApplication::translate("MainWindow", "Vsync Signal", nullptr));
        programCounter->setText(QCoreApplication::translate("MainWindow", "Program Counter: ", nullptr));
        flags->setText(QCoreApplication::translate("MainWindow", "Flags: ", nullptr));
        jumptoAddressButton->setText(QCoreApplication::translate("MainWindow", "Jump To Address", nullptr));
    } // retranslateUi

};

namespace Ui {
    class MainWindow: public Ui_MainWindow {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_MAINWINDOW_H
