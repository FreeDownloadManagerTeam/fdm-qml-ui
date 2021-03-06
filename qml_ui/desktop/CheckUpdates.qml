import QtQuick 2.11
import "./BaseElements"
import "./Dialogs"
import "../common/Tools"

Item {

    property int globalMaxX: 0

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
        source: appWindow.theme.mainTbImg.reverse
        onClicked: updateTools.toggleDialog()
        anchors.verticalCenter: parent.verticalCenter
    }

    UpdateDialog {
        id: updateDlg
        // try to center by arrows; however we must also fit into the main window
        x: Math.min(parent.mapFromGlobal(globalMaxX, 0).x - width - 5, updateArrows.x + updateArrows.width/2 - width/2)
        y: updateArrows.y + updateArrows.height - 5
        arrowCenterX: updateArrows.x - x + updateArrows.width/2
    }

    Connections {
        target: appWindow
        onCheckUpdates: updateTools.checkForUpdates()
    }
}
