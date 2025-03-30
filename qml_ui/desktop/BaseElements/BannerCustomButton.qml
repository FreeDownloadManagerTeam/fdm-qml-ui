import QtQuick 2.6
import QtQuick.Controls 2.1

Button {

    id: customBtn

    property bool enabled: true
    property int radius: appWindow.uiver === 1 ? 0 : 4*appWindow.zoom

    leftPadding: (appWindow.uiver === 1 ? 10 : 16)*appWindow.zoom
    rightPadding: leftPadding
    topPadding: (appWindow.uiver === 1 ? 5 : 4)*appWindow.zoom
    bottomPadding: topPadding

    opacity: enabled ? 1 : (appWindow.uiver === 1 ? 0.4 : appWindow.theme_v2.opacityDisabled)

    property bool isHovered: false
    property bool isPressed: false

    background: Rectangle {
        color: appWindow.uiver === 1 ? "white" : appWindow.theme_v2.bg300
        border.color: appWindow.uiver === 1 ? "#d4d4d4" : appWindow.theme_v2.bg500
        border.width: 1*appWindow.zoom
        radius: customBtn.radius
    }

    contentItem: BaseLabel {
        id: labelElement
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: parent.text
        color: appWindow.uiver === 1 ? "#000" : appWindow.theme_v2.bg700
        font.pixelSize: (appWindow.uiver === 1 ? 13 : 12)*appWindow.fontZoom
        font.weight: appWindow.uiver === 1 ? 400 : 500
    }

    MouseArea {
        anchors.fill: parent
        onClicked: parent.clicked()

        hoverEnabled: true
        onEntered: customBtn.isHovered = true
        onExited: customBtn.isHovered = false
        onPressed: customBtn.isPressed = true
        onReleased: customBtn.isPressed = false

        cursorShape: appWindow.uiver === 1 ? Qt.ArrowCursor : Qt.PointingHandCursor
    }
}
