import QtQuick 2.11
import "./BaseElements"
import "./Dialogs"
import "../common/Tools"

Item {

    id: root

    property var toolbarCtrl
    property int globalMaxX: toolbarCtrl && shouldBeVisible ?
                                 toolbarCtrl.mapToGlobal(toolbarCtrl.width, 0).x + toolbarCtrl.x*0 + appWindow.x*0 :
                                 0

    readonly property bool shouldBeVisible: updateTools.showArrows

    implicitHeight: updateArrows.implicitHeight
    implicitWidth: updateArrows.implicitWidth

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
        property int workaroundX: 0 // workaround for the x position of updateDlg not updating properly
        Timer {
            interval: 30
            running: parent.visible
            onTriggered: ++parent.workaroundX
        }

        // try to center by arrows; however we must also fit into the main window
        x: (LayoutMirroring.enabled ?
               Math.max(5*appWindow.zoom, updateArrows.x + updateArrows.width/2 - width/2) :
               Math.min(parent.mapFromGlobal(globalMaxX, 0).x - width - 5*appWindow.zoom, updateArrows.x + updateArrows.width/2 - width/2))
               + root.x*0 + workaroundX*0
        y: updateArrows.y + updateArrows.height - 5*appWindow.zoom
        arrowCenterX: updateArrows.x - x + updateArrows.width/2
    }

    Connections {
        target: appWindow
        onCheckUpdates: updateTools.checkForUpdates()
    }
}
