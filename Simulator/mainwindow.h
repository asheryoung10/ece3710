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
    std::string filepath;
    bool isPlaying = false;
    void updateMemoryViewPartial();
    void loadFileIntoModel();
    void pausePlaySimulation();
    void pauseSimulation();
    void playSimulation();
    void slidersChanged();
    void reloadSimulation();
    void stepModel();
    void updateViews();
    void tickModel();
protected:
    void keyPressEvent(QKeyEvent *event) override;
    void keyReleaseEvent(QKeyEvent *event) override;
};
#endif // MAINWINDOW_H
