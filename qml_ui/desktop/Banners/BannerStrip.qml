import QtQuick

Rectangle
{
    property bool isShutdownBanner: false

    width: parent.width
    height: parent.height

    color: appWindow.uiver === 1 ?
               (isShutdownBanner ? appWindow.theme.shutdownBannerBackground : appWindow.theme.bannerBackground) :
               appWindow.theme_v2.bg400

    Rectangle {
        visible: appWindow.uiver !== 1
        width: parent.width
        height: 1
        color: appWindow.theme_v2.bg200
    }
}
