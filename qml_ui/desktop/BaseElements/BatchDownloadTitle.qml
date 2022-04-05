import QtQuick 2.10
import QtQuick.Controls 2.3
import "../BaseElements"

Rectangle {
    id: root
    visible: downloadsViewTools.downloadsParentIdFilter > -1
    color: appWindow.theme.batchDownloadBackground
    width: batchDownloadTitle.width + 24
    height: 27
    border.width: 1
    border.color: appWindow.theme.border
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.topMargin: 8
    property int maxWidth: 250
    signal visibilityChanged()

    onVisibleChanged: {
        if (visible) {
            updateBatchDownloadTitle();
        }
        visibilityChanged()
    }

    BaseLabel {
        id: batchDownloadTitle
        font.pixelSize: 12
        anchors.verticalCenter: parent.verticalCenter
        elide: Label.ElideRight
        leftPadding: 8
        font.weight: Font.DemiBold
    }

    FontMetrics {
        id: fmBatchDownloadTitle
        font: batchDownloadTitle.font
    }

    Rectangle {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        height: 24
        width: 24
        clip: true
        color: "transparent"

        Image {
            source: appWindow.theme.elementsIcons
            x: 6
            y: -366
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
