import QtQuick 2.0

Item {
    id: root
    readonly property int smallSize: 1
    readonly property int mediumSize: 2
    readonly property int highSize: 3

    readonly property int currentWidth: appWindow.width;
    readonly property int currentHeight: appWindow.height;
    readonly property int currentWidthType: getWindowWidthType(currentWidth);

    function getWindowWidthType(width)
    {
        if (currentWidth < 500) {
            return root.smallSize
        }
        if (currentWidth / ( appWindow.screen.pixelDensity * 25.4 ) > 4.5 && currentWidth > 799) {
            return root.highSize
        }
        return root.mediumSize;
    }
}
