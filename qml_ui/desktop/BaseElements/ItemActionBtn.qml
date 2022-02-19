import QtQuick 2.12

Image
{
    id: root

    property var buttonType
    property string moduleUid: ""

    signal clicked()

    width: 17
    height: 15

    opacity: root.enabled ? 1 : 0.3

    sourceSize: Qt.size(width, height)

    source: buttonType === "showInFolder" && moduleUid === "downloadsbt" ? appWindow.theme.btDldOpenFolder :
            buttonType === "showInFolder" ? appWindow.theme.folder :
            buttonType === "restart" ? appWindow.theme.restart :
            buttonType === "pause" ? appWindow.theme.pause2 :
            buttonType === "start" ? appWindow.theme.play2 :
            buttonType === "scheduler" ? appWindow.theme.alarm : ""

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
