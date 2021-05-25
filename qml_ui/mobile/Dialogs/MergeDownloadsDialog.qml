import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0
import "../../common/Tools"
import "../BaseElements"

Dialog {
    id: root

    parent: appWindow.overlay

    x: Math.round((appWindow.width - width) / 2)
    y: Math.round((appWindow.height - height) / 2)
    width: Math.round(appWindow.width * 0.8)

    modal: true

    contentItem: ColumnLayout {
        spacing: 20
        clip: true
        visible: mergeTools.dialogEnabled
        width: parent.width

        DialogTitle {
            text: qsTr("The download already exists") + App.loc.emptyString
        }

        Label {
            visible: mergeTools.dialogEnabled
            text: downloadsItemTools.resourceUrl.length > 0 ? downloadsItemTools.resourceUrl : downloadsItemTools.title
            color: "#737373"
            elide: Text.ElideMiddle
            Layout.fillWidth: true
            DownloadsItemTools {
                id: downloadsItemTools
                itemId: mergeTools.existingDownloadId
            }
        }

        GridLayout {
            Layout.fillWidth: true

            DialogButton {
                text: qsTr("Skip") + App.loc.emptyString
                onClicked: mergeTools.accept()
            }

            DialogButton {
                Layout.column: appWindow.smallScreen ? 0 : 1
                Layout.row: appWindow.smallScreen ? 1 : 0
                text: qsTr("Skip all (%1)").arg(App.downloads.mergeOptionsChooser.pendingNewDownloadIdsCount) + App.loc.emptyString
                visible: App.downloads.mergeOptionsChooser.pendingNewDownloadIdsCount > 1
                onClicked: mergeTools.acceptAll()
            }

            DialogButton {
                Layout.column: appWindow.smallScreen ? 0 : 2
                Layout.row: appWindow.smallScreen ? 2 : 0
                visible: mergeTools.mergeBtnEnabled
                text: qsTr("Download") + App.loc.emptyString
                onClicked: mergeTools.dontMerge()
            }
        }
    }

    onRejected: {
        mergeTools.reject();
    }

    MergeDownloadsTools {
        id: mergeTools
    }

    function newMergeByRequest(newDownloadId, existingDownloadId)
    {
        if (mergeTools.newMergeRequest(newDownloadId, existingDownloadId)) {
            root.open();
        }
    }

}
