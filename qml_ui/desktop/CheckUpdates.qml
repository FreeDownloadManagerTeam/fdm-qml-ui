import QtQuick 2.11
import "./BaseElements"
import "./Dialogs"
import "../common/Tools"

Item {
    height: parent.height

    UpdateTools {
        id: updateTools
    }

    ToolBarButton {
        id: updateArrows
        rotate: updateTools.arrowsRotate
        color: 'transparent'
        visible: updateTools.showArrows
        anchors.right: parent.right
        backgroundPositionX: appWindow.macVersion ? -240 : 20
        backgroundPositionY: appWindow.macVersion ? 0 : -457
        onClicked: updateTools.toggleDialog()
    }

    UpdateDialog {
        id: updateDlg
//        anchors.left: appWindow.macVersion ? updateArrows.left : undefined
        anchors.horizontalCenter: updateArrows.horizontalCenter//!appWindow.macVersion ? updateArrows.horizontalCenter : undefined
        y: updateArrows.y + updateArrows.height - 10
    }

    Connections {
        target: appWindow
        onCheckUpdates: updateTools.checkForUpdates()
    }
}
