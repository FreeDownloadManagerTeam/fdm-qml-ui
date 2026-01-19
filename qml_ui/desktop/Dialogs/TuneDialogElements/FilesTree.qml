import QtQuick
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import "../../BaseElements"
import "../../FilesTree"
import "../../V2"

ColumnLayout {
    id: root

    visible: tree.downloadInfo && tree.downloadInfo.filesCount > 1

    Layout.topMargin: 8*appWindow.zoom
    Layout.fillWidth: true
    Layout.preferredHeight: Math.min((visible ? tree.rowsCount : 0) * 22*appWindow.fontZoom + 55*appWindow.zoom, Math.min(450*appWindow.zoom, Math.max(200*appWindow.fontZoom, appWindow.height - 500*appWindow.zoom)))
    spacing: 5*appWindow.zoom

    readonly property var tree: treeLoader.item

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 20*appWindow.zoom
        color: "transparent"

        BaseLabel {
            text: qsTr("Files") + App.loc.emptyString
            dialogLabel: true
            anchors.left: parent.left
        }

        BaseLabel {
            text: qsTr("Select all") + App.loc.emptyString
            color: linkColor
            anchors.right: selectNone.left
            anchors.rightMargin: 20*appWindow.zoom
            MouseArea {
                anchors.fill: parent
                cursorShape: appWindow.uiver === 1 ? Qt.ArrowCursor : Qt.PointingHandCursor
                onClicked: tree.selectAllToDownload()
            }
        }

        BaseLabel {
            id: selectNone
            text: qsTr("Select none") + App.loc.emptyString
            color: linkColor
            anchors.right: parent.right
            MouseArea {
                anchors.fill: parent
                cursorShape: appWindow.uiver === 1 ? Qt.ArrowCursor : Qt.PointingHandCursor
                onClicked: tree.selectNoneToDownload()
            }
        }
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.fillHeight: true
        border.color: appWindow.uiver === 1 ?
                          appWindow.theme.border :
                          appWindow.theme_v2.outlineBorderColor
        border.width: 1*appWindow.zoom
        color: appWindow.uiver === 1 ? appWindow.theme.filesTreeBackground :
                                       appWindow.theme_v2.bgColor
        radius: appWindow.uiver === 1 ? 0 : 8*appWindow.zoom

        Component {
            id: tree_v1
            FilesTree {
                downloadInfo: null
                createDownloadDialog: true

                property var selectedSize: tree.downloadInfo && downloadInfo.filesCount > 1 ? tree.downloadInfo.selectedSize : -1

                onSelectedSizeChanged: { downloadTools.fileSizeValueChanged(tree.selectedSize) }
            }
        }

        Component {
            id: tree_v2
            FilesTree_V2 {
                downloadInfo: null
                createDownloadDialog: true

                property var selectedSize: tree.downloadInfo && downloadInfo.filesCount > 1 ? tree.downloadInfo.selectedSize : -1

                onSelectedSizeChanged: { downloadTools.fileSizeValueChanged(tree.selectedSize) }
            }
        }

        Loader {
            id: treeLoader
            sourceComponent: appWindow.uiver === 1 ? tree_v1 : tree_v2
            anchors.fill: parent
            anchors.margins: appWindow.uiver === 1 ? 0 : 8*appWindow.zoom
        }

        Rectangle {
            visible: appWindow.uiver === 1
            height: 1*appWindow.zoom
            width: parent.width
            anchors.top: parent.top
            color: appWindow.theme.border
        }
    }

    function initialization(requestId) {
        tree.downloadInfo = App.downloads.creator.downloadInfo(requestId, 0);
    }
}
