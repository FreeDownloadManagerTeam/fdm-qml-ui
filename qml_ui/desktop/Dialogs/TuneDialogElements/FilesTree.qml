import QtQuick 2.0
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0
import "../../BaseElements"
import "../../FilesTree"

ColumnLayout {
    id: root

    visible: tree.downloadInfo && tree.downloadInfo.filesCount > 1

    Layout.topMargin: 8*appWindow.zoom
    Layout.fillWidth: true
    Layout.preferredHeight: Math.min((visible ? tree.rowsCount : 0) * 22*appWindow.fontZoom + 55*appWindow.zoom, Math.min(450*appWindow.zoom, Math.max(200*appWindow.fontZoom, appWindow.height - 500*appWindow.zoom)))
    spacing: 5*appWindow.zoom

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 20*appWindow.zoom
        color: "transparent"

        BaseLabel {
            text: qsTr("Files") + App.loc.emptyString
            anchors.left: parent.left
        }

        BaseLabel {
            text: qsTr("Select all") + App.loc.emptyString
            color: linkColor
            anchors.right: selectNone.left
            anchors.rightMargin: 20*appWindow.zoom
            MouseArea {
                anchors.fill: parent
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
                onClicked: tree.selectNoneToDownload()
            }
        }
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.fillHeight: true
        border.color: appWindow.theme.border
        border.width: 1*appWindow.zoom
        color: appWindow.theme.filesTreeBackground

        FilesTree {
            id: tree
            downloadInfo: null
            createDownloadDialog: true

            property var selectedSize: tree.downloadInfo && downloadInfo.filesCount > 1 ? tree.downloadInfo.selectedSize : -1

            onSelectedSizeChanged: { downloadTools.fileSizeValueChanged(tree.selectedSize) }
        }

        Rectangle {
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
