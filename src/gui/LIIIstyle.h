#pragma once

#include <QProxyStyle>


class LIIIStyle
    : public QProxyStyle
{
    Q_OBJECT

public:
    void drawControl(ControlElement element,    const QStyleOption* option,    QPainter* painter,    const QWidget* widget) const override;
    void drawPrimitive(PrimitiveElement element, const QStyleOption* option, QPainter* painter, const QWidget* widget) const override;
    int styleHint(StyleHint hint, const QStyleOption *option, const QWidget *widget, QStyleHintReturn *returnData) const override;
};
