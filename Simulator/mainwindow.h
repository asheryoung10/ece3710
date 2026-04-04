#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QTimer>
#include "model.h"
#include <QStandardItemModel>

QT_BEGIN_NAMESPACE
namespace Ui {
class MainWindow;
}
QT_END_NAMESPACE

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

private:
    QStandardItemModel* memoryModelQt;
    QStandardItemModel* registerModelQt;
    Ui::MainWindow *ui;
    Model model;
    QTimer* cpuTimer;
    void updateMemoryViewPartial();
    void loadFileIntoModel();
    void startSimulation();
    void pauseSimulation();
    void stepModel();
    void updateViews();
    void tickModel();
};
#endif // MAINWINDOW_H
