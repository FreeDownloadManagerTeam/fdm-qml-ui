import QtQuick 2.12
import "./BaseElements"
import "../common"
import org.freedownloadmanager.fdm 1.0

Row
{
    property var myDownloadsItemTools

    QtObject
    {
        id: d

        property bool showUploadSpeed: myDownloadsItemTools.showUploadSpeed &&
                                       (myDownloadsItemTools.finished || myDownloadsItemTools.uploadSpeed > 0)

        // Workaround: attempt to achieve a correctly centered vertical position under macOS
        property int textBottomPadding: Qt.platform.os === "osx" ? 1*appWindow.zoom : 0
    }

    WaSvgImage {
        visible: myDownloadsItemTools.showDownloadSpeed
        anchors.verticalCenter: parent.verticalCenter
        source: appWindow.theme.arrowDownListImg
        zoom: appWindow.zoom
        fillMode: Image.PreserveAspectFit
    }
    BaseLabel {
        id: labelDown
        visible: myDownloadsItemTools.showDownloadSpeed
        anchors.verticalCenter: parent.verticalCenter
        text: App.speedAsText(myDownloadsItemTools.downloadSpeed) + App.loc.emptyString
        font.pixelSize: (appWindow.compactView ? 12 : 13)*appWindow.fontZoom
        leftPadding: 2*appWindow.zoom
        bottomPadding: d.textBottomPadding
    }

    Rectangle
    {
        visible: myDownloadsItemTools.showDownloadSpeed && d.showUploadSpeed
        color: "transparent"
        width: 15*appWindow.zoom+52*appWindow.fontZoom - labelDown.x - labelDown.width // make a "grid"
        height: parent.height
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
        leftPadding: 2*appWindow.zoom
        bottomPadding: d.textBottomPadding
    }
}
