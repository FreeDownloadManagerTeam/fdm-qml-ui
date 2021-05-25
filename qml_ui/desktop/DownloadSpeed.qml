import QtQuick 2.12
import "./BaseElements"
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
        property int textBottomPadding: Qt.platform.os === "osx" ? 1 : 0
    }

    Image {
        visible: myDownloadsItemTools.showDownloadSpeed
        anchors.verticalCenter: parent.verticalCenter
        source: appWindow.theme.arrowDownListImg
        width: 7
        height: 7
        sourceSize: Qt.size(width, height)
        fillMode: Image.PreserveAspectFit
    }
    BaseLabel {
        id: labelDown
        visible: myDownloadsItemTools.showDownloadSpeed
        anchors.verticalCenter: parent.verticalCenter
        text: App.speedAsText(myDownloadsItemTools.downloadSpeed)
        font.pixelSize: appWindow.compactView ? 12 : 13
        leftPadding: 2
        bottomPadding: d.textBottomPadding
    }

    Rectangle
    {
        visible: myDownloadsItemTools.showDownloadSpeed && d.showUploadSpeed
        color: "transparent"
        width: 67 - labelDown.x - labelDown.width // make a "grid"
        height: parent.height
    }

    Image {
        visible: d.showUploadSpeed
        anchors.verticalCenter: parent.verticalCenter
        source: appWindow.theme.arrowUpListImg
        width: 7
        height: 7
        sourceSize: Qt.size(width, height)
        fillMode: Image.PreserveAspectFit
    }
    BaseLabel {
        visible: d.showUploadSpeed
        anchors.verticalCenter: parent.verticalCenter
        text: App.speedAsText(myDownloadsItemTools.uploadSpeed)
        font.pixelSize: appWindow.compactView ? 12 : 13
        leftPadding: 2
        bottomPadding: d.textBottomPadding
    }
}
