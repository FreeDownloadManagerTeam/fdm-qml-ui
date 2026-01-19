import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import Qt.labs.settings
import "../BaseElements"
import "../../common/Tools"

BaseDialog {
    id: root

    property var downloadIds: []

    title: qsTr("Pause download") + App.loc.emptyString
    onCloseClick: root.close()

    contentItem: BaseDialogItem {
        focus: true
        Keys.onEscapePressed: root.close()
        Keys.onReturnPressed: root.okClick()

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 3*appWindow.zoom

            BaseLabel {
                Layout.fillWidth: true
                text: qsTr("The download(s) below can't be resumed after pausing.") + App.loc.emptyString
                Layout.bottomMargin: 7*appWindow.zoom
            }

            ListView {
                clip: true
                Layout.fillWidth: true
                Layout.minimumWidth: 540*appWindow.fontZoom
                Layout.preferredHeight: Math.min(contentHeight, 150*appWindow.zoom)
                ScrollBar.vertical: ScrollBar {
                    active: parent.contentHeight > 150*appWindow.zoom
                }
                model: root.downloadIds
                delegate: Rectangle {
                    width: parent.width
                    height: lbl.height
                    color: 'transparent'

                    BaseLabel {
                        id: lbl
                        visible: downloadsItemTools.tplPathAndTitle.length > 0
                        width: parent.width
                        elide: Text.ElideMiddle
                        color: "#737373"
                        DownloadsItemTools {
                            id: downloadsItemTools
                            itemId: root.downloadIds[index]
                        }
                        text: App.toNativeSeparators(downloadsItemTools.hasChildDownloads ? downloadsItemTools.destinationPath : downloadsItemTools.tplPathAndTitle)
                    }
                }
            }

            RowLayout {
                Layout.topMargin: 10*appWindow.zoom
                Layout.alignment: Qt.AlignRight

                spacing: 5*appWindow.zoom

                BaseButton {
                    text: qsTr("Pause") + App.loc.emptyString
                    blueBtn: true
                    alternateBtnPressed: cnclBtn.isPressed
                    onClicked: root.okClick()
                }

                BaseButton {
                    id: cnclBtn
                    text: qsTr("Cancel") + App.loc.emptyString
                    onClicked: root.close()
                }
            }
        }
    }

    onOpened: {
        forceActiveFocus();
    }

    onClosed: {
        downloadIds = [];
    }

    function okClick()
    {
        selectedDownloadsTools.stopByIds(downloadIds);
        root.close();
    }

    function show(ids)
    {
        console.log("show(ids)", ids);
        root.downloadIds = ids;
        root.open();
    }
}
