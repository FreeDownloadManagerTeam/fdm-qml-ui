import QtQuick 2.0
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0
import "../../BaseElements"
import "../../FilesTree"

ColumnLayout {
    id: root

    visible: tree.downloadInfo && tree.downloadInfo.filesCount > 1

    Layout.topMargin: 8
    Layout.fillWidth: true
    Layout.preferredHeight: Math.min((visible ? tree.rowsCount : 0) * 22 + 55, Math.min(450, Math.max(200, appWindow.height - 500)))
    spacing: 5

    Rectangle {
        Layout.fillWidth: true
        height: 20
        color: "transparent"

        BaseLabel {
            text: qsTr("Files") + App.loc.emptyString
            anchors.left: parent.left
        }

        BaseLabel {
            text: qsTr("Select all") + App.loc.emptyString
            color: linkColor
            anchors.right: selectNone.left
            anchors.rightMargin: 20
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
        border.width: 1
        color: appWindow.theme.filesTreeBackground

        FilesTree {
            id: tree
            downloadInfo: null
            createDownloadDialog: true

            property var selectedSize: tree.downloadInfo && downloadInfo.filesCount > 1 ? tree.downloadInfo.selectedSize : -1

            onSelectedSizeChanged: { downloadTools.fileSizeValueChanged(tree.selectedSize) }
        }

        Rectangle {
            height: 1
            width: parent.width
            anchors.top: parent.top
            color: appWindow.theme.border
        }
    }

    function initialization(requestId) {
        tree.downloadInfo = App.downloads.creator.downloadInfo(requestId, 0);
    }
}
