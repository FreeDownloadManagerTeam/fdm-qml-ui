import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../BaseElements/V2"
import "../../common"
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.abstractdownloadsui

Item
{
    property var header

    readonly property int myVerticalPadding: 8*appWindow.zoom

    implicitWidth: childrenRect.width

    implicitHeight: myVerticalPadding*2 - 1 +
                    Math.max(nameCol.implicitHeight, statusCol.implicitHeight)

    MouseArea {
        id: mouseAreaRow
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        hoverEnabled: true
        onClicked: (mouse) =>
                   {
                       if (!createDownloadDialog && mouse.button === Qt.RightButton)
                       {
                           var download = App.downloads.infos.info(downloadItemId);
                           var component = Qt.createComponent("../FilesTree/FilesTreeContextMenu.qml");
                           var menu = component.createObject(mouseAreaRow, {
                                                                 "model": model,
                                                                 "downloadItemId" : downloadItemId,
                                                                 "finished": (downloadItemId && !model.folder) ? download.fileInfo(model.fileIndex).finished : false,
                                                                 "locked": download.lockReason != ""
                                                             });
                           menu.x = Math.round(mouse.x);
                           menu.y = Math.round(mouse.y);
                           menu.currentIndex = -1; // bug under Android workaround
                           menu.open();
                           menu.aboutToHide.connect(function(){
                               menu.destroy();
                           });
                       }
                   }

        onDoubleClicked: {
            if (!createDownloadDialog &&
                    downloadItemId &&
                    !model.folder &&
                    App.downloads.infos.info(downloadItemId).fileInfo(model.fileIndex).finished)
            {
                App.downloads.mgr.openDownload(downloadItemId, model.fileIndex);
            }
        }
    }

    component MyCell : RowLayout
    {
        y: myVerticalPadding
        height: parent.height - myVerticalPadding*2
    }

    MyCell
    {
        id: nameCol

        readonly property int myOffset: model.level * 10 * appWindow.zoom

        x: header.numColX + myOffset
        width: header.nameColX - header.numColX + header.nameColWidth - myOffset

        spacing: 8*appWindow.zoom

        Item {
            Layout.preferredHeight: 16*appWindow.zoom
            Layout.preferredWidth: 16*appWindow.zoom

            SvgImage_V2 {
                visible: model.folder
                source: Qt.resolvedUrl(model.isOpened ? "arrow_drop_down.svg" : "arrow_drop_right.svg")
                anchors.centerIn: parent
            }

            MouseAreaWithHand_V2 {
                visible: model.folder
                anchors.fill: parent
                onClicked: model.isOpened = !model.isOpened
            }
        }

        CheckBox_V2 {
            checked: model.priority != AbstractDownloadsUi.DownloadPriorityDontDownload
            onClicked: {
                model.selectedForDownload = checked ? AbstractDownloadsUi.FullySelectedForDownload :
                                                      AbstractDownloadsUi.IsNotSelectedForDownload;
                if (checked)
                    downloadInfo.autoStartAllowed = true;
            }
        }

        SvgImage_V2 {
            source: Qt.resolvedUrl(model.folder ? (model.isOpened ? "folder_open.svg" : "folder.svg") : "file.svg")
            imageColor: appWindow.theme_v2.bg600
        }

        ElidedTextWithTooltip_V2 {
            sourceText: model.name
            Layout.fillWidth: true
        }
    }

    MyCell
    {
        id: sizeCol

        x: header.sizeColX
        width: header.sizeColWidth

        BaseText_V2 {
            text: App.bytesAsText(model.selectedSize) + App.loc.emptyString
        }
    }

    MyCell
    {
        id: statusCol

        visible: !createDownloadDialog

        x: header.statusColX
        width: header.statusColWidth

        BaseText_V2 {
            text: model.progress == 100 ? qsTr("Completed") + App.loc.emptyString : model.progress + '%'
        }
    }

    MyCell
    {
        id: priorityCol

        x: header.priorityColX
        width: header.priorityColWidth

        Item {
            visible: model.priority != AbstractDownloadsUi.DownloadPriorityDontDownload &&
                     model.priority != AbstractDownloadsUi.DownloadPriorityUnknown
            implicitWidth: prioritySelector.implicitWidth
            implicitHeight: prioritySelector.implicitHeight

            RowLayout {
                id: prioritySelector

                BaseText_V2 {
                    text: uicore.priorityText(model.priority) + App.loc.emptyString

                    Layout.minimumWidth: header.priorityTextMaxWidth + 5*appWindow.fontZoom

                    MouseAreaWithHand_V2 {
                        anchors.fill: parent
                        onClicked: {
                            if (!prioritySelectorPopupHelper.isPopupClosedRecently())
                                prioritySelectorPopup.open();
                        }
                    }
                    PopupHelper {
                        id: prioritySelectorPopupHelper
                        popup: prioritySelectorPopup
                    }
                    Popup {
                        id: prioritySelectorPopup
                        x: -16
                        y: -height
                        background: Rectangle {
                            color: appWindow.theme_v2.bg300
                            radius: 8*appWindow.zoom
                        }
                        contentItem: ColumnLayout {
                            spacing: 0
                            Repeater {
                                model: [
                                    AbstractDownloadsUi.DownloadPriorityLow,
                                    AbstractDownloadsUi.DownloadPriorityNormal,
                                    AbstractDownloadsUi.DownloadPriorityHigh
                                ]
                                Rectangle {
                                    Layout.preferredWidth: Math.max(prioritySelectorPopupItemText.contentWidth + (8+8)*appWindow.zoom, 16*appWindow.zoom)
                                    Layout.preferredHeight: prioritySelectorPopupItemText.contentHeight + 2*8*appWindow.zoom
                                    color: prioritySelectorPopupItemMa.containsMouse ? appWindow.theme_v2.bg400 : "transparent"
                                    radius: 4*appWindow.zoom
                                    BaseText_V2 {
                                        id: prioritySelectorPopupItemText
                                        x: 8
                                        y: 8
                                        text: uicore.priorityText(modelData)
                                    }
                                    MouseAreaWithHand_V2 {
                                        id: prioritySelectorPopupItemMa
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        onClicked: {
                                            priorityCol.setPriority(modelData);
                                            prioritySelectorPopup.close();
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                RowLayout {
                    visible: mouseAreaRow.containsMouse || priorityUpBtn.containsMouse || priorityDownBtn.containsMouse

                    component PriorityButton : SvgImage_V2 {
                        property bool isUp
                        property alias containsMouse: priorityBtnMa.containsMouse
                        readonly property bool isEnabled: model.priority != (isUp ? AbstractDownloadsUi.DownloadPriorityHigh : AbstractDownloadsUi.DownloadPriorityLow)
                        source: Qt.resolvedUrl(isUp ? "priority_up.svg" : "priority_down.svg")
                        imageColor: isEnabled ?
                                        (priorityBtnMa.containsMouse ? appWindow.theme_v2.primary : appWindow.theme_v2.bg600) :
                                        appWindow.theme_v2.enabledColor(appWindow.theme_v2.bg600, false)
                        MouseArea {
                            id: priorityBtnMa
                            anchors.fill: parent
                            hoverEnabled: true
                            acceptedButtons: Qt.LeftButton
                            onClicked: {
                                if (!isEnabled)
                                    return;
                                if (isUp) {
                                    model.priority = model.priority == AbstractDownloadsUi.DownloadPriorityLow ?
                                                AbstractDownloadsUi.DownloadPriorityNormal :
                                                AbstractDownloadsUi.DownloadPriorityHigh;
                                } else {
                                    model.priority = model.priority == AbstractDownloadsUi.DownloadPriorityHigh ?
                                                AbstractDownloadsUi.DownloadPriorityNormal :
                                                AbstractDownloadsUi.DownloadPriorityLow;
                                }
                            }
                        }
                    }

                    PriorityButton {
                        id: priorityUpBtn
                        isUp: true
                    }

                    PriorityButton {
                        id: priorityDownBtn
                        isUp: false
                    }
                }
            }
        }

        function setPriority(priority)
        {
            model.priority = priority;
        }
    }
}
