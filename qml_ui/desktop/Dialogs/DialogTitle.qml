import QtQuick 2.0
import '../BaseElements'

Rectangle {

    id: root

    property string text

    signal closeClick

    height: 36
    color: appWindow.theme.dialogTitleBackground

    Rectangle {
        anchors.fill: parent
        visible: appWindow.macVersion && appWindow.theme === lightTheme
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#ececec" }
            GradientStop { position: 1.0; color: "#dddcdc" }
        }
    }

    Rectangle {
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        color: "transparent"

        BaseLabel {
            anchors.verticalCenter: parent.verticalCenter
            text: root.text
            color: appWindow.macVersion ? appWindow.theme.dialogTitleMac : appWindow.theme.dialogTitle
        }

        Rectangle {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            height: 24
            width: 24
            clip: true
            color: "transparent"

            Image {
                source: appWindow.theme.elementsIcons
                sourceSize.width: 93
                sourceSize.height: 456
                x: 6
                y: -366
            }

            MouseArea {
                anchors.fill: parent
                onClicked: root.closeClick()
            }
        }
    }
}
