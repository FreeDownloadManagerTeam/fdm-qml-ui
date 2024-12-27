import QtQuick 2.10
import QtQuick.Controls 2.3
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.abstractdownloadsui 1.0
import "../common"

ListView {
    id: listView
    property var downloadsViewHeader
    property int itemHeight: (appWindow.compactView ? 24 : 40)*appWindow.zoom*Math.max(Math.min(appWindow.zoom2, 1.2), 0.8)
    property double speedColumnHoveredDownloadId: -1
    property int speedColumnHoveredWidth: 0
    property double speedColumnNotHoveredSinceTime: 0
    property int showingCompleteMsg: 0

    flickableDirection: Flickable.AutoFlickIfNeeded
    boundsBehavior: Flickable.StopAtBounds
    highlightFollowsCurrentItem: true
    headerPositioning: ListView.OverlayHeader

    model: App.downloads.model

    delegate: DownloadsViewItem {
        id: viewItem
        z: model.id === selectedDownloadsTools.currentDownloadId ? 5 : 3
        height: lastChild ? itemHeight + 1*appWindow.zoom : itemHeight
        downloadsViewHeader: listView.downloadsViewHeader
        parentY: y
        noActionsAllowed: downloadsViewTools.showingDownloadsWithMissingFilesOnly
        DownloadsViewItemMouseArea {
            downloadModel: model
            anchors.fill: parent
        }

        onSpeedColumnHoveredWidthChanged: {
            if (speedColumnHoveredWidth)
            {
                listView.speedColumnHoveredDownloadId = model.id;
                listView.speedColumnHoveredWidth = speedColumnHoveredWidth;
            }
            else if (listView.speedColumnHoveredDownloadId == model.id)
            {
                listView.speedColumnNotHoveredSinceTime = Date.now();
                listView.speedColumnHoveredDownloadId = -1;
                listView.speedColumnHoveredWidth = 0;
            }
        }

        onShowingCompleteMessage: isShowing => {
            if (isShowing)
                ++listView.showingCompleteMsg;
            else
                --listView.showingCompleteMsg;
        }

        property bool lastChild: index == count -1

        //batch download background
        Rectangle {
            z: -2
            anchors.fill: parent
            visible: downloadsViewTools.downloadsParentIdFilter > -1
            anchors.topMargin: 1
            color: appWindow.theme.batchDownloadBackground
        }

        //selected download background
        Rectangle {
            z: -1
            anchors.fill: parent
            anchors.topMargin: 1
            visible: !!model.checked
            color: appWindow.theme.selectedBackground
        }

        //priority marker
        Rectangle {
            id: priority
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 1
            anchors.topMargin: 1
            width: 4*appWindow.zoom
            height: lastChild ? parent.height-2 : parent.height-1
            color: model.priority == AbstractDownloadsUi.DownloadPriorityHigh ? appWindow.theme.highMode : appWindow.theme.lowMode
            visible: model.priority != AbstractDownloadsUi.DownloadPriorityNormal
        }

        //downloads separator at top - for all except first child
        Rectangle {
            visible: index
            color: appWindow.theme.downloadItemsBorder
            width: parent.width - 2
            height: 1*appWindow.zoom
            anchors.top: viewItem.top
            anchors.horizontalCenter: parent.horizontalCenter
        }

        //downloads separator at bottom - only for last child
        Rectangle {
            visible: lastChild
            color: appWindow.theme.downloadItemsBorder
            width: parent.width - 2
            height: 1*appWindow.zoom
            anchors.bottom: viewItem.bottom
            anchors.horizontalCenter: parent.horizontalCenter
        }

        //selected download frame
        Rectangle {
            visible: model.id === selectedDownloadsTools.currentDownloadId
            border.color: appWindow.active ? appWindow.theme.selectedBorder : appWindow.theme.inactiveSelectedBorder
            border.width: 1*appWindow.zoom
            width: parent.width
            height: lastChild ? parent.height : parent.height + 1
            color: "transparent"
        }
    }

    MouseArea {
        z: -1
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: selectedDownloadsTools.resetSelecting()
    }

    ScrollBar.vertical: ScrollBar {}

    DropArea {
        enabled: !appWindow.disableDrop
        anchors.fill: parent
        onDropped: {
            if (!drag.source)
                App.onDropped(drop)
        }
    }

    onHeightChanged:  {
        if (bottomPanelTools.bottomPanelJustOpened) {
            bottomPanelTools.bottomPanelJustOpened = false;
            selectedDownloadsTools.currentDownloadsVisible();
        }
    }

    Component.onCompleted: {
        selectedDownloadsTools.registerListView(this);
    }

    Component.onDestruction: {
        selectedDownloadsTools.unregisterListView(this);
    }
}
