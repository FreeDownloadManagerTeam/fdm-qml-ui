import QtQuick 2.10
import QtQuick.Window 2.12
import org.freedownloadmanager.fdm 1.0

Item
{
    readonly property var preview: App.downloads.previews.preview(model.id)
    readonly property url previewUrl: preview ? preview.small : null
    readonly property bool hasPreview : previewUrl && previewUrl.toString()

    implicitWidth: 25
    implicitHeight: 25

    //batch download icon
    Image
    {
        visible: !hasPreview && model.hasChildDownloads
        opacity: downloadsItemTools.itemOpacity
        width: 19
        height: 19
        sourceSize: Qt.size(width, height)
        source: appWindow.theme.batch
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        fillMode: Image.PreserveAspectFit
    }

    //preview
    Image {
        visible: hasPreview
        opacity: downloadsItemTools.itemOpacity
        width: 25
        height: 25
        sourceSize.height: height*Screen.devicePixelRatio
        sourceSize.width: width*Screen.devicePixelRatio
        fillMode: Image.PreserveAspectFit
        horizontalAlignment: Image.AlignHCenter
        verticalAlignment: Image.AlignVCenter
        source: previewUrl
    }

    //default icon
    Image {
        visible: !hasPreview && !model.hasChildDownloads
        opacity: downloadsItemTools.itemOpacity
        width: 25
        height: 25
        sourceSize: Qt.size(width, height)
        source: appWindow.theme.defaultFileIconSmall
        fillMode: Image.PreserveAspectFit
    }
}


