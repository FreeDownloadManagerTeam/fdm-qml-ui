import QtQuick
import QtQuick.Window
import org.freedownloadmanager.fdm
import "../common"

Item
{
    readonly property var preview: App.downloads.previews.preview(model.id)
    readonly property url previewUrl: preview ? preview.small : null
    readonly property bool hasPreview : previewUrl && previewUrl.toString()

    implicitWidth: 25*appWindow.zoom
    implicitHeight: 25*appWindow.zoom

    //batch download icon
    WaSvgImage
    {
        visible: !hasPreview && model.hasChildDownloads
        opacity: downloadsItemTools.itemOpacity
        zoom: appWindow.zoom
        source: appWindow.theme.batch
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        fillMode: Image.PreserveAspectFit
    }

    //preview
    Image {
        visible: hasPreview
        opacity: downloadsItemTools.itemOpacity
        width: 25*appWindow.zoom
        height: 25*appWindow.zoom
        sourceSize.height: height*Screen.devicePixelRatio
        sourceSize.width: width*Screen.devicePixelRatio
        fillMode: Image.PreserveAspectFit
        horizontalAlignment: Image.AlignHCenter
        verticalAlignment: Image.AlignVCenter
        source: previewUrl
    }

    //default icon
    WaSvgImage {
        visible: !hasPreview && !model.hasChildDownloads
        opacity: downloadsItemTools.itemOpacity
        zoom: appWindow.zoom
        source: appWindow.theme.defaultFileIconSmall
        fillMode: Image.PreserveAspectFit
    }
}


