#ifndef VGAVIEW_H
#define VGAVIEW_H

#include <QWidget>
#include "model.h"
#include <QMouseEvent> // needed for mousePressEvent

class VGAView : public QWidget
{
    Q_OBJECT
public:
    explicit VGAView(QWidget* parent);
    void setModel(Model* model);

protected:
    void paintEvent(QPaintEvent *event) override;
    void mousePressEvent(QMouseEvent* event) override;  // <-- add this

private:
    Model* model = nullptr;
};

#endif // VGAVIEW_H
