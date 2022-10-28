import QtQuick 2.10
import QtQuick.Controls 2.3
import "../BaseElements"
import "../../common"

Rectangle {
    id: root
    visible: downloadsViewTools.downloadsParentIdFilter > -1
    color: appWindow.theme.batchDownloadBackground
    width: batchDownloadTitle.width + 24*appWindow.zoom
    height: 27*appWindow.zoom
    border.width: 1*appWindow.zoom
    border.color: appWindow.theme.border
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.topMargin: 8*appWindow.zoom
    property int maxWidth: 250*appWindow.zoom
    signal visibilityChanged()

    onVisibleChanged: {
        if (visible) {
            updateBatchDownloadTitle();
        }
        visibilityChanged()
    }

    BaseLabel {
        id: batchDownloadTitle
        font.pixelSize: 12*appWindow.zoom
        anchors.verticalCenter: parent.verticalCenter
        elide: Label.ElideRight
        leftPadding: 8*appWindow.zoom
        font.weight: Font.DemiBold
    }

    FontMetrics {
        id: fmBatchDownloadTitle
        font: batchDownloadTitle.font
    }

    Rectangle {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        height: 24*appWindow.zoom
        width: 24*appWindow.zoom
        clip: true
        color: "transparent"

        WaSvgImage {
            source: appWindow.theme.elementsIcons
            zoom: appWindow.zoom
            x: 6*zoom
            y: -366*zoom
        }

        MouseArea {
            anchors.fill: parent
            onClicked: returnToDownloadList()
        }
    }

    function returnToDownloadList() {
        selectedDownloadsTools.selectDownloadItemById(
                    downloadsViewTools.downloadsParentIdFilter);
    }

    function updateBatchDownloadTitle() {
        batchDownloadTitle.text = downloadsViewTools.getParentDownloadTitle();
        batchDownloadTitle.width = Qt.binding(function() {
            return Math.min(
                        fmBatchDownloadTitle.advanceWidth(batchDownloadTitle.text) + batchDownloadTitle.leftPadding + 5,
                        maxWidth);
        });
    }
}
