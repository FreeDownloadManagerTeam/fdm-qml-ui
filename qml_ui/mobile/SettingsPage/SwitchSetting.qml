import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts
import "../BaseElements"

ToolButton {
    id: root

    property bool switchChecked
    property string description

    property int textMargins: 20
    property int textHeighIncrement: 25
    property int textFontSize: 16

    anchors.left: parent.left
    anchors.right: parent.right

    implicitHeight: switch1Rect.implicitHeight
    implicitWidth: switch1Rect.implicitWidth

    contentItem: Rectangle {
        anchors.fill: switch1Rect
        color: "transparent"

        MouseArea
        {
            anchors.fill: parent
            onClicked: {
                root.clicked();
                circleAnimation.stop();
            }
            onPressed: function (mouse) {
                colorRect.x = mouseX
                colorRect.y = mouseY
                circleAnimation.start()
            }
            onReleased: circleAnimation.stop()
            onPositionChanged: circleAnimation.stop()
        }
    }

    background: Rectangle {
        id: switch1Rect
        anchors.left: parent.left
        anchors.right: parent.right
        color: "transparent"

        implicitHeight: labelText.implicitHeight + textHeighIncrement
        implicitWidth: labelText.implicitWidth + switch1.implicitWidth + 20

        clip: true

        //For animation
        Rectangle {
            id: colorRect
            height: 0
            width: 0
            color: appWindow.theme.tapAnimation
            transform: Translate {
                x: -colorRect.width / 2
                y: -colorRect.height / 2
            }
        }

        PropertyAnimation {
            id: circleAnimation
            target: colorRect
            properties: "width,height,radius"
            from: 0
            to: switch1Rect.width*3
            duration: 300

            onStopped: {
                colorRect.width = 0
                colorRect.height = 0
            }
        }

        BaseLabel {
            id: labelText
            anchors.left: parent.left
            anchors.right: switch1.left
            anchors.leftMargin: textMargins
            anchors.rightMargin: textMargins
            anchors.verticalCenter: parent.verticalCenter
            text: root.description
            font.pixelSize: textFontSize
            wrapMode: Text.WordWrap
            color: appWindow.theme.foreground
            opacity: root.enabled ? 1 : 0.5
        }

        BaseSwitch {
            id: switch1
            anchors.right: parent.right
            anchors.rightMargin: textMargins
            anchors.verticalCenter: parent.verticalCenter

            checked: root.switchChecked
        }
    }
}
