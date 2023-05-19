import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.4
import "../../qt5compat"
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.abstractdownloadsui 1.0
import "../../common/Tools"
import "../BaseElements"
import "../../common"

Item {
    id: root
    property var downloadItemId: null
    property var downloadInfo: null
    property bool createDownloadDialog: false
    property var myModel: downloadInfo && downloadInfo.filesCount > 1 ? downloadInfo.filesTreeListModel() : null

    anchors.fill: parent

    RowLayout {
        id: tableHeader
        width: parent.width
        spacing: 0
        FilesTabTablesHeaderItem {
            id: nameItem
            text: qsTr("Name") + App.loc.emptyString
            Layout.fillWidth: true
            Layout.minimumWidth: 100
            sortBy: AbstractDownloadsUi.SortByName
        }

        FilesTabTablesHeaderItem {
            id: sizeItem
            text: qsTr("Size") + App.loc.emptyString
            visible: !appWindow.smallScreen
            Layout.preferredWidth: appWindow.smallScreen ? 60 : 80
            sortBy: AbstractDownloadsUi.SortBySize
        }

        FilesTabTablesHeaderItem {
            id: progressItem
            text: qsTr("Progress") + App.loc.emptyString
            Layout.preferredWidth: 120
            visible: !root.createDownloadDialog && !appWindow.smallScreen
            sortBy: AbstractDownloadsUi.SortByProgress
        }

        FilesTabTablesHeaderItem {
            id: priorityItem
            text: qsTr("Priority") + App.loc.emptyString
            Layout.preferredWidth: appWindow.smallScreen ? 94 : 120
            sortBy: AbstractDownloadsUi.SortByPriority

            Rectangle {
                height: parent.height
                width: 1
                anchors.right: parent.right
                color: appWindow.theme.border
            }
        }
    }

    Rectangle {
        width: parent.width
        anchors.top: tableHeader.bottom
        anchors.bottom: parent.bottom
        color: 'transparent'
        clip: true

        ListView {
            id: listView
            model: myModel
            anchors.fill: parent

            ScrollBar.vertical: ScrollBar{}

            flickableDirection: Flickable.AutoFlickIfNeeded
            boundsBehavior: Flickable.StopAtBounds

            delegate: Item {
                property int rowHeight: appWindow.smallScreen ? 60 : 30
                property var fileModel: model
                width: listView.width
                height: contentItem.height

                MouseArea {
                    id: mouseAreaRow
                    anchors.fill: parent
                    onClicked: {
                        if (model.folder) {
                            model.isOpened = !model.isOpened;
                        }
                    }
                    onDoubleClicked: {
                        if (downloadItemId && !model.folder && App.downloads.infos.info(downloadItemId).fileInfo(model.fileIndex).finished) {
                            App.downloads.mgr.openDownload(downloadItemId, model.fileIndex);
                        }
                    }
                    onPressAndHold: function (mouse) {showMenu(mouse);}
                }

                function showMenu(mouse)
                {
                    var download = App.downloads.infos.info(downloadItemId);
                    var component = Qt.createComponent("FilesTreeContextMenu.qml");
                    var menu = component.createObject(mouseAreaRow, {
                                                          "model": model,
                                                          "downloadItemId" : downloadItemId,
                                                          "downloadModel" : download,
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

                RowLayout {
                    id: contentItem
                    width: parent.width
                    spacing: 0

                    RowLayout {
                        Layout.preferredWidth: nameItem.width
                        spacing: 0

                        //left padding by levels
                        Rectangle {
                            Layout.leftMargin: qtbug.leftMargin(5, 0)
                            Layout.rightMargin: qtbug.rightMargin(5, 0)
                            width: (model.level + (model.folder ? 0 : 1)) * 15
                            height: 30
                            color: "transparent"
                        }

                        //checkbox
                        BaseCheckBox {
                            tristate: true
                            Layout.alignment: Qt.AlignTop
                            size: !model.level && model.folder ? 14 : 12
                            checkState: model.priority == AbstractDownloadsUi.DownloadPriorityDontDownload ? Qt.Unchecked :
                                (model.folder && model.priority == AbstractDownloadsUi.DownloadPriorityUnknown
                                    && model.childrenHasDontDownloadPriority ? Qt.PartiallyChecked : Qt.Checked )
                            onClicked: {
                                if (checkState == Qt.Unchecked) {
                                    model.priority = AbstractDownloadsUi.DownloadPriorityDontDownload;
                                } else {
                                    model.priority = AbstractDownloadsUi.DownloadPriorityNormal;
                                }
                            }
                        }

                        Column {
                            Layout.alignment: Qt.AlignTop
                            Layout.fillWidth: true
                            Layout.rightMargin: qtbug.rightMargin(0, 5)
                            Layout.leftMargin: qtbug.leftMargin(0, 5)
                            Layout.topMargin: 6
                            spacing: 0

                            //file name
                            Row {
                                width: parent.width

                                BaseLabel {
                                    id: nameLabel
                                    wrapMode: Text.WrapAnywhere
                                    bottomPadding: 6
                                    width: parent.width - 15
                                    text: model.name
                                }
                                //show/hide list arrow
                                Rectangle {
                                    visible: model.folder
                                    width: 15
                                    height: 15
                                    color: "transparent"
                                    clip: true
                                    Image {
                                        width: 10
                                        height: width
                                        source: model.isOpened ? Qt.resolvedUrl("../../images/mobile/flag_up.svg") : Qt.resolvedUrl("../../images/mobile/flag_down.svg")
                                        sourceSize.width: 10
                                        sourceSize.height: 10
                                        anchors.centerIn: parent
                                        layer {
                                            effect: ColorOverlay {
                                                color: appWindow.theme.foreground
                                            }
                                            enabled: true
                                        }
                                    }
                                }
                            }

                            Row {
                                width: parent.width
                                spacing: 0

                                //file size - small screen
                                BaseLabel {
                                    visible: appWindow.smallScreen
                                    text: App.bytesAsText(model.selectedSize) + App.loc.emptyString
                                    bottomPadding: 6
                                    rightPadding: qtbug.rightPadding(0, 5)
                                    leftPadding: qtbug.leftPadding(0, 5)
                                }

                                //progress - small screen
                                ProgressIndicator {
                                    visible: appWindow.smallScreen && !root.createDownloadDialog
                                    progress: model.progress
                                }
                            }
                        }
                    }

                    //file size - wide screen
                    Rectangle {
                        visible: !appWindow.smallScreen
                        height: 30
                        Layout.preferredWidth: sizeItem.width
                        Layout.alignment: Qt.AlignTop
                        clip: true
                        color: "transparent"

                        Rectangle {
                            color: "transparent"
                            anchors.fill: parent
                            anchors.leftMargin: 5
                            anchors.rightMargin: 5
                            BaseLabel {
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.right: parent.right
                                text: App.bytesAsText(model.selectedSize) + App.loc.emptyString
                            }
                        }
                    }

                    //progress - wide screen
                    ProgressIndicator {
                        visible: !root.createDownloadDialog && !appWindow.smallScreen
                        progress: model.progress
                        Layout.preferredWidth: progressItem.width
                        Layout.alignment: Qt.AlignTop
                        height: 30
                    }

                    //priority
                    Rectangle {
                        Layout.preferredWidth: priorityItem.width
                        Layout.alignment: Qt.AlignTop
                        height: 30
                        color: 'transparent'

                        ComboBox {
                            id: priorityCombo
                            visible: fileModel.priority != AbstractDownloadsUi.DownloadPriorityDontDownload
                                && fileModel.priority != AbstractDownloadsUi.DownloadPriorityUnknown
                            implicitWidth: priorityItem.width
                            height: 30

                            flat: true
                            currentIndex: fileModel.priority == AbstractDownloadsUi.DownloadPriorityHigh ? 0 :
                                             (fileModel.priority == AbstractDownloadsUi.DownloadPriorityNormal ? 1 :
                                               (fileModel.priority == AbstractDownloadsUi.DownloadPriorityLow ? 2 : -1))

                            model: [
                                {text: qsTr("High") + App.loc.emptyString, priority: AbstractDownloadsUi.DownloadPriorityHigh},
                                {text: qsTr("Normal") + App.loc.emptyString, priority: AbstractDownloadsUi.DownloadPriorityNormal},
                                {text: qsTr("Low") + App.loc.emptyString, priority: AbstractDownloadsUi.DownloadPriorityLow}
                            ]
                            textRole: "text"

                            contentItem: BaseLabel {
                                text: priorityCombo.currentText
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                            }

                            delegate: ItemDelegate {
                                width: priorityCombo.width
                                padding: 0
                                leftPadding: qtbug.leftPadding(5, 0)
                                rightPadding: qtbug.rightPadding(5, 0)
                                contentItem: BaseLabel {
                                    text: modelData.text
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignLeft
                                }
                            }

//                            indicator: Image {
//                                id: img2
//                                anchors.verticalCenter: parent.verticalCenter
//                                source: Qt.resolvedUrl("../../images/arrow_drop_down.svg")
//                                layer {
//                                    effect: ColorOverlay {
//                                        color: appWindow.theme.foreground
//                                    }
//                                    enabled: true
//                                }
//                            }

                            indicator: Rectangle {
                                width: 1
                                height: 1
                                color: "transparent"
                            }

                            onActivated: {
                                fileModel.priority = model[index].priority;
                            }
                        }
                    }
                }

                Rectangle {
                    width: parent.width
                    height: 1
                    color: appWindow.theme.border
                    anchors.bottom: parent.bottom
                }
            }
        }
    }
}
