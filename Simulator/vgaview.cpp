#include "vgaview.h"
#include <QPainter>
#include <QImage>

VGAView::VGAView(QWidget *parent)
    : QWidget(parent)
{
setFocusPolicy(Qt::StrongFocus);
    setStyleSheet("QWidget:focus { border: 2px solid red; }");
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

    // ----------------------------
    // Checkerboard background
    // ----------------------------
    const int tileSize = 32;
    for (int y = 0; y < 480; y += tileSize) {
        for (int x = 0; x < 640; x += tileSize) {
            bool isWhite = ((x / tileSize) + (y / tileSize)) % 2 == 0;
            QColor tileColor = isWhite ? QColor(80, 80, 80) : QColor(50, 50, 50);
            vgaPainter.fillRect(x, y, tileSize, tileSize, tileColor);
        }
    }

    // ----------------------------
    // Draw rectangles (unchanged)
    // ----------------------------
    for (int i = 0; i < 64; ++i) {
        Model::Rectangle r = model->getRectangle(i);

        QRect rect(
            static_cast<int>(r.x),
            static_cast<int>(r.y),
            static_cast<int>(r.width),
            static_cast<int>(r.height)
            );

        uint16_t color = r.color;
        int rC = ((color >> 11) & 0x1F) * 255 / 31;
        int gC = ((color >> 5) & 0x3F) * 255 / 63;
        int bC = (color & 0x1F) * 255 / 31;

        vgaPainter.fillRect(rect, QColor(rC, gC, bC));
    }

    // ----------------------------
    // Draw players (NEW SYSTEM)
    // ----------------------------
    const int PLAYER_COUNT = 4;

    for (int i = 0; i < PLAYER_COUNT; ++i) {
        uint16_t x = model->getPlayerX(i);
        uint16_t y = model->getPlayerY(i);
        uint16_t anim = model->getPlayerAnimationIndex(i);
        uint16_t color = model->getPlayerHighlightColor(i);

        QRect playerRect(
            static_cast<int>(x),
            static_cast<int>(y),
            45,
            41
            );

        // Convert highlight color (assuming RGB565 like rectangles)
        int rC = ((color >> 11) & 0x1F) * 255 / 31;
        int gC = ((color >> 5) & 0x3F) * 255 / 63;
        int bC = (color & 0x1F) * 255 / 31;

        QColor qColor(rC, gC, bC, 200);

        vgaPainter.fillRect(playerRect, qColor);

        // ----------------------------
        // Debug info
        // ----------------------------
        vgaPainter.setPen(Qt::black);
        vgaPainter.setFont(QFont("Arial", 10, QFont::Bold));

        int infoY = static_cast<int>(y) - 36;

        vgaPainter.drawText(
            static_cast<int>(x),
            infoY,
            QString("P%1 Anim: %2").arg(i + 1).arg(anim)
            );
    }

    vgaPainter.end();

    // ----------------------------
    // Present buffer
    // ----------------------------
    QPainter painter(this);
    painter.fillRect(rect(), Qt::black);
    painter.drawImage(this->rect(), vgaBuffer);

    if (hasFocus()) {
        QPen focusPen(Qt::red, 4);
        painter.setPen(focusPen);
        painter.drawRect(rect().adjusted(2, 2, -2, -2));
    }
}

void VGAView::mousePressEvent(QMouseEvent* event) {
    setFocus();
    QWidget::mousePressEvent(event);
}
