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

    const int tileSize = 32;

    int offsetX = model->getBackgroundOffsetX()/4;
    int offsetY = model->getBackgroundOffsetY()/4;

    int pixelOffsetX = offsetX % tileSize;
    int pixelOffsetY = offsetY % tileSize;

    for (int y = -tileSize; y < 480 + tileSize; y += tileSize) {
        for (int x = -tileSize; x < 640 + tileSize; x += tileSize) {

            int tileX = (x + offsetX) / tileSize;
            int tileY = (y + offsetY) / tileSize;

            bool isWhite = (tileX + tileY) % 2 == 0;
            QColor tileColor = isWhite ? QColor(80, 80, 80) : QColor(50, 50, 50);

            vgaPainter.fillRect(
                x - pixelOffsetX,
                y - pixelOffsetY,
                tileSize,
                tileSize,
                tileColor
                );
        }
    }
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

        int infoY = static_cast<int>(y)-5;

        vgaPainter.drawText(
            static_cast<int>(x),
            infoY,
            QString("P%1 Anim: %2").arg(i + 1).arg(anim)
            );
        // ----------------------------
        // Direction indicator
        // ----------------------------
        QPoint center = playerRect.center();

        // Arrow length
        int len = 15;

        // Direction vector
        QPoint dir(0, 0);

        switch (anim) {
        case 0: // circle
            vgaPainter.setPen(QPen(Qt::black, 2));
            vgaPainter.drawEllipse(center, 6, 6);
            break;
        case 1: dir = QPoint(1, 1); break;   // down-right
        case 2: dir = QPoint(1, 0); break;   // right
        case 3: dir = QPoint(1, -1); break;  // up-right
        case 4: dir = QPoint(0, -1); break;  // up
        case 5: dir = QPoint(-1, -1); break; // up-left
        case 6: dir = QPoint(-1, 0); break;  // left
        case 7: dir = QPoint(-1, 1); break;  // down-left
        }

        // Draw arrow if not 0
        if (anim != 0) {
            // Normalize diagonal so it's not longer
            if (dir.x() != 0 && dir.y() != 0) {
                dir /= 1.4142; // approx sqrt(2)
            }

            QPoint end = center + QPoint(dir.x() * len, dir.y() * len);

            QPen pen(Qt::black, 2);
            vgaPainter.setPen(pen);

            // Main line
            vgaPainter.drawLine(center, end);

            // Arrow head
            QPoint left = end + QPoint(-dir.y() * 5 - dir.x() * 5, dir.x() * 5 - dir.y() * 5);
            QPoint right = end + QPoint(dir.y() * 5 - dir.x() * 5, -dir.x() * 5 - dir.y() * 5);

            vgaPainter.drawLine(end, left);
            vgaPainter.drawLine(end, right);
        }
    }

    vgaPainter.end();
    QPainter painter(this);
    painter.fillRect(rect(), Qt::black);

    // original VGA size
    QSize vgaSize = vgaBuffer.size();
    QSize widgetSize = this->size();

    // scale preserving aspect ratio
    QSize scaledSize = vgaSize;
    scaledSize.scale(widgetSize, Qt::KeepAspectRatio);

    QRect targetRect(QPoint(0, 0), scaledSize);
    targetRect.moveCenter(rect().center());

    // draw centered, scaled VGA buffer
    painter.drawImage(targetRect, vgaBuffer);
    painter.setPen(Qt::white);
    painter.setFont(QFont("Arial", 10, QFont::Bold));

     painter.drawText(10, 20, QString("FPS: %1").arg(model->fps));


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
