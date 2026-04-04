#include "vgaview.h"
#include <QPainter>
#include <QImage>

VGAView::VGAView(QWidget *parent)
    : QWidget(parent)
{
    setMinimumSize(640, 480);
}

void VGAView::setModel(Model* model) {
    this->model = model;
    update(); // trigger repaint
}

void VGAView::paintEvent(QPaintEvent *event)
{
    if (!model) return;

    // 640x480 virtual VGA buffer
    QImage vgaBuffer(640, 480, QImage::Format_RGB32);
    vgaBuffer.fill(Qt::black);

    QPainter vgaPainter(&vgaBuffer);

    // Draw 32x32 checkerboard background
    const int tileSize = 32;
    for (int y = 0; y < 480; y += tileSize) {
        for (int x = 0; x < 640; x += tileSize) {
            bool isWhite = ((x / tileSize) + (y / tileSize)) % 2 == 0;
            QColor tileColor = isWhite ? QColor(80, 80, 80) : QColor(50, 50, 50); // gray checkerboard
            vgaPainter.fillRect(x, y, tileSize, tileSize, tileColor);
        }
    }

    // Draw all 16 rectangles from model
    for (int i = 0; i < 16; ++i) {
        Model::Rectangle r = model->getRectangle(i);

        int x = static_cast<int>(r.x);
        int y = static_cast<int>(r.y);
        int w = static_cast<int>(r.width);
        int h = static_cast<int>(r.height);

        QRect rect(x, y, w, h);

        // Convert RGB565 to QColor
        uint16_t color = r.color;
        int rC = ((color >> 11) & 0x1F) * 255 / 31;
        int gC = ((color >> 5) & 0x3F) * 255 / 63;
        int bC = (color & 0x1F) * 255 / 31;
        QColor qcolor(rC, gC, bC);

        vgaPainter.fillRect(rect, qcolor);
    }

    // Draw player as 4x4 white rectangle
    uint16_t px = model->getPlayerX();
    uint16_t py = model->getPlayerY();
    QRect playerRect(static_cast<int>(px), static_cast<int>(py), 64, 64);
    vgaPainter.fillRect(playerRect, QColor(255, 255, 255, 200));

    vgaPainter.end();

    // Paint scaled VGA buffer to widget
    QPainter painter(this);
    painter.fillRect(rect(), Qt::black);
    painter.drawImage(this->rect(), vgaBuffer);
}
