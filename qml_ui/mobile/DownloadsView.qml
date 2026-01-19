import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import org.freedownloadmanager.fdm
import "../common"

ListView
{
    id: listView

    signal downloadSelected(double model_id)
    signal downloadUnselected()

    flickableDirection: Flickable.HorizontalAndVerticalFlick

    boundsBehavior: Flickable.StopAtBounds

    clip: true

    header: Rectangle
    {
        color: appWindow.theme.border
        width: parent.width
        height: 1
    }

    model: App.downloads.model
    //model: DownloadsViewTestModel {}

    delegate: Rectangle {
        id: downloadsViewItemWraper
        width: listView.width
        height: downloadsViewItem.height + itemDivider.height
//        height: downloadsViewItem.height + itemDivider.height
        color: "transparent"

        Rectangle
        {
            id: leftBorder
            anchors.left: parent.left
            width: appWindow.showBordersInDownloadsList ? parent.width * 0.1 : 0
            height: downloadsViewItemWraper.height
            color: "transparent"
        }

        DownloadsViewItem
        {
            id: downloadsViewItem

            view: downloadsViewItemWraper.ListView.view
            //width: listView.width
            anchors.left: leftBorder.right
            anchors.right: rightBorder.left

            onDownloadSelected: listView.downloadSelected(model_id)
            onDownloadUnselected: listView.downloadUnselected()
        }

        Rectangle
        {
            id: itemDivider
            color: appWindow.theme.border
            //width: listView.width
            anchors.left: leftBorder.right
            anchors.right: rightBorder.left
            anchors.top: downloadsViewItem.bottom
            height: 1
        }

        Rectangle
        {
            id: rightBorder
            anchors.right: parent.right
            width: appWindow.showBordersInDownloadsList ? parent.width * 0.1 : 0
            height: downloadsViewItemWraper.height
            color: "transparent"
        }
    }

    footer: Rectangle {
        width: listView.width
        height: 100
        color: appWindow.theme.background
    }

    ScrollIndicator.horizontal: ScrollIndicator { }
    ScrollIndicator.vertical: ScrollIndicator { }
}
