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
#include <QtWidgets/QHBoxLayout>
#include <QtWidgets/QHeaderView>
#include <QtWidgets/QLabel>
#include <QtWidgets/QMainWindow>
#include <QtWidgets/QPushButton>
#include <QtWidgets/QSlider>
#include <QtWidgets/QSplitter>
#include <QtWidgets/QTableView>
#include <QtWidgets/QVBoxLayout>
#include <QtWidgets/QWidget>
#include "vgaview.h"

QT_BEGIN_NAMESPACE

class Ui_MainWindow
{
public:
    QWidget *centralwidget;
    QVBoxLayout *verticalLayout;
    QSplitter *splitter;
    QWidget *verticalLayoutWidget;
    QVBoxLayout *verticalLayout_3;
    VGAView *vgaView;
    QHBoxLayout *horizontalLayout;
    QPushButton *leftButton;
    QPushButton *rightButton;
    QPushButton *jumpButton;
    QPushButton *resetButton;
    QWidget *widget;
    QVBoxLayout *verticalLayout_2;
    QPushButton *loadButton;
    QHBoxLayout *horizontalLayout_2;
    QPushButton *pauseButton;
    QPushButton *stepButton;
    QPushButton *playButton;
    QSlider *stepAmount;
    QSlider *frameDelay;
    QHBoxLayout *horizontalLayout_3;
    QLabel *programCounter;
    QLabel *flags;
    QTableView *registerView;
    QTableView *memoryView;

    void setupUi(QMainWindow *MainWindow)
    {
        if (MainWindow->objectName().isEmpty())
            MainWindow->setObjectName(QString::fromUtf8("MainWindow"));
        MainWindow->resize(800, 600);
        centralwidget = new QWidget(MainWindow);
        centralwidget->setObjectName(QString::fromUtf8("centralwidget"));
        verticalLayout = new QVBoxLayout(centralwidget);
        verticalLayout->setObjectName(QString::fromUtf8("verticalLayout"));
        splitter = new QSplitter(centralwidget);
        splitter->setObjectName(QString::fromUtf8("splitter"));
        splitter->setOrientation(Qt::Orientation::Horizontal);
        verticalLayoutWidget = new QWidget(splitter);
        verticalLayoutWidget->setObjectName(QString::fromUtf8("verticalLayoutWidget"));
        verticalLayout_3 = new QVBoxLayout(verticalLayoutWidget);
        verticalLayout_3->setObjectName(QString::fromUtf8("verticalLayout_3"));
        verticalLayout_3->setContentsMargins(0, 0, 0, 0);
        vgaView = new VGAView(verticalLayoutWidget);
        vgaView->setObjectName(QString::fromUtf8("vgaView"));

        verticalLayout_3->addWidget(vgaView);

        horizontalLayout = new QHBoxLayout();
        horizontalLayout->setObjectName(QString::fromUtf8("horizontalLayout"));
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


        verticalLayout_3->addLayout(horizontalLayout);

        splitter->addWidget(verticalLayoutWidget);
        widget = new QWidget(splitter);
        widget->setObjectName(QString::fromUtf8("widget"));
        verticalLayout_2 = new QVBoxLayout(widget);
        verticalLayout_2->setObjectName(QString::fromUtf8("verticalLayout_2"));
        verticalLayout_2->setContentsMargins(0, 0, 0, 0);
        loadButton = new QPushButton(widget);
        loadButton->setObjectName(QString::fromUtf8("loadButton"));

        verticalLayout_2->addWidget(loadButton);

        horizontalLayout_2 = new QHBoxLayout();
        horizontalLayout_2->setObjectName(QString::fromUtf8("horizontalLayout_2"));
        pauseButton = new QPushButton(widget);
        pauseButton->setObjectName(QString::fromUtf8("pauseButton"));

        horizontalLayout_2->addWidget(pauseButton);

        stepButton = new QPushButton(widget);
        stepButton->setObjectName(QString::fromUtf8("stepButton"));

        horizontalLayout_2->addWidget(stepButton);

        playButton = new QPushButton(widget);
        playButton->setObjectName(QString::fromUtf8("playButton"));

        horizontalLayout_2->addWidget(playButton);


        verticalLayout_2->addLayout(horizontalLayout_2);

        stepAmount = new QSlider(widget);
        stepAmount->setObjectName(QString::fromUtf8("stepAmount"));
        stepAmount->setMinimum(1);
        stepAmount->setMaximum(100);
        stepAmount->setOrientation(Qt::Orientation::Horizontal);
        stepAmount->setTickPosition(QSlider::TickPosition::TicksBelow);

        verticalLayout_2->addWidget(stepAmount);

        frameDelay = new QSlider(widget);
        frameDelay->setObjectName(QString::fromUtf8("frameDelay"));
        frameDelay->setOrientation(Qt::Orientation::Horizontal);

        verticalLayout_2->addWidget(frameDelay);

        horizontalLayout_3 = new QHBoxLayout();
        horizontalLayout_3->setObjectName(QString::fromUtf8("horizontalLayout_3"));
        programCounter = new QLabel(widget);
        programCounter->setObjectName(QString::fromUtf8("programCounter"));

        horizontalLayout_3->addWidget(programCounter);

        flags = new QLabel(widget);
        flags->setObjectName(QString::fromUtf8("flags"));

        horizontalLayout_3->addWidget(flags);


        verticalLayout_2->addLayout(horizontalLayout_3);

        registerView = new QTableView(widget);
        registerView->setObjectName(QString::fromUtf8("registerView"));

        verticalLayout_2->addWidget(registerView);

        memoryView = new QTableView(widget);
        memoryView->setObjectName(QString::fromUtf8("memoryView"));

        verticalLayout_2->addWidget(memoryView);

        splitter->addWidget(widget);

        verticalLayout->addWidget(splitter);

        MainWindow->setCentralWidget(centralwidget);

        retranslateUi(MainWindow);

        QMetaObject::connectSlotsByName(MainWindow);
    } // setupUi

    void retranslateUi(QMainWindow *MainWindow)
    {
        MainWindow->setWindowTitle(QCoreApplication::translate("MainWindow", "MainWindow", nullptr));
        leftButton->setText(QCoreApplication::translate("MainWindow", "Left", nullptr));
        rightButton->setText(QCoreApplication::translate("MainWindow", "Right", nullptr));
        jumpButton->setText(QCoreApplication::translate("MainWindow", "Jump", nullptr));
        resetButton->setText(QCoreApplication::translate("MainWindow", "Reset", nullptr));
        loadButton->setText(QCoreApplication::translate("MainWindow", "Load", nullptr));
        pauseButton->setText(QCoreApplication::translate("MainWindow", "Pause", nullptr));
        stepButton->setText(QCoreApplication::translate("MainWindow", "Step", nullptr));
        playButton->setText(QCoreApplication::translate("MainWindow", "Play", nullptr));
        programCounter->setText(QCoreApplication::translate("MainWindow", "Program Counter: ", nullptr));
        flags->setText(QCoreApplication::translate("MainWindow", "Flags: ", nullptr));
    } // retranslateUi

};

namespace Ui {
    class MainWindow: public Ui_MainWindow {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_MAINWINDOW_H
