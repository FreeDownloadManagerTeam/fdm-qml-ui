import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0
import "../../common/Tools"
import "../BaseElements"
import "../../common"

import Qt.labs.platform 1.0 as QtLabs

BaseDialog {
    id: root

    title: qsTr("The download already exists") + App.loc.emptyString
    onCloseClick: mergeTools.reject()

    contentItem: BaseDialogItem {
        focus: true
        Keys.onEscapePressed: mergeTools.reject()
        Keys.onReturnPressed: mergeTools.accept()

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 10*appWindow.zoom
            visible: mergeTools.dialogEnabled

            DownloadsItemTools {
                id: downloadsItemTools
                itemId: mergeTools.existingDownloadId
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 10*appWindow.zoom

                BaseLabel {
                    visible: url.visible
                    font.pixelSize: 13*appWindow.fontZoom
                    font.weight: Font.DemiBold
                    text: qsTr("URL:") + App.loc.emptyString
                    dialogLabel: true
                }
                BaseLabel {
                    id: url
                    visible: mergeTools.dialogEnabled && downloadsItemTools.resourceUrl.length > 0
                    font.pixelSize: 13*appWindow.fontZoom
                    text: downloadsItemTools.resourceUrl
                    elide: Text.ElideMiddle
                    Layout.fillWidth: true
                    dialogLabel: true
                }
            }
            RowLayout {
                width: parent.width
                spacing: 10*appWindow.zoom

                BaseLabel {
                    visible: path.visible
                    font.pixelSize: 13*appWindow.fontZoom
                    font.weight: Font.DemiBold
                    text: qsTr("Path:") + App.loc.emptyString
                    dialogLabel: true
                }
                BaseLabel {
                    id: path
                    visible: mergeTools.dialogEnabled
                    font.pixelSize: 13*appWindow.fontZoom
                    text: downloadsItemTools.hasChildDownloads ? downloadsItemTools.destinationPath : downloadsItemTools.tplPathAndTitle
                    elide: Text.ElideMiddle
                    Layout.fillWidth: true
                    dialogLabel: true
                }
            }
            RowLayout {
                spacing: 10*appWindow.zoom
                BaseLabel {
                    visible: size.visible
                    font.pixelSize: 13*appWindow.fontZoom
                    font.weight: Font.DemiBold
                    text: qsTr("Size:") + App.loc.emptyString
                    dialogLabel: true
                }
                BaseLabel {
                    id: size
                    visible: mergeTools.dialogEnabled && downloadsItemTools.selectedSize > 0
                    font.pixelSize: 13*appWindow.fontZoom
                    text: App.bytesAsText(downloadsItemTools.selectedSize) + App.loc.emptyString
                    dialogLabel: true
                }
            }
            RowLayout {
                spacing: 10*appWindow.zoom
                BaseLabel {
                    visible: date.visible
                    font.pixelSize: 13*appWindow.fontZoom
                    font.weight: Font.DemiBold
                    text: qsTr("Added at:") + App.loc.emptyString
                    dialogLabel: true
                }
                BaseLabel {
                    id: date
                    visible: mergeTools.dialogEnabled
                    font.pixelSize: 13*appWindow.fontZoom
                    text: downloadsItemTools.added ?
                              App.loc.dateOrTimeToString(downloadsItemTools.added, false) + App.loc.emptyString :
                              ""
                    dialogLabel: true
                }
            }
            RowLayout {
                Layout.alignment: Qt.AlignRight

                spacing: 5*appWindow.zoom

                BaseButton {
                    text: qsTr("Skip") + App.loc.emptyString
                    blueBtn: true
                    alternateBtnPressed: cnclBtn.isPressed
                    enabled: mergeTools.dialogEnabled
                    onClicked: mergeTools.accept()
                }

                BaseButton {
                    text: qsTr("Skip all (%1)").arg(App.downloads.mergeOptionsChooser.pendingNewDownloadIdsCount) + App.loc.emptyString
                    visible: App.downloads.mergeOptionsChooser.pendingNewDownloadIdsCount > 1
                    alternateBtnPressed: cnclBtn.isPressed
                    enabled: mergeTools.dialogEnabled
                    useUppercase: appWindow.uiver !== 1
                    onClicked: mergeTools.acceptAll()
                }

                BaseButton {
                    id: cnclBtn
                    visible: mergeTools.mergeBtnEnabled
                    text: qsTr("Download") + App.loc.emptyString
                    enabled: mergeTools.dialogEnabled
                    useUppercase: appWindow.uiver !== 1
                    onClicked: mergeTools.dontMerge()
                }
            }
        }
    }

    onOpened: {
        appWindow.showWindow(true);
        forceActiveFocus();
    }


    function newMergeByRequest(newDownloadId, existingDownloadId) {
        if (mergeTools.newMergeRequest(newDownloadId, existingDownloadId)) {
            root.open();
            mergeTools.closeBuildDownloadDialog();
        }
    }

    MergeDownloadsTools {
        id: mergeTools
        onWasResetted: appWindow.appWindowStateChanged()
    }

    Connections {
        target: App.downloads.mergeOptionsChooser
        onGotAbortMergeRequest: function(newDownloadId, existingDownloadId) {
            if (mergeTools.newDownloadId == newDownloadId)
            {
                root.close();
                mergeTools.abortRequest();
            }
        }
    }
}
