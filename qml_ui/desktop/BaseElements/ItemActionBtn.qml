import QtQuick
import org.freedownloadmanager.fdm
import "../../common"

WaSvgImage
{
    id: root

    property var buttonType
    property string moduleUid: ""

    signal clicked()

    zoom: appWindow.zoom

    opacity: root.enabled ? 1 : 0.3

    source: buttonType === "showInFolder" && moduleUid === "downloadsbt" ? appWindow.theme.btDldOpenFolder :
            buttonType === "showInFolder" ? appWindow.theme.folder :
            buttonType === "restart" ? appWindow.theme.restart :
            buttonType === "pause" ? appWindow.theme.pause2 :
            buttonType === "start" ? appWindow.theme.play2 :
            buttonType === "scheduler" ? appWindow.theme.alarm : ""

    MouseArea {
        visible: buttonType !== "showInFolder" || !App.rc.client.active
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
