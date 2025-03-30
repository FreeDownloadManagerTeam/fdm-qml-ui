import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import ".."
import "../../../common"

Rectangle
{
    id: root

    implicitWidth: meat.implicitWidth + meat.anchors.leftMargin + meat.anchors.rightMargin
    implicitHeight: meat.implicitHeight + meat.anchors.topMargin + meat.anchors.bottomMargin

    color: appWindow.theme_v2.bg400
    radius: 8*appWindow.zoom

    RowLayout
    {
        id: meat

        anchors.fill: parent
        anchors.leftMargin: 12*appWindow.zoom
        anchors.rightMargin: anchors.leftMargin
        anchors.topMargin: 4*appWindow.zoom
        anchors.bottomMargin: anchors.topMargin

        spacing: 8*appWindow.zoom

        SvgImage_V2
        {
            source: Qt.resolvedUrl("folder_open.svg")
            zoom: appWindow.zoom
        }

        BaseLabel
        {
            elide: Label.ElideMiddle
            Component.onCompleted: text = downloadsViewTools.getParentDownloadTitle()
        }

        SvgImage_V2
        {
            source: Qt.resolvedUrl("close.svg")
            zoom: appWindow.zoom

            MouseAreaWithHand_V2 {
                anchors.fill: parent
                onClicked: selectedDownloadsTools.selectDownloadItemById(downloadsViewTools.downloadsParentIdFilter)
            }
        }
    }
}
