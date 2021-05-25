import QtQuick 2.12
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import QtQuick.Window 2.12
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
                                          speedColumnBlock.visibleItem == btBlock ? btBlock.implicitWidth+10 :
                                          speedColumnBlock.visibleItem == priorityBlock ? priorityText.contentWidth + imgUp.width*2 + 10 : 0
    property double lastTimeSpeedColumnHoveredWidthBecameZero: 0
    onSpeedColumnHoveredWidthChanged: {
        if (!speedColumnHoveredWidth)
            lastTimeSpeedColumnHoveredWidthBecameZero = appWindow.currentTime;
    }

    property bool modelChecked: !!model.checked //undefined to false
    property bool modelRunning: !!model.running //undefined to false
    property bool modelFinished: model.finished
    property string modelError: model.error
    property int parentY

    signal showingCompleteMessage(bool isShowing)

    onModelCheckedChanged: selectedDownloadsTools.modelCheckedChanged(model.id)
    onModelRunningChanged: selectedDownloadsTools.modelRunningChanged(model.id)
    onModelFinishedChanged: selectedDownloadsTools.modelFinishedChanged(model.id)
    onModelErrorChanged: selectedDownloadsTools.modelErrorChanged(model.id)

    width: parent.width

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
            spacing: 8

            BaseCheckBox {
                Layout.leftMargin: 8
                Layout.alignment: Qt.AlignVCenter
                xOffset: 0
                locked: downloadsItemTools.locked
                checked: !!model.checked
                MouseArea {
                    anchors.fill: parent
                    property int pressY
                    property int lastIndex: -1
                    onMouseYChanged: {
                        if (mouse.buttons == Qt.LeftButton && Math.abs(pressY - mouse.y) > 5) {
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

                    onPressed: {
                        if (mouse.button == Qt.LeftButton)
                        {
                            listView.interactive = false;
                            pressY = mouse.y
                            lastIndex = -1;
                        }
                    }

                    onReleased: {
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
                enabled: !downloadsItemTools.locked && (downloadsItemTools.finished || !downloadsItemTools.stopping)
                onClicked: downloadsItemTools.doAction()
                Layout.alignment: Qt.AlignVCenter
            }

            DownloadIcon {
                visible: !appWindow.compactView
                Layout.alignment: Qt.AlignVCenter
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
            width: root.downloadsViewHeader.itemAt(1).width
                    + (statusItem.isEmpty ? root.downloadsViewHeader.itemAt(2).width : 0)
                    + (statusItem.isEmpty && speedColumnBlock.isEmpty ? root.downloadsViewHeader.itemAt(3).width : 0)
            leftPadding: 6
            rightPadding: itemTags.width ? itemTags.width + 10 + 5 : 5
            font.pixelSize: appWindow.compactView ? 13 : 14
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
                onClicked : mouse.accepted = false
                onPressed: mouse.accepted = false

                BaseToolTip {
                    text: downloadsItemTools.tplTitle
                    visible: parent.containsMouse
                }
            }

            DownloadsViewItemTags {
                id: itemTags
                anchors.left: parent.left
                anchors.leftMargin: parent.contentWidth + parent.leftPadding + 10
                anchors.verticalCenter: parent.verticalCenter
            }

            // "hover" handler for speed column block in case it's not visible
            Rectangle
            {
                color: "transparent"
                id: hhTitleSpeedColumn
                property bool hovered: false
                anchors.right: parent.right
                width: root.downloadsViewHeader.itemAt(3).width
                height: parent.height
                visible: statusItem.isEmpty && speedColumnBlock.isEmpty
                HoverHandler {id: hhTitleSpeedColumn1}
                CppControls.HoverHandler {id: hhTitleSpeedColumn2; margins: -2}
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
            color: "transparent"
            width: statusItem.isEmpty ? 0 : root.downloadsViewHeader.itemAt(2).width
            height: parent.height
            Item {
                anchors.fill: parent
                anchors.leftMargin: 6
                anchors.rightMargin: 6
                DownloadsViewStatusItem {
                    id: statusItem
                    anchors.fill: parent
                    onShowingCompleteMessage: root.showingCompleteMessage(isShowing)
                }
            }
        }

        //speed, priority and more
        Item {
            id: speedColumnBlock         

            property bool hovered: (hh1Row.hovered && hh2Row.hovered) ||
                                   priorUp.hovered || priorDown.hovered ||
                                   loAbortBlock.hovered || hhTitleSpeedColumn.hovered
            property bool canChangePriority: !downloadsItemTools.finished || downloadsItemTools.hasPostFinishedTasks

            property var visibleItem: (downloadsItemTools.performingLo && downloadsItemTools.loAbortable) ? loAbortBlock :
                                      (appWindow.btSupported && hovered && downloadsItemTools.finished && downloadsItemTools.hasPostFinishedTasks) ? btBlock :
                                      (appWindow.btSupported && downloadsItemTools.finished && downloadsItemTools.hasPostFinishedTasks && !downloadsItemTools.postFinishedTasksAllowed) ? btPausedBlock :
                                      (canChangePriority && hovered && model.priority != AbstractDownloadsUi.DownloadPriorityDontDownload && model.priority != AbstractDownloadsUi.DownloadPriorityUnknown) ? priorityBlock :
                                      (downloadsItemTools.running) ? speedBlock : null

            property bool isEmpty: !visibleItem &&
                                   (appWindow.currentTime - lastTimeSpeedColumnHoveredWidthBecameZero) > 30000

            width: statusItem.isEmpty && isEmpty ? 0 : root.downloadsViewHeader.itemAt(3).width
            height: parent.height

            HoverHandler {id: hh1Row}
            CppControls.HoverHandler {id: hh2Row; margins: -2}

            //speed
            DownloadSpeed {
                id: speedBlock
                visible: speedColumnBlock.visibleItem == speedBlock
                anchors.fill: parent
                anchors.leftMargin: 6
                anchors.rightMargin: 6
                myDownloadsItemTools: downloadsItemTools
            }

            //priority
            RowLayout {
                id: priorityBlock
                visible: speedColumnBlock.visibleItem == priorityBlock
                anchors.fill: parent
                anchors.leftMargin: 5
                spacing: 5
                clip: true

                Rectangle {
                    id: priorUp
                    property bool hovered: hh1Up.hovered && hh2Up.hovered
                    Layout.preferredWidth: imgUp.width
                    Layout.fillHeight: true
                    color: "transparent"
                    enabled: model.priority != AbstractDownloadsUi.DownloadPriorityHigh

                    Image {
                        id: imgUp
                        anchors.verticalCenter: parent.verticalCenter
                        opacity: enabled ? 1 : 0.3
                        source: Qt.resolvedUrl("../images/desktop/" + (priorUp.hovered ? "priority_up_active.svg" : "priority_up.svg"))
                        sourceSize.width: 16
                        sourceSize.height: 16
                    }

                    HoverHandler {id: hh1Up}
                    CppControls.HoverHandler {id: hh2Up; margins: -1}

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

                    Image {
                        id: imgDown
                        opacity: enabled ? 1 : 0.3
                        anchors.verticalCenter: parent.verticalCenter
                        source: Qt.resolvedUrl("../images/desktop/" + (priorDown.hovered ? "priority_down_active.svg" : "priority_down.svg"))
                        sourceSize.width: 16
                        sourceSize.height: 16
                    }

                    HoverHandler {id: hh1Down}
                    CppControls.HoverHandler {id: hh2Down; margins: -1}

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
                    font.pixelSize: appWindow.compactView ? 9 : 11
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
                anchors.leftMargin: 5
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
                font.pixelSize: appWindow.compactView ? 9 : 11
                x: 7
                width: parent.width - x - 20
                height: parent.height
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.WordWrap
            }

            Rectangle
            {
                id: loAbortBlock
                visible: speedColumnBlock.visibleItem == loAbortBlock
                color: "transparent"
                width: 24
                height: 24
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.verticalCenter: parent.verticalCenter
                property bool hovered: hh1LoAbort.hovered && hh2LoAbort.hovered

                Image
                {
                    id: loAbortImg
                    source: Qt.resolvedUrl("../images/close-circle.svg")
                    anchors.fill: parent
                    sourceSize.width: 24*Screen.devicePixelRatio
                    sourceSize.height: 24*Screen.devicePixelRatio
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
            anchors.verticalCenter: parent.verticalCenter
            text: JsTools.sizeUtils.byteProgressAsText(downloadsItemTools.selectedBytesDownloaded, downloadsItemTools.selectedSize);
            width: root.downloadsViewHeader.itemAt(4).width
            leftPadding: 6
            font.pixelSize: appWindow.compactView ? 12 : 13
            opacity: downloadsItemTools.itemOpacity
        }

        //date
        BaseLabel {
            anchors.verticalCenter: parent.verticalCenter
            width: root.downloadsViewHeader.itemAt(5).width
            leftPadding: 6
            rightPadding: 6
            text: App.loc.dateOrTimeToString(model.added, false) + App.loc.emptyString
            font.pixelSize: appWindow.compactView ? 12 : 13
            opacity: downloadsItemTools.itemOpacity
            MouseArea {
                propagateComposedEvents: true
                anchors.fill: parent
                hoverEnabled: true
                onClicked : mouse.accepted = false
                onPressed: mouse.accepted = false

                BaseToolTip {
                    text: App.loc.dateTimeToString(model.added, true) + App.loc.emptyString
                    visible: parent.containsMouse
                }
            }
        }
    }
}


