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
        noActionsAllowed: downloadsViewTools.showingDownloadsWithMissingFilesOnly
        DownloadsViewItemMouseArea {
            id: itemMa
            downloadModel: model
            anchors.fill: parent
        }

        onJustPressed: mouse => itemMa.onPressed(mouse)
        onJustReleased: mouse => itemMa.onReleased(mouse)
        onJustClicked: mouse => itemMa.onClicked(mouse)
    }

    ScrollBar.vertical: BaseScrollBar_V2 {
        id: vbar

        policy: parent.contentHeight > parent.height ?
                    ScrollBar.AlwaysOn : ScrollBar.AlwaysOff

        stepSize: 1.0 / listView.count
        snapMode: ScrollBar.SnapOnRelease
    }

    WheelHandler {
        onWheel: event => Qt.callLater(event.angleDelta.y > 0 ? vbar.decrease : vbar.increase)
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
