#include "vgaview.h"
#include <QPainter>
#include <QImage>

VGAView::VGAView(QWidget *parent)
    : QWidget(parent)
{
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

    // Player One
    uint16_t p1x = model->getPlayerOneX();
    uint16_t p1y = model->getPlayerOneY();
    uint16_t p1Anim = model->getPlayerOneAnimationIndex();
    uint16_t p1Score = model->getPlayerOneScore();
    uint16_t p1Audio = model->getPlayerOneAudioPitch();
    uint16_t p1Bg = model->getPlayerOneBackgroundIndex();

    // Draw player rectangle
    QRect playerOneRect(static_cast<int>(p1x), static_cast<int>(p1y), 64, 64);
    vgaPainter.fillRect(playerOneRect, QColor(255, 255, 255, 200));

    // Draw info above player
    vgaPainter.setPen(Qt::black);
    vgaPainter.setFont(QFont("Arial", 10, QFont::Bold));
    int infoY = static_cast<int>(p1y) - 48; // start above the player
    vgaPainter.drawText(static_cast<int>(p1x), infoY, QString("Anim: %1").arg(p1Anim));
    vgaPainter.drawText(static_cast<int>(p1x), infoY + 12, QString("Score: %1").arg(p1Score));
    vgaPainter.drawText(static_cast<int>(p1x), infoY + 24, QString("Audio: %1").arg(p1Audio));
    vgaPainter.drawText(static_cast<int>(p1x), infoY + 36, QString("BG: %1").arg(p1Bg));

    // Player Two
    uint16_t p2x = model->getPlayerTwoX();
    uint16_t p2y = model->getPlayerTwoY();
    uint16_t p2Anim = model->getPlayerTwoAnimationIndex();
    uint16_t p2Score = model->getPlayerTwoScore();
    uint16_t p2Audio = model->getPlayerTwoAudioPitch();
    uint16_t p2Bg = model->getPlayerTwoBackgroundIndex();

    // Draw player rectangle
    QRect playerTwoRect(static_cast<int>(p2x), static_cast<int>(p2y), 64, 64);
    vgaPainter.fillRect(playerTwoRect, QColor(200, 200, 255, 200));

    // Draw info above player
    infoY = static_cast<int>(p2y) - 48;
    vgaPainter.setPen(Qt::black);
    vgaPainter.drawText(static_cast<int>(p2x), infoY, QString("Anim: %1").arg(p2Anim));
    vgaPainter.drawText(static_cast<int>(p2x), infoY + 12, QString("Score: %1").arg(p2Score));
    vgaPainter.drawText(static_cast<int>(p2x), infoY + 24, QString("Audio: %1").arg(p2Audio));
    vgaPainter.drawText(static_cast<int>(p2x), infoY + 36, QString("BG: %1").arg(p2Bg));
    vgaPainter.end();

    // Paint scaled VGA buffer to widget
    QPainter painter(this);
    painter.fillRect(rect(), Qt::black);
    painter.drawImage(this->rect(), vgaBuffer);
}
