import QtQuick
import QtQuick.Layouts
import "./BaseElements"
import "./BaseElements/V2"
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

    RowLayout {
        id: updateArrows
        visible: updateTools.showArrows
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter

        ToolBarButton {
            visible: appWindow.uiver === 1
            rotate: updateTools.arrowsRotate
            color: 'transparent'
            source: appWindow.theme.mainTbImg.reverse
            onClicked: updateTools.toggleDialog()
        }

        ToolbarFlatButton_V2 {
            visible: appWindow.uiver !== 1
            bgColor: "transparent"
            leftPadding: 0
            rightPadding: 0
            topPadding: 0
            bottomPadding: 0
            iconSource: Qt.resolvedUrl("V2/reverse.svg")
            iconRotate: updateTools.arrowsRotate
            onClicked: updateTools.toggleDialog()
        }
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
        y: updateArrows.y + updateArrows.height -
           (appWindow.uiver === 1 ? 15 : -10)*appWindow.zoom
        arrowCenterX: updateArrows.x - x + updateArrows.width/2
    }

    Connections {
        target: appWindow
        onCheckUpdates: updateTools.checkForUpdates()
    }
}
