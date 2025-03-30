import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.11
import org.freedownloadmanager.fdm 1.0
import "../BaseElements"
import "../../common/Tools"

BaseDialog {
    id: root

    signal remoteResourceChanged(int id)

    onRemoteResourceChanged: downloadsListModel.append({'id': id});

    title: qsTr("Remote resource changed") + App.loc.emptyString
    onCloseClick: cancelClicked()

    contentItem: BaseDialogItem {
        focus: true
        Keys.onEscapePressed: cancelClicked()
        Keys.onReturnPressed: redownloadClicked()

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 20*appWindow.zoom

            ListView {
                id: downloadsList
                clip: true
                Layout.fillWidth: true
                Layout.minimumWidth: 540*appWindow.zoom
                Layout.preferredHeight: Math.min(contentHeight, 150*appWindow.zoom)
                ScrollBar.vertical: ScrollBar {
                    active: parent.contentHeight > 150*appWindow.zoom
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
                Layout.topMargin: 10*appWindow.zoom
                Layout.alignment: Qt.AlignRight

                spacing: 5*appWindow.zoom

                BaseButton {
                    id: ignoreBtn
                    blueBtn: true
                    alternateBtnPressed: cnclBtn.isPressed
                    text: qsTr("Re-download") + App.loc.emptyString
                    onClicked: redownloadClicked()
                }

                BaseButton {
                    id: cnclBtn
                    text: qsTr("Cancel") + App.loc.emptyString
                    onClicked: cancelClicked()
                }
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
