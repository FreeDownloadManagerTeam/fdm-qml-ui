import QtQuick 2.10
import QtQuick.Controls 2.3
import "../../qt5compat"
import org.freedownloadmanager.fdm 1.0

Rectangle {
    width: 46
    height: 46
    color: "transparent"
    property bool locked: false
    property double itemOpacity: 1

    readonly property var preview: App.downloads.previews.preview(downloadsItemTools.itemId)
    readonly property url previewUrl: preview ? preview.large : null
    readonly property bool hasPreview : previewUrl && previewUrl.toString()

    Image {
        id: fileIcon
        width: parent.width
        height: parent.height
        source: previewUrl
        opacity: itemOpacity
        fillMode: Image.PreserveAspectCrop//Image.PreserveAspectFit
        anchors.margins: 0
        visible: hasPreview
        layer {
            effect: ColorOverlay {
                color: appWindow.theme.previewOverlay
            }
            enabled: true
        }
    }

    Rectangle {
        anchors.fill: parent
        color: appWindow.theme.toolbarBackground
        visible: !fileIcon.visible && !downloadsItemTools.isFolder && downloadsItemTools.singleFileSuffix && downloadsItemTools.singleFileSuffix.length <= 4
        clip: true
        opacity: itemOpacity

        Label {
            text: downloadsItemTools.singleFileSuffix
            font.capitalization: Font.AllUppercase
            font.pixelSize: 13
            font.weight: Font.DemiBold
            anchors.top: parent.top
            anchors.topMargin: 8
            anchors.horizontalCenter: parent.horizontalCenter
            color: appWindow.theme.toolbarTextColor
        }
    }

    Image {
        id: img1
        width: parent.width
        height: parent.height
        visible: !fileIcon.visible && !downloadsItemTools.isFolder && (!downloadsItemTools.singleFileSuffix || downloadsItemTools.singleFileSuffix.length > 4)
        opacity: itemOpacity
        anchors.centerIn: parent
        source: Qt.resolvedUrl("../../images/mobile/unknown_extension.svg")
        sourceSize.width: 45
        sourceSize.height: 45
        fillMode: Image.PreserveAspectFit
        layer {
            effect: ColorOverlay {
                color: appWindow.theme.toolbarBackground
            }
            enabled: true
        }
    }

    Image {
        id: img2
        width: parent.width
        height: parent.height
        visible: !fileIcon.visible && downloadsItemTools.isFolder
        opacity: itemOpacity
        anchors.centerIn: parent
        source: Qt.resolvedUrl("../../images/mobile/folder.svg")
        sourceSize.width: 45
        sourceSize.height: 45
        fillMode: Image.PreserveAspectFit
        layer {
            effect: ColorOverlay {
                color: appWindow.theme.toolbarBackground
            }
            enabled: true
        }
    }
}
