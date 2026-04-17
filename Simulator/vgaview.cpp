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

    int cameraX = -model->getBackgroundOffsetX();
    int cameraY = -model->getBackgroundOffsetY();

    // Screen size
    const int screenW = 640;
    const int screenH = 480;

    // Align camera to pixel grid (VERY important for stability)
    int worldStartX = cameraX;
    int worldStartY = cameraY;

    // Find first visible tile index
    int startTileX = floor((float)worldStartX / tileSize);
    int startTileY = floor((float)worldStartY / tileSize);

    // Pixel offset inside tile
    int offsetX = worldStartX % tileSize;
    int offsetY = worldStartY % tileSize;

    // Fix negative modulo
    if (offsetX < 0) offsetX += tileSize;
    if (offsetY < 0) offsetY += tileSize;

    // Convert back to screen start
    int startScreenX = -offsetX;
    int startScreenY = -offsetY;

    for (int y = startScreenY, ty = startTileY; y < screenH + tileSize; y += tileSize, ty++) {
        for (int x = startScreenX, tx = startTileX; x < screenW + tileSize; x += tileSize, tx++) {

            bool isWhite = ((tx + ty) & 1) == 0;

            QColor tileColor = isWhite
                                   ? QColor(80, 80, 80)
                                   : QColor(50, 50, 50);

            vgaPainter.fillRect(
                x,
                y,
                tileSize,
                tileSize,
                tileColor
                );
        }
    }
    for (int i = 0; i < 64; ++i) {
        Model::Rectangle r = model->getRectangle(i);

        int x = (int16_t)r.x;
        int y = (int16_t)r.y;
        int w = (int16_t)r.width;
        int h = (int16_t)r.height;

        QRect rect(x, y, w, h);

        uint16_t color = r.color;
        int rC = ((color >> 11) & 0x1F) * 255 / 31;
        int gC = ((color >> 5) & 0x3F) * 255 / 63;
        int bC = (color & 0x1F) * 255 / 31;

        vgaPainter.fillRect(rect, QColor(rC, gC, bC));
    }
    const int PLAYER_COUNT = 4;

    static QImage spriteSheet(":/data/assets/monkey.png");
    for (int i = 0; i < PLAYER_COUNT; ++i) {
        uint16_t x = model->getPlayerX(i);
        uint16_t y = model->getPlayerY(i);
        uint16_t anim = model->getPlayerAnimationIndex(i);
        uint16_t color = model->getPlayerHighlightColor(i);
        uint16_t audio = model->getAudioPitchIndex();

        QRect playerRect(x, y, 16, 16);

        // decode RGB565
        int rC = ((color >> 11) & 0x1F) * 255 / 31;
        int gC = ((color >> 5) & 0x3F) * 255 / 63;
        int bC = (color & 0x1F) * 255 / 31;

        QColor tint(rC, gC, bC);

        int SPRITE_SIZE = 16;
        int SPRITES_PER_ROW = 6;

        int sx = (anim % SPRITES_PER_ROW) * SPRITE_SIZE;
        int sy = (anim / SPRITES_PER_ROW) * SPRITE_SIZE;

        for (int py = 0; py < 16; ++py) {
            for (int px = 0; px < 16; ++px) {

                QColor src = spriteSheet.pixelColor(sx + px, sy + py);

                // transparency rule: "all 0s"
                if (src.red() == 0 && src.green() == 0 && src.blue() == 0)
                    continue;

                // apply tint (simple multiply-style blend)
                QColor outColor(
                    (src.red()   * tint.red())   / 255,
                    (src.green() * tint.green()) / 255,
                    (src.blue()  * tint.blue())  / 255
                    );

                vgaPainter.setPen(outColor);
                int scale = model->getPlayerScale(i);
                if(scale < 1 || scale > 10) {
                    //qDebug() << "Scale not right?: " << scale << "\n";
                }
                for (int syScale = 0; syScale < scale; ++syScale) {
                    for (int sxScale = 0; sxScale < scale; ++sxScale) {
                        vgaPainter.drawPoint(
                            x + px * scale + sxScale,
                            y + py * scale + syScale
                            );
                    }
                }
            }
        }

        // Debug text
        vgaPainter.setPen(Qt::black);
        vgaPainter.setFont(QFont("Arial", 10, QFont::Bold));

        vgaPainter.drawText(
            x,
            y - 5,
            QString("P%1 Anim: %2 Aud: %3").arg(i + 1).arg(anim).arg(audio)
            );
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
