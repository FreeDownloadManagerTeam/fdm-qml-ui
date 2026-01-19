import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.abstractdownloadsui 
import "../../common/Tools"
import "../BaseElements"
import "../../common"

Item {
    id: root
    property var downloadItemId: null
    property var downloadInfo: null
    property bool createDownloadDialog: false
    property var myModel: downloadInfo && downloadInfo.filesCount > 1 ? downloadInfo.filesTreeListModel() : null
    property int selectedIndex: -1
    property int rowsCount: listView.count

    BaseLabel {
        id: fmLabel
        visible: false
    }
    FontMetrics {
        id: fm
        font: fmLabel.font
    }

    property int priorityColWidth: Math.max(fm.advanceWidth(qsTr("Priority") + App.loc.emptyString) + 30*appWindow.zoom,
                                            fm.advanceWidth(qsTr('Normal') + App.loc.emptyString) + 60*appWindow.zoom,
                                            fm.advanceWidth(qsTr('High') + App.loc.emptyString) + 60*appWindow.zoom,
                                            fm.advanceWidth(qsTr('Low') + App.loc.emptyString) + 60*appWindow.zoom) +
                                   fm.font.pixelSize*0

    signal selectAllToDownload()
    signal selectNoneToDownload()

    anchors.fill: parent

    onSelectAllToDownload: { if (myModel) myModel.selectAllToDownload() }
    onSelectNoneToDownload: { if (myModel) myModel.selectNoneToDownload() }

    RowLayout {
        id: tableHeader
        width: parent.width
        spacing: 0
        FilesTabTablesHeaderItem {
            id: nameItem
            text: qsTr("Name") + App.loc.emptyString
            Layout.fillWidth: true
            Layout.minimumWidth: 200*appWindow.zoom
            sortBy: AbstractDownloadsUi.SortByName
        }

        FilesTabTablesHeaderItem {
            id: sizeItem
            text: qsTr("Size") + App.loc.emptyString
            Layout.preferredWidth: 80*appWindow.zoom
            sortBy: AbstractDownloadsUi.SortBySize
        }

        FilesTabTablesHeaderItem {
            id: progressItem
            text: qsTr("Progress") + App.loc.emptyString
            Layout.preferredWidth: 150*appWindow.zoom
            visible: !root.createDownloadDialog
            sortBy: AbstractDownloadsUi.SortByProgress
        }

        FilesTabTablesHeaderItem {
            id: priorityItem
            text: qsTr("Priority") + App.loc.emptyString
            Layout.preferredWidth: priorityColWidth
            sortBy: AbstractDownloadsUi.SortByPriority

            Rectangle {
                height: parent.height
                width: 1*appWindow.zoom
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
                property int rowHeigth: 22*appWindow.zoom
                width: listView.width
                height: rowHeigth
                Layout.preferredHeight: rowHeigth

                MouseArea {
                    id: mouseAreaRow
                    hoverEnabled: true
                    anchors.fill: parent
                    propagateComposedEvents: true
                    //z: -1 // for the checkboxes to work

                    acceptedButtons: Qt.LeftButton | Qt.RightButton

//                    signal deletedFile(var ids)
//                    signal removedFromList(var ids)

                    onPressed: function (mouse) {
                        //selectedDownloadsTools.downloadMousePressed(downloadModel.id, mouse)
                    }

                    onClicked: function (mouse) {
                        selectedIndex = index
                        if (mouse.button === Qt.RightButton && !root.createDownloadDialog)
                            showMenu(mouse);
                    }

                    onDoubleClicked: {
                        if (downloadItemId && !model.folder && App.downloads.infos.info(downloadItemId).fileInfo(model.fileIndex).finished) {
                            App.downloads.mgr.openDownload(downloadItemId, model.fileIndex);
                        }
                    }

                    function showMenu(mouse)
                    {
                        var download = App.downloads.infos.info(downloadItemId);
                        var component = Qt.createComponent("FilesTreeContextMenu.qml");
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

                Rectangle {
                    visible: index === selectedIndex
                    border.color: appWindow.theme.selectedBorder
                    border.width: 1*appWindow.zoom
                    anchors.fill: parent
                    color: appWindow.theme.selectedBackground
                }

                RowLayout {
                    width: parent.width
                    height: 15*appWindow.zoom
                    spacing: 0

                    RowLayout {
                        Layout.preferredHeight: rowHeigth
                        Layout.preferredWidth: nameItem.width
                        Layout.minimumWidth: Layout.preferredWidth
                        spacing: 0

                        Rectangle {
                            Layout.leftMargin: qtbug.leftMargin(5*appWindow.zoom, 0)
                            Layout.rightMargin: qtbug.rightMargin(5*appWindow.zoom, 0)
                            Layout.preferredWidth: ((model.level + (model.folder ? 0 : 1)) * 15)*appWindow.zoom
                            Layout.preferredHeight: rowHeigth
                            color: "transparent"
                        }

                        Item {
                            visible: model.folder
                            Layout.alignment: Qt.AlignVCenter
                            Layout.preferredWidth: 15*appWindow.zoom
                            Layout.preferredHeight: 15*appWindow.zoom
                            WaSvgImage {
                                source: appWindow.theme.elementsIconsRoot+(model.isOpened ? "/triangle_down.svg" : "/triangle_right.svg")
                                zoom: appWindow.zoom
                                anchors.centerIn: parent
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: model.isOpened = !model.isOpened
                            }
                        }

                        BaseCheckBox {
                            tristate: true
                            checkBoxStyle: 'blue'
                            checkState: model.priority == AbstractDownloadsUi.DownloadPriorityDontDownload ? Qt.Unchecked :
                                (model.folder && model.priority == AbstractDownloadsUi.DownloadPriorityUnknown
                                    && model.childrenHasDontDownloadPriority ? Qt.PartiallyChecked : Qt.Checked )
                            onClicked: {
                                if (checkState == Qt.Unchecked) {
                                    model.selectedForDownload = AbstractDownloadsUi.IsNotSelectedForDownload;
                                } else {
                                    model.selectedForDownload = AbstractDownloadsUi.FullySelectedForDownload;
                                    downloadInfo.autoStartAllowed = true;
                                }
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.leftMargin: 5*appWindow.zoom
                            Layout.rightMargin: 5*appWindow.zoom
                            Layout.preferredHeight: rowHeigth
                            color: "transparent"
                            clip: true
                            BaseLabel {
                                id: label
                                anchors.verticalCenter: parent.verticalCenter
                                elide: Text.ElideRight
                                width: parent.width
                                text: model.name
                                font.pixelSize: 13*appWindow.fontZoom
                                color: appWindow.theme.filesTreeText

                                MouseArea {
                                    id: mouseAreaLabel
                                    propagateComposedEvents: true
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked : function (mouse) {mouse.accepted = false;}
                                    onPressed: function (mouse) {mouse.accepted = false;}

                                    BaseToolTip {
                                        text: model.name
                                        visible: label.truncated && parent.containsMouse
                                    }
                                }
                            }
                        }
                    }

                    Rectangle {
                        Layout.preferredHeight: rowHeigth
                        Layout.preferredWidth: sizeItem.width
                        Layout.minimumWidth: Layout.preferredWidth
                        clip: true
                        color: "transparent"

                        Rectangle {
                            color: "transparent"
                            anchors.fill: parent
                            anchors.leftMargin: 5*appWindow.zoom
                            anchors.rightMargin: 5*appWindow.zoom
                            BaseLabel {
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                text: App.bytesAsText(model.selectedSize) + App.loc.emptyString
                                font.pixelSize: 13*appWindow.fontZoom
                                color: appWindow.theme.filesTreeText
                            }
                        }
                    }

                    RowLayout {
                        Layout.preferredWidth: progressItem.width
                        Layout.minimumWidth: Layout.preferredWidth

                        visible: !root.createDownloadDialog

                        Rectangle {
                            Layout.leftMargin: qtbug.leftMargin(5*appWindow.zoom, 0)
                            Layout.rightMargin: qtbug.rightMargin(5*appWindow.zoom, 0)
                            Layout.preferredHeight: 6*appWindow.zoom
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter
                            color: appWindow.theme.progressRunningBackground

                            Rectangle {
                                height: parent.height
                                width: parent.width * model.progress / 100
                                color: appWindow.theme.progressRunning
                            }
                        }

                        Rectangle {
                            Layout.alignment: Qt.AlignVCenter
                            Layout.preferredWidth: 45*appWindow.zoom

                            BaseLabel {
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                text: model.progress + '%'
                                font.pixelSize: 12*appWindow.fontZoom
                                color: appWindow.theme.filesTreeText
                            }
                        }
                    }

                    Rectangle {
                        id: priorityCol
                        // setting it to priorityItem.width leads to some weird QML(?) bug
                        // (priority text of the first element is drawn at a weird position)
                        // also, changing priorityColWidth at startup causes the same bug.
                        Layout.preferredWidth: priorityColWidth
                        Layout.minimumWidth: Layout.preferredWidth
                        Layout.preferredHeight: rowHeigth
                        color: "transparent"

                        property bool showControls: mouseAreaRow.containsMouse || mouseAreaUp.containsMouse
                                                    || mouseAreaDown.containsMouse || mouseAreaLabel.containsMouse
                                                    || mouseAreaPriorityLabel.containsMouse

                        RowLayout {
                            visible: model.priority != AbstractDownloadsUi.DownloadPriorityDontDownload
                                && model.priority != AbstractDownloadsUi.DownloadPriorityUnknown
                            height: rowHeigth
                            width: parent.width
                            clip: true

                            Rectangle {
                                Layout.preferredHeight: rowHeigth
                                Layout.fillWidth: true
                                Layout.leftMargin: qtbug.leftMargin(5*appWindow.zoom, 0)
                                Layout.rightMargin: qtbug.rightMargin(5*appWindow.zoom, 0)

                                color: "transparent"

                                BaseLabel {
                                    id: priorityLabel
                                    width: parent.width
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: (model.priority == AbstractDownloadsUi.DownloadPriorityNormal ? qsTr('Normal')
                                        : (model.priority == AbstractDownloadsUi.DownloadPriorityHigh ? qsTr('High')
                                            : (model.priority == AbstractDownloadsUi.DownloadPriorityLow ? qsTr('Low')
                                                : ''))) + App.loc.emptyString
                                    font.pixelSize: 13*appWindow.fontZoom
                                    elide: Label.ElideRight
                                    color: appWindow.theme.filesTreeText

                                    MouseArea {
                                        id: mouseAreaPriorityLabel
                                        propagateComposedEvents: true
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        onClicked : function (mouse) {mouse.accepted = false;}
                                        onPressed: function (mouse) {mouse.accepted = false;}

                                        BaseToolTip {
                                            text: priorityLabel.text
                                            visible: priorityLabel.truncated && parent.containsMouse
                                        }
                                    }
                                }
                            }

                            Rectangle {
                                Layout.preferredHeight: rowHeigth
                                color: "transparent"
                                Layout.preferredWidth: 16*appWindow.zoom
                                enabled: model.priority != AbstractDownloadsUi.DownloadPriorityHigh

                                Rectangle {
                                    color: "transparent"
                                    visible: priorityCol.showControls
                                    anchors.fill: parent
                                    opacity: enabled ? 1 : 0.3

                                    WaSvgImage {
                                        visible: mouseAreaUp.containsMouse
                                        anchors.left: parent.left
                                        anchors.verticalCenter: parent.verticalCenter
                                        source: Qt.resolvedUrl("../../images/desktop/priority_up_active.svg")
                                        zoom: appWindow.zoom
                                    }

                                    WaSvgImage {
                                        visible: !mouseAreaUp.containsMouse
                                        anchors.left: parent.left
                                        anchors.verticalCenter: parent.verticalCenter
                                        source: Qt.resolvedUrl("../../images/desktop/priority_up.svg")
                                        zoom: appWindow.zoom
                                    }
                                }

                                MouseArea {
                                    id: mouseAreaUp
                                    hoverEnabled: true
                                    anchors.fill: parent
                                    onClicked: {
                                        if (model.priority == AbstractDownloadsUi.DownloadPriorityNormal) {
                                            model.priority = AbstractDownloadsUi.DownloadPriorityHigh;
                                        }
                                        if (model.priority == AbstractDownloadsUi.DownloadPriorityLow) {
                                            model.priority = AbstractDownloadsUi.DownloadPriorityNormal;
                                        }
                                    }
                                }
                            }

                            Rectangle {
                                Layout.preferredHeight: rowHeigth
                                color: "transparent"
                                Layout.preferredWidth: 16*appWindow.zoom
                                Layout.rightMargin: qtbug.rightMargin(0, 10*appWindow.zoom)
                                Layout.leftMargin: qtbug.leftMargin(0, 10*appWindow.zoom)
                                enabled: model.priority != AbstractDownloadsUi.DownloadPriorityLow

                                Rectangle {
                                    color: "transparent"
                                    visible: priorityCol.showControls
                                    anchors.fill: parent
                                    opacity: enabled ? 1 : 0.3

                                    WaSvgImage {
                                        visible: mouseAreaDown.containsMouse
                                        anchors.left: parent.left
                                        anchors.verticalCenter: parent.verticalCenter
                                        source: Qt.resolvedUrl("../../images/desktop/priority_down_active.svg")
                                        zoom: appWindow.zoom
                                    }

                                    WaSvgImage {
                                        anchors.left: parent.left
                                        visible: !mouseAreaDown.containsMouse
                                        anchors.verticalCenter: parent.verticalCenter
                                        source: Qt.resolvedUrl("../../images/desktop/priority_down.svg")
                                        zoom: appWindow.zoom
                                    }
                                }

                                MouseArea {
                                    id: mouseAreaDown
                                    hoverEnabled: true
                                    anchors.fill: parent
                                    propagateComposedEvents: true
                                    onClicked: {
                                        if (model.priority == AbstractDownloadsUi.DownloadPriorityNormal) {
                                            model.priority = AbstractDownloadsUi.DownloadPriorityLow;
                                        }
                                        if (model.priority == AbstractDownloadsUi.DownloadPriorityHigh) {
                                            model.priority = AbstractDownloadsUi.DownloadPriorityNormal;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
