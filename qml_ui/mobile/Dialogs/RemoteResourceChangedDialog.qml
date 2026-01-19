import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import "../BaseElements"
import "../../common/Tools"

Dialog {
    id: root

    parent: Overlay.overlay

    x: Math.round((appWindow.width - width) / 2)
    y: Math.round((appWindow.height - height) / 2)

    modal: true

    title: qsTr("Remote resource changed") + App.loc.emptyString
    width: Math.round(appWindow.width * 0.8)

    signal remoteResourceChanged(int id)
    onRemoteResourceChanged: downloadsListModel.append({'id': id});

    contentItem: ColumnLayout {
        width: parent.width
        spacing: 20

        ListView {
            id: downloadsList
            clip: true
            Layout.fillWidth: true
            Layout.preferredHeight: Math.min(contentHeight, 150)
            ScrollBar.vertical: ScrollBar {
                active: parent.contentHeight > 150
            }
            model: ListModel {
                id: downloadsListModel
            }

            delegate: Rectangle {
                width: parent.width
                height: lbl.height
                color: 'transparent'

                BaseLabel {
                    id: lbl
                    width: parent.width
                    elide: Text.ElideMiddle
                    color: "#737373"
                    DownloadsItemTools {
                        id: downloadsItemTools
                        itemId: downloadsListModel.count > 0 ? downloadsListModel.get(index).id : -1
                    }
                    text: downloadsItemTools.hasChildDownloads ? downloadsItemTools.destinationPath : downloadsItemTools.tplPathAndTitle
                }
            }
        }

        BaseCheckBox {
            id: rememberField
            text: qsTr("Always re-download") + App.loc.emptyString
        }

        RowLayout {
            DialogButton
            {
                text: qsTr("Re-download") + App.loc.emptyString
                onClicked: redownloadClicked()
            }

            DialogButton
            {
                text: qsTr("Cancel") + App.loc.emptyString
                onClicked: cancelClicked()
            }
        }
    }

    onOpened: forceActiveFocus()
    onClosed: {
        downloadsListModel.clear();
    }

    function redownloadClicked() {
        if (rememberField.checked) {
            App.settings.dmcore.setValue(DmCoreSettings.AutoRestartFinishedDownloadIfRemoteResourceChanged,
                                         App.settings.fromBool(true));
        }

        for (let i = 0; i < downloadsListModel.count; ++i) {
            App.downloads.mgr.restartDownload(downloadsListModel.get(i).id);
        }
        root.close();
    }

    function cancelClicked() {
        root.close();
    }
}
