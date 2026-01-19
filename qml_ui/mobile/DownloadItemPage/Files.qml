import QtQuick
import org.freedownloadmanager.fdm
import "../FilesTree"

Rectangle {
    id: root
    property var downloadInfo
    property var downloadItemId
    anchors.fill: parent
    color: "transparent"

    Rectangle {
        anchors.fill: parent
        anchors.leftMargin: appWindow.showBordersInDownloadsList ? parent.width * 0.1 : 0
        anchors.rightMargin: appWindow.showBordersInDownloadsList ? parent.width * 0.1 : 0
        color: "transparent"

        border.color: appWindow.theme.border
        FilesTree {
            downloadItemId: root.downloadItemId
            downloadInfo: root.downloadInfo
        }
    }
}
