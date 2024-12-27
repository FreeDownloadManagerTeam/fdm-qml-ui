import QtQuick
import QtQuick.Controls
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.abstractdownloadsui 1.0
import ".."
import "../BaseElements/V2"

ListView
{
    id: listView

    property var downloadsViewHeader

    flickableDirection: Flickable.AutoFlickIfNeeded
    boundsBehavior: Flickable.StopAtBounds
    highlightFollowsCurrentItem: true
    headerPositioning: ListView.OverlayHeader
    reuseItems: true

    model: App.downloads.model

    delegate: DownloadsViewItem_V2
    {
        z: model.id === selectedDownloadsTools.currentDownloadId ? 5 : 3
        downloadsViewHeader: listView.downloadsViewHeader
        //parentY: y
        noActionsAllowed: downloadsViewTools.showingDownloadsWithMissingFilesOnly
        DownloadsViewItemMouseArea {
            downloadModel: model
            anchors.fill: parent
        }
        //readonly property bool lastChild: index == count -1

        //batch download background
        /*Rectangle {
            z: -2
            anchors.fill: parent
            visible: downloadsViewTools.downloadsParentIdFilter > -1
            anchors.topMargin: 1
            color: appWindow.theme.batchDownloadBackground
        }*/

        //selected download background
        /*Rectangle {
            z: -1
            anchors.fill: parent
            anchors.topMargin: 1
            visible: !!model.checked
            color: appWindow.theme.selectedBackground
        }*/

        //priority marker
        /*Rectangle {
            id: priority
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 1
            anchors.topMargin: 1
            width: 4*appWindow.zoom
            height: lastChild ? parent.height-2 : parent.height-1
            color: model.priority == AbstractDownloadsUi.DownloadPriorityHigh ? appWindow.theme.highMode : appWindow.theme.lowMode
            visible: model.priority != AbstractDownloadsUi.DownloadPriorityNormal
        }*/

        //selected download frame
        /*Rectangle {
            visible: model.id === selectedDownloadsTools.currentDownloadId
            border.color: appWindow.active ? appWindow.theme_v2.primary : appWindow.theme_v2.secondary
            border.width: 1*appWindow.zoom
            width: parent.width
            height:  parent.height - parent.myVerticalPadding
            color: "transparent"
            anchors.verticalCenter: parent.verticalCenter
        }*/
    }

    /*MouseArea {
        z: -1
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: selectedDownloadsTools.resetSelecting()
    }*/

    ScrollBar.vertical: BaseScrollBar_V2 {
        policy: parent.contentHeight > parent.height ?
                    ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
    }

    DownloadsDropArea_V2 {
        visible: listView.count > 0 &&
                 listView.contentHeight < listView.height - 100*appWindow.zoom
        anchors.fill: parent
        anchors.leftMargin: appWindow.theme_v2.mainWindowLeftMargin*appWindow.zoom
        anchors.rightMargin: appWindow.theme_v2.mainWindowRightMargin*appWindow.zoom
        anchors.topMargin: 16*appWindow.zoom
        anchors.bottomMargin: 16*appWindow.zoom
        visibleAreaTopMargin: listView.contentHeight
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
