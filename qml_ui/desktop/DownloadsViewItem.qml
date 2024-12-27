import QtQuick 2.12
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Window 2.12
import "../qt5compat"
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.abstractdownloadsui 1.0
import CppControls 1.0 as CppControls

import "../common"
import "./BaseElements"
import "../common/Tools"

Item
{
    id: root

    property var downloadsViewHeader
    property bool speedColumnHovered: speedColumnBlock.hovered
    property int speedColumnHoveredWidth: !speedColumnHovered ? 0 :
                                          speedColumnBlock.visibleItem == btBlock ? btBlock.implicitWidth+10*appWindow.zoom :
                                          speedColumnBlock.visibleItem == priorityBlock ? priorityText.contentWidth + imgUp.width*2 + 10*appWindow.zoom : 0
    property double lastTimeSpeedColumnHoveredWidthBecameZero: 0
    onSpeedColumnHoveredWidthChanged: {
        if (!speedColumnHoveredWidth)
            lastTimeSpeedColumnHoveredWidthBecameZero = appWindow.currentTime;
    }

    property int parentY

    property bool noActionsAllowed: false

    signal showingCompleteMessage(bool isShowing)

    readonly property bool hasStatusItem: downloadsViewHeader.itemAt(2).visible
    readonly property bool hasSpeedItem: downloadsViewHeader.itemAt(3).visible
    readonly property bool hasSizeItem: downloadsViewHeader.itemAt(4).visible
    readonly property bool hasAddedItem: downloadsViewHeader.itemAt(5).visible

    readonly property bool eatStatusItem: hasStatusItem && statusItem.isEmpty
    readonly property bool eatSpeedItem: (eatStatusItem || !hasStatusItem) && hasSpeedItem && speedColumnBlock.isEmpty

    width: parent ? parent.width : 0

    Component.onDestruction: {
        speedColumnHovered = 0;
    }

    DownloadsItemTools {
        id: downloadsItemTools
        itemId: model.id
        property bool locked: downloadsItemTools.lockReason != ""
        property double itemOpacity: downloadsItemTools.locked ? 0.4 : 1
    }

    Row {
        width: parent.width
        height: parent.height
        anchors.verticalCenter: parent.verticalCenter
        RowLayout {
            width: root.downloadsViewHeader.itemAt(0).width
            anchors.verticalCenter: parent.verticalCenter
            spacing: 8*appWindow.zoom

            BaseCheckBox {
                Layout.leftMargin: qtbug.leftMargin(8*appWindow.zoom, 0)
                Layout.rightMargin: qtbug.rightMargin(8*appWindow.zoom, 0)
                Layout.alignment: Qt.AlignVCenter
                xOffset: 0
                locked: downloadsItemTools.locked
                checked: !!model.checked
                MouseArea {
                    anchors.fill: parent
                    property int pressY
                    property int lastIndex: -1
                    onMouseYChanged: {
                        if (pressedButtons == Qt.LeftButton && Math.abs(pressY - mouseY) > 5) {
                            var newIndex = listView.indexAt(10, parentY + mouseY);
                            if (newIndex != -1 && newIndex != lastIndex) {
                                lastIndex = newIndex;
                                var endId = App.downloads.model.idByIndex(lastIndex)
                                if (model.id != endId) {
                                    selectedDownloadsTools.selectedByMouse(model.id, endId);
                                } else {
                                    App.downloads.model.checkAll(false);
                                }
                            }
                            listView.currentIndex = lastIndex;
                        }
                    }

                    onPressed: function (mouse) {
                        if (mouse.button == Qt.LeftButton)
                        {
                            listView.interactive = false;
                            pressY = mouse.y
                            lastIndex = -1;
                        }
                    }

                    onReleased: function (mouse) {
                        listView.interactive = true;
                        if (mouse.button == Qt.LeftButton) {
                            if (pressY != mouse.y) {
                                var newIndex = listView.indexAt(10, parentY + mouseY);
                                if (newIndex != -1) {
                                    var endId = App.downloads.model.idByIndex(newIndex)
                                }
                                if (newIndex == -1 || model.id != endId) {
                                    return;
                                }
                            }
                        }
                        selectedDownloadsTools.changeItemChecked(model.id, mouse)
                    }
                }
            }

            ItemActionBtn {
                moduleUid: downloadsItemTools.moduleUid
                buttonType: downloadsItemTools.buttonType
                enabled: !noActionsAllowed && !downloadsItemTools.locked &&
                         (downloadsItemTools.finished || !downloadsItemTools.stopping)
                onClicked: downloadsItemTools.doAction()
                Layout.alignment: Qt.AlignVCenter
            }

            DownloadIcon {
                visible: !appWindow.compactView
                Layout.alignment: Qt.AlignVCenter

                DragArea {
                    readonly property bool multiMode: selectedDownloadsTools.draggableCheckedIds.includes(downloadsItemTools.itemId)
                    readonly property var uriList:  multiMode ? selectedDownloadsTools.draggableCheckedFilesDragUriList :
                                                    downloadsItemTools.item ? downloadsItemTools.item.filesDragUriList :
                                                    []
                    enabled: !App.rc.client.active && uriList.length
                    anchors.fill: parent
                    mimeData: {"text/uri-list": uriList.join('\n') }
                    onTimeToSetDragImageSource: {
                        if (multiMode)
                        {
                            Drag.imageSource = "";
                        }
                        else
                        {
                            titleLabel.grabToImage(function(result)
                            {
                                Drag.imageSource = result.url;
                            });
                        }
                    }
                    onDragStarted: appWindow.disableDrop = true
                    onDragFinished: function (dropAction)
                    {
                        appWindow.disableDrop = false;

                        if (dropAction == Qt.MoveAction)
                        {
                            App.downloads.mgr.forceCheckForMissingFiles(
                                        multiMode ? selectedDownloadsTools.draggableCheckedIds : [downloadsItemTools.itemId]);
                        }
                    }
                }
            }

            Rectangle {
                color: "transparent"
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }

        //title
        BaseLabel {
            id: titleLabel
            clip: true
            property string elidedText: fmTitle.myElidedText(downloadsItemTools.tplTitle, width-leftPadding-rightPadding)
            anchors.verticalCenter: parent.verticalCenter
            text: elidedText
            width: root.downloadsViewHeader.nameColumnFullWidth
                    + (root.eatStatusItem ? root.downloadsViewHeader.statusColumnFullWidth : 0)
                    + (root.eatSpeedItem ? root.downloadsViewHeader.speedColumnFullWidth : 0)
            leftPadding: qtbug.leftPadding(6, itemTags.width ? itemTags.width + 10*appWindow.zoom + 5*appWindow.zoom : 5*appWindow.zoom)
            rightPadding: qtbug.rightPadding(6, itemTags.width ? itemTags.width + 10*appWindow.zoom + 5*appWindow.zoom : 5*appWindow.zoom)
            font.pixelSize: appWindow.fonts.defaultSize
            opacity: downloadsItemTools.itemOpacity

            MyFontMetrics {
                id: fmTitle
                font: titleLabel.font
            }

            MouseArea {
                enabled: titleLabel.text != downloadsItemTools.tplTitle
                propagateComposedEvents: true
                anchors.left: parent.left
                anchors.right: itemTags.width ? itemTags.left : parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                hoverEnabled: true
                onClicked : function (mouse) {mouse.accepted = false;}
                onPressed: function (mouse) {mouse.accepted = false;}

                BaseToolTip {
                    text: downloadsItemTools.tplTitle
                    visible: parent.containsMouse
                }
            }

            DownloadsViewItemTags {
                id: itemTags
                anchors.left: parent.left
                anchors.leftMargin: parent.contentWidth + qtbug.getLeftPadding(parent) + 10*appWindow.zoom
                anchors.verticalCenter: parent.verticalCenter
            }

            // "hover" handler for speed column block in case it's not visible
            Rectangle
            {
                color: "transparent"
                id: hhTitleSpeedColumn
                property bool hovered: false
                anchors.right: parent.right
                width: root.hasSpeedItem ? root.downloadsViewHeader.speedColumnFullWidth : 150*appWindow.zoom
                height: parent.height
                visible: statusItem.isEmpty && speedColumnBlock.isEmpty
                HoverHandler {id: hhTitleSpeedColumn1}
                CppControls.HoverHandler {id: hhTitleSpeedColumn2; margins: -2*appWindow.zoom}
                property bool internalHovered: hhTitleSpeedColumn1.hovered && hhTitleSpeedColumn2.hovered
                Timer {
                    id: hhTitleSpeedColumnTimer
                    interval: 100
                    repeat: false
                    onTriggered: hhTitleSpeedColumn.hovered = false
                }
                onInternalHoveredChanged: {
                    if (internalHovered && visible)
                    {
                        hhTitleSpeedColumnTimer.stop();
                        hhTitleSpeedColumn.hovered = true;
                    }
                    else
                    {
                        hhTitleSpeedColumnTimer.restart();
                    }
                }
            }
        }

        //status
        Rectangle {
            visible: root.hasStatusItem
            color: "transparent"
            width: statusItem.isEmpty ? 0 : root.downloadsViewHeader.statusColumnFullWidth
            height: parent.height
            Item {
                anchors.fill: parent
                anchors.leftMargin: 6*appWindow.zoom
                anchors.rightMargin: 6*appWindow.zoom
                DownloadsViewStatusItem {
                    id: statusItem
                    anchors.fill: parent
                    onShowingCompleteMessage: isShowing => root.showingCompleteMessage(isShowing)
                }
            }
        }

        //speed, priority and more
        Item {
            id: speedColumnBlock         

            visible: root.hasSpeedItem

            property bool hovered: (hh1Row.hovered && hh2Row.hovered) ||
                                   priorUp.hovered || priorDown.hovered ||
                                   loAbortBlock.hovered || hhTitleSpeedColumn.hovered
            property bool canChangePriority: !downloadsItemTools.finished || downloadsItemTools.hasPostFinishedTasks

            property var visibleItem: (!noActionsAllowed && downloadsItemTools.performingLo && downloadsItemTools.loAbortable) ? loAbortBlock :
                                      (!noActionsAllowed && appWindow.btSupported && hovered && downloadsItemTools.finished && downloadsItemTools.hasPostFinishedTasks) ? btBlock :
                                      (!noActionsAllowed && appWindow.btSupported && downloadsItemTools.finished && downloadsItemTools.hasPostFinishedTasks && !downloadsItemTools.postFinishedTasksAllowed) ? btPausedBlock :
                                      (!noActionsAllowed && canChangePriority && hovered && model.priority != AbstractDownloadsUi.DownloadPriorityDontDownload && model.priority != AbstractDownloadsUi.DownloadPriorityUnknown) ? priorityBlock :
                                      (downloadsItemTools.running) ? speedBlock : null

            property bool isEmpty: !visibleItem &&
                                   (appWindow.currentTime - lastTimeSpeedColumnHoveredWidthBecameZero) > 30000

            width: statusItem.isEmpty && isEmpty ? 0 : root.downloadsViewHeader.speedColumnFullWidth
            height: parent.height

            HoverHandler {id: hh1Row}
            CppControls.HoverHandler {id: hh2Row; margins: -2*appWindow.zoom}

            //speed
            DownloadSpeed {
                id: speedBlock
                visible: speedColumnBlock.visibleItem == speedBlock
                anchors.fill: parent
                anchors.leftMargin: 6*appWindow.zoom
                anchors.rightMargin: 6*appWindow.zoom
                myDownloadsItemTools: downloadsItemTools
            }

            //priority
            RowLayout {
                id: priorityBlock
                visible: speedColumnBlock.visibleItem == priorityBlock
                anchors.fill: parent
                anchors.leftMargin: 5*appWindow.zoom
                spacing: 5*appWindow.zoom
                clip: true

                Rectangle {
                    id: priorUp
                    property bool hovered: hh1Up.hovered && hh2Up.hovered
                    Layout.preferredWidth: imgUp.width
                    Layout.fillHeight: true
                    color: "transparent"
                    enabled: model.priority != AbstractDownloadsUi.DownloadPriorityHigh

                    WaSvgImage {
                        id: imgUp
                        anchors.verticalCenter: parent.verticalCenter
                        opacity: enabled ? 1 : 0.3
                        source: Qt.resolvedUrl("../images/desktop/" + (priorUp.hovered ? "priority_up_active.svg" : "priority_up.svg"))
                        zoom: appWindow.zoom
                    }

                    HoverHandler {id: hh1Up}
                    CppControls.HoverHandler {id: hh2Up; margins: -1*appWindow.zoom}

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (model.priority == AbstractDownloadsUi.DownloadPriorityNormal) {
                                App.downloads.infos.info(model.id).priority = AbstractDownloadsUi.DownloadPriorityHigh;
                            } else if (model.priority == AbstractDownloadsUi.DownloadPriorityLow) {
                                App.downloads.infos.info(model.id).priority = AbstractDownloadsUi.DownloadPriorityNormal;
                            }
                        }
                    }
                }

                Rectangle {
                    id: priorDown
                    property bool hovered: hh1Down.hovered && hh2Down.hovered
                    Layout.preferredWidth: imgDown.width
                    Layout.fillHeight: true
                    color: "transparent"
                    enabled: model.priority != AbstractDownloadsUi.DownloadPriorityLow

                    WaSvgImage {
                        id: imgDown
                        opacity: enabled ? 1 : 0.3
                        anchors.verticalCenter: parent.verticalCenter
                        source: Qt.resolvedUrl("../images/desktop/" + (priorDown.hovered ? "priority_down_active.svg" : "priority_down.svg"))
                        zoom: appWindow.zoom
                    }

                    HoverHandler {id: hh1Down}
                    CppControls.HoverHandler {id: hh2Down; margins: -1*appWindow.zoom}

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (model.priority == AbstractDownloadsUi.DownloadPriorityHigh) {
                                App.downloads.infos.info(model.id).priority = AbstractDownloadsUi.DownloadPriorityNormal;
                            } else if (model.priority == AbstractDownloadsUi.DownloadPriorityNormal) {
                                App.downloads.infos.info(model.id).priority = AbstractDownloadsUi.DownloadPriorityLow;
                            }
                        }
                    }
                }

                BaseLabel {
                    id: priorityText
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                    color: appWindow.theme.foreground
                    font.pixelSize: (appWindow.compactView ? 9 : 11)*appWindow.fontZoom
                    text: qsTr('Priority') + App.loc.emptyString
                }
            }

            // bt mouse hover stuff
            Loader {
                id: btBlock
                active: appWindow.btSupported
                visible: speedColumnBlock.visibleItem == btBlock
                source: "../bt/desktop/DownloadsSpeedColumnItem.qml"
                anchors.fill: parent
                anchors.leftMargin: 5*appWindow.zoom
                onItemChanged: {
                    if (item) {
                        item.downloadId = Qt.binding(function(){return model.id;});
                        item.downloadTools = Qt.binding(function(){return downloadsItemTools;});
                    }
                }
            }

            // bt paused stuff
            BaseLabel {
                id: btPausedBlock
                visible: speedColumnBlock.visibleItem == btPausedBlock
                color: appWindow.theme.foreground
                text: qsTr("Upload paused") + App.loc.emptyString
                font.pixelSize: (appWindow.compactView ? 9 : 11)*appWindow.fontZoom
                anchors.left: parent.left
                leftPadding: qtbug.leftPadding(7, 0)
                rightPadding: qtbug.rightPadding(7, 0)
                width: parent.width - qtbug.getLeftPadding(this) - 20*appWindow.zoom
                height: parent.height
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.WordWrap
            }

            Rectangle
            {
                id: loAbortBlock
                visible: speedColumnBlock.visibleItem == loAbortBlock
                color: "transparent"
                width: loAbortImg.preferredWidth
                height: loAbortImg.preferredHeight
                anchors.left: parent.left
                anchors.leftMargin: 5*appWindow.zoom
                anchors.verticalCenter: parent.verticalCenter
                property bool hovered: hh1LoAbort.hovered && hh2LoAbort.hovered

                WaSvgImage
                {
                    id: loAbortImg
                    source: Qt.resolvedUrl("../images/close-circle.svg")
                    zoom: appWindow.zoom
                }

                HoverHandler {id: hh1LoAbort}
                CppControls.HoverHandler {id: hh2LoAbort; margins: -1}

                MouseArea
                {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: downloadsItemTools.abortLo()
                }
            }
        }

        //file size
        BaseLabel {
            visible: root.hasSizeItem
            anchors.verticalCenter: parent.verticalCenter
            text: App.bytesProgressAsText(downloadsItemTools.selectedBytesDownloaded, downloadsItemTools.selectedSize, false) + App.loc.emptyString
            width: root.downloadsViewHeader.sizeColumnFullWidth
            leftPadding: qtbug.leftPadding(6*appWindow.zoom, 0)
            rightPadding: qtbug.rightPadding(6*appWindow.zoom, 0)
            font.pixelSize: (appWindow.compactView ? 12 : 13)*appWindow.fontZoom
            opacity: downloadsItemTools.itemOpacity
        }

        //date
        BaseLabel {
            visible: root.hasAddedItem
            anchors.verticalCenter: parent.verticalCenter
            width: root.downloadsViewHeader.dateColumnFullWidth
            leftPadding: 6*appWindow.zoom
            rightPadding: 6*appWindow.zoom
            text: App.loc.dateOrTimeToString(model.added, false) + App.loc.emptyString
            font.pixelSize: (appWindow.compactView ? 12 : 13)*appWindow.fontZoom
            opacity: downloadsItemTools.itemOpacity
            MouseArea {
                propagateComposedEvents: true
                anchors.fill: parent
                hoverEnabled: true
                onClicked: function (mouse) {mouse.accepted = false;}
                onPressed: function (mouse) {mouse.accepted = false;}

                BaseToolTip {
                    text: App.loc.dateTimeToString(model.added, true) + App.loc.emptyString
                    visible: parent.containsMouse
                }
            }
        }
    }
}


