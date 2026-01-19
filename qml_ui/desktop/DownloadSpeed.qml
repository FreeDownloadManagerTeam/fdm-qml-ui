import QtQuick
import "./BaseElements"
import "../common"
import org.freedownloadmanager.fdm

Row
{
    property var myDownloadsItemTools

    property color textColor: appWindow.theme.foreground

    QtObject
    {
        id: d

        property bool showUploadSpeed: myDownloadsItemTools.showUploadSpeed &&
                                       (myDownloadsItemTools.finished || myDownloadsItemTools.uploadSpeed > 0)

        // Workaround: attempt to achieve a correctly centered vertical position under macOS
        property int textBottomPadding: Qt.platform.os === "osx" ? 1*appWindow.zoom : 0
    }

    Item
    {
        visible: myDownloadsItemTools.showDownloadSpeed

        implicitWidth: 10*appWindow.zoom+62*appWindow.fontZoom
        implicitHeight: downSpeedRow.implicitHeight

        anchors.verticalCenter: parent.verticalCenter

        Row
        {
            id: downSpeedRow

            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter

            WaSvgImage {
                anchors.verticalCenter: parent.verticalCenter
                source: appWindow.theme.arrowDownListImg
                zoom: appWindow.zoom
                fillMode: Image.PreserveAspectFit
            }
            BaseLabel {
                id: labelDown
                anchors.verticalCenter: parent.verticalCenter
                text: App.speedAsText(myDownloadsItemTools.downloadSpeed) + App.loc.emptyString
                font.pixelSize: (appWindow.compactView ? 12 : 13)*appWindow.fontZoom
                leftPadding: qtbug.leftPadding(2*appWindow.zoom,0)
                rightPadding: qtbug.rightPadding(2*appWindow.zoom,0)
                bottomPadding: d.textBottomPadding
                color: textColor
            }
        }
    }

    WaSvgImage {
        visible: d.showUploadSpeed
        anchors.verticalCenter: parent.verticalCenter
        source: appWindow.theme.arrowUpListImg
        zoom: appWindow.zoom
        fillMode: Image.PreserveAspectFit
    }
    BaseLabel {
        visible: d.showUploadSpeed
        anchors.verticalCenter: parent.verticalCenter
        text: App.speedAsText(myDownloadsItemTools.uploadSpeed) + App.loc.emptyString
        font.pixelSize: (appWindow.compactView ? 12 : 13)*appWindow.fontZoom
        leftPadding: qtbug.leftPadding(2*appWindow.zoom,0)
        rightPadding: qtbug.rightPadding(2*appWindow.zoom,0)
        bottomPadding: d.textBottomPadding
        color: textColor
    }
}
