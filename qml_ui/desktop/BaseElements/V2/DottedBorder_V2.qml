import QtQuick

Item
{
    property color borderColor: appWindow.theme_v2.bg400
    property int borderRadius: 12
    property int borderLine: 12*appWindow.zoom
    property int borderSpace: 2*appWindow.zoom
    property int borderWidth: 2*appWindow.zoom

    Canvas
    {
        id: canvas

        anchors.fill: parent

        onPaint: {
            let ctx = getContext("2d");
            //ctx.clearRect(0, 0, width, height); // is it required actually?
            // Define the dash pattern: [dash length, space length]
            ctx.setLineDash([borderLine, borderSpace]);
            // Set line properties
            ctx.lineWidth = borderWidth;
            ctx.strokeStyle = borderColor;
            // Draw a rounded rectangle
            let x = ctx.lineWidth/2; // x position
            let y = ctx.lineWidth/2; // y position
            let w = width - ctx.lineWidth;
            let h = height - ctx.lineWidth;
            ctx.beginPath();
            ctx.moveTo(x + borderRadius, y);
            ctx.lineTo(x + w - borderRadius, y);
            ctx.arcTo(x + w, y, x + w, y + borderRadius, borderRadius);
            ctx.lineTo(x + w, y + h - borderRadius);
            ctx.arcTo(x + w, y + h, x + w - borderRadius, y + h, borderRadius);
            ctx.lineTo(x + borderRadius, y + h);
            ctx.arcTo(x, y + h, x, y + h - borderRadius, borderRadius);
            ctx.lineTo(x, y + borderRadius);
            ctx.arcTo(x, y, x + borderRadius, y, borderRadius);
            ctx.closePath();
            // Stroke the path
            ctx.stroke();
        }
    }

    function redraw()
    {
        if (visible)
            canvas.requestPaint()
    }

    onBorderColorChanged: redraw()
    onBorderRadiusChanged: redraw()
    onBorderLineChanged: redraw()
    onBorderSpaceChanged: redraw()
    onBorderWidthChanged: redraw()

    // Qt bug workaround
    onHeightChanged: redraw()
    onVisibleChanged: redraw()
}
