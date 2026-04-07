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
    void setVsyncOff();
    void setVsyncOn();
    void setVsync(bool on);
    void jumpAddress();
    struct SourceInfo {
        QString file;   // filename
        int line;       // 1-based line number
    };
    static QString currentFileShown;
    static int currentLineShown;

    void advanceModel();
    void flash();

    QMap<uint16_t, SourceInfo> pcToSource;        // PC -> file + line
    QMap<SourceInfo, uint16_t> sourceToPC;        // PC -> file + line

    void parsePCMappingAndLoadSources(const QString &binFilePath);
    QMap<QString, QStringList> fileToLines;       // filename -> lines in file
    QString currentSourceFile;                    // currently displayed file
    void onSourceCursorChanged();
protected:
    void keyPressEvent(QKeyEvent *event) override;
    void keyReleaseEvent(QKeyEvent *event) override;
};
#endif // MAINWINDOW_H
