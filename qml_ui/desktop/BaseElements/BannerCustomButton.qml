import QtQuick 2.6
import QtQuick.Controls 2.1

Button {

    id: customBtn

    property bool enabled: true
    property int radius: 0

    leftPadding: 10*appWindow.zoom
    rightPadding: 10*appWindow.zoom
    opacity: enabled ? 1 : 0.4

    property bool isHovered: false
    property bool isPressed: false

    background: Rectangle {
        implicitHeight: 22*appWindow.zoom
        implicitWidth: Math.max(labelElement.implicitWidth + 6*appWindow.zoom, 60*appWindow.zoom)

        border.color: "#d4d4d4"
        border.width: 1*appWindow.zoom
        radius: customBtn.radius
    }

    contentItem: BaseLabel {
        id: labelElement
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: parent.text
        color: "#000"
        font.pixelSize: 13*appWindow.fontZoom
        font.family: Qt.platform.os === "osx" ? font.family : "Arial"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: parent.clicked()

        hoverEnabled: true
        onEntered: customBtn.isHovered = true
        onExited: customBtn.isHovered = false
        onPressed: customBtn.isPressed = true
        onReleased: customBtn.isPressed = false
    }



    function getGradientColorTop()
    {
             if (!customBtn.enabled) {
                return "#f0f0f0";
            }
            if (customBtn.isHovered) {
                if (customBtn.isPressed) {
                    return "#e5e5e5";
                } else {
                    return "#ffffff";
                }

            } else {
                return "#f0f0f0";
            }
    }

    function getGradientColorBottom()
    {
            if (!customBtn.enabled) {
                return "#e5e5e5";
            }
            if (customBtn.isHovered) {
                if (customBtn.isPressed) {
                    return "#dbdbdb";
                } else {
                    return "#f5f5f5";
                }

            } else {
                return "#e5e5e5";
            }
    }
}
