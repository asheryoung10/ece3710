#ifndef VGAVIEW_H
#define VGAVIEW_H

#include <QWidget>
#include "model.h"

class VGAView : public QWidget
{
    Q_OBJECT
public:
    explicit VGAView(QWidget* parent);
    void setModel(Model* model);

protected:
    void paintEvent(QPaintEvent *event) override;

private:
    Model* model = nullptr;
};

#endif // VGAVIEW_H
