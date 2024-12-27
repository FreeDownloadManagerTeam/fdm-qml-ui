import QtQuick
import "../BaseElements/V2"

Item
{
    implicitWidth: p.visible ? p.implicitWidth : e.implicitWidth
    implicitHeight: p.visible ? p.implicitHeight : e.implicitHeight

    DownloadProgressBar_V2
    {
        id: p
        visible: !downloadsItemTools.inError
        anchors.centerIn: parent
        width: parent.width
    }

    Error_V2
    {
        id: e
        visible: downloadsItemTools.inError
        error: downloadsItemTools.error
        anchors.centerIn: parent
        width: parent.width
    }
}
