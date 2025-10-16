import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import org.freedownloadmanager.fdm
import "../../../common"
import "../../BaseElements"
import "../../BaseElements/V2"
import ".."

Flickable
{
    clip: true
    readonly property bool hasVerticalScrollbar: contentHeight > height
    flickableDirection: Flickable.VerticalFlick
    ScrollBar.vertical: BaseScrollBar_V2 {
        policy: parent.hasVerticalScrollbar ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
    }
    boundsBehavior: Flickable.StopAtBounds
    contentHeight: meat.y + meat.height

    RowLayout
    {
        id: meat

        visible: __bugwaCounter === 0

        width: parent.width
        y: 16*appWindow.zoom

        spacing: 16*appWindow.zoom

        Item
        {
            id: imageHolder

            readonly property var preview: App.downloads.previews.preview(selectedDownloadsTools.currentDownloadId)
            readonly property var previewUrl: preview && !preview.usingFileIconPreview ? preview.large : null
            readonly property bool hasPreview: previewUrl && previewUrl.toString()
            readonly property int supposedWidth: 104*appWindow.zoom
            readonly property int supposedHeight: 128*appWindow.zoom

            Layout.alignment: Qt.AlignTop
            Layout.preferredWidth: hasPreview ?
                                       previewHolder.recommendedWidth(supposedWidth, supposedHeight) :
                                       supposedWidth
            Layout.preferredHeight: hasPreview ?
                                        previewHolder.recommendedHeight(supposedWidth, supposedHeight) :
                                        supposedHeight
            Layout.leftMargin: appWindow.theme_v2.mainWindowLeftMargin*appWindow.zoom

            WaSvgImage
            {
                visible: !parent.hasPreview
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.leftMargin: 3*appWindow.zoom
                anchors.bottomMargin: 6*appWindow.zoom
                zoom: appWindow.zoom
                source: parent.hasPreview ? "" : Qt.resolvedUrl(Qt.platform.os === "osx" ? "folder_mac.svg" : "folder.svg")
            }

            Item
            {
                id: previewHolder
                visible: parent.hasPreview

                readonly property int minimumHeight: 68*appWindow.zoom

                function recommendedWidth(supposedWidth, supposedHeight)
                {
                    return previewImg.isHorizontal ?
                                Math.max(supposedWidth, minimumHeight * previewImg.ratio) :
                                supposedHeight * previewImg.ratio;
                }

                function recommendedHeight(supposedWidth, supposedHeight)
                {
                    return previewImg.isHorizontal ?
                                Math.max(minimumHeight, supposedWidth / previewImg.ratio) :
                                supposedHeight;
                }

                anchors.top: parent.top
                anchors.topMargin: 10*appWindow.zoom

                height: recommendedHeight(parent.width, parent.height)
                width: recommendedWidth(parent.width, parent.height)

                Image
                {
                    id: previewImg
                    readonly property real ratio: sourceSize.height ? sourceSize.width / sourceSize.height : 0
                    readonly property bool isHorizontal: ratio > 1
                    source: imageHolder.hasPreview ? imageHolder.previewUrl : ""
                    anchors.fill: parent
                    layer.enabled: true
                    layer.effect: OpacityMask {
                        maskSource: Rectangle {
                            width: previewImg.width
                            height: previewImg.height
                            radius: 4*appWindow.zoom
                        }
                    }
                }
            }

            MouseAreaWithHand_V2 {
                visible: !App.rc.client.active && downloadsItemTools.finished
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: App.downloads.mgr.openDownload(downloadsItemTools.itemId, -1)
            }
        }

        ColumnLayout
        {
            Layout.alignment: Qt.AlignTop
            Layout.fillWidth: true
            Layout.rightMargin: appWindow.theme_v2.mainWindowRightMargin*appWindow.zoom
            spacing: 0

            ElidedTextWithTooltip_V2 {
                sourceText: downloadsItemTools.title
                Layout.fillWidth: true
                Layout.topMargin: 6*appWindow.zoom
                font.pixelSize: 16*appWindow.fontZoom
            }

            Item {implicitHeight: 7*appWindow.zoom; implicitWidth: 1}

            RowLayout
            {
                visible: downloadsItemTools.destinationPath
                spacing: 8*appWindow.zoom

                ElidedTextWithTooltip_V2 {
                    id: dstPathText
                    sourceText: App.toNativeSeparators(downloadsItemTools.destinationPath)
                    color: appWindow.theme_v2.bg700
                    Layout.maximumWidth: sourceTextWidth
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignLeft
                }

                WaSvgImage
                {
                    zoom: appWindow.zoom
                    source: Qt.resolvedUrl("content_copy.svg")
                    layer {
                        enabled: true
                        effect: ColorOverlay {color: dstPathText.color}
                    }
                    Layout.alignment: Qt.AlignLeft
                    MouseAreaWithHand_V2 {
                        anchors.fill: parent
                        onClicked: App.clipboard.text = dstPathText.sourceText
                    }
                }
            }

            Item {implicitHeight: 11*appWindow.zoom; implicitWidth: 1}

            DownloadStatus_V2
            {
                id: statusItem
                visible: !absolutelyFinished
                Layout.fillWidth: true
            }

            Item {visible: statusItem.visible; implicitHeight: 11*appWindow.zoom; implicitWidth: 1}

            GridLayout
            {
                columns: Math.max(1, Math.min(3, parent.width / 250 / appWindow.fontZoom))
                columnSpacing: 32*appWindow.zoom
                rowSpacing: 7*appWindow.zoom

                RowLayout {
                    spacing: 8*appWindow.zoom
                    BaseText_V2 {
                        text: qsTr("Downloaded:") + App.loc.emptyString
                        color: appWindow.theme_v2.bg700
                    }
                    BaseText_V2 {
                        text: (downloadsItemTools.finished || downloadsItemTools.unknownFileSize ?
                                   App.bytesAsText(downloadsItemTools.selectedBytesDownloaded) :
                                   "%1 / %2".arg(App.bytesAsText(downloadsItemTools.selectedBytesDownloaded)).arg(App.bytesAsText(downloadsItemTools.selectedSize))
                               ) + App.loc.emptyString
                    }
                }

                RowLayout {
                    visible: downloadsItemTools.canUpload
                    spacing: 8*appWindow.zoom
                    BaseText_V2 {
                        text: qsTr("Uploaded") + ':' + App.loc.emptyString
                        color: appWindow.theme_v2.bg700
                    }
                    BaseText_V2 {
                        text: App.bytesAsText(downloadsItemTools.bytesUploaded) +
                              " (" + qsTr("ratio") + ": " + downloadsItemTools.ratioText + ")" +
                              App.loc.emptyString
                    }
                }

                RowLayout {
                    spacing: 8*appWindow.zoom
                    BaseText_V2 {
                        text: qsTr("Added at:") + App.loc.emptyString
                        color: appWindow.theme_v2.bg700
                    }
                    BaseText_V2 {
                        text: downloadsItemTools.added ?
                                  App.loc.dateTimeToString_v2(downloadsItemTools.added, true, true) + App.loc.emptyString :
                                  ""
                    }
                }

                RowLayout {
                    visible: downloadsItemTools.showDownloadSpeed
                    spacing: 8*appWindow.zoom
                    BaseText_V2 {
                        text: qsTr("Download speed:") + App.loc.emptyString
                        color: appWindow.theme_v2.bg700
                    }
                    BaseText_V2 {
                        text: App.speedAsText(downloadsItemTools.downloadSpeed) + App.loc.emptyString
                    }
                }

                RowLayout {
                    visible: downloadsItemTools.showUploadSpeed
                    spacing: 8*appWindow.zoom
                    BaseText_V2 {
                        text: qsTr("Upload speed:") + App.loc.emptyString
                        color: appWindow.theme_v2.bg700
                    }
                    BaseText_V2 {
                        text: App.speedAsText(downloadsItemTools.uploadSpeed) + App.loc.emptyString
                    }
                }

                RowLayout {
                    spacing: 8*appWindow.zoom
                    BaseText_V2 {
                        text: qsTr("Priority") + ':' + App.loc.emptyString
                        color: appWindow.theme_v2.bg700
                    }
                    BaseText_V2 {
                        text: uicore.priorityText(downloadsItemTools.item.priority) + App.loc.emptyString
                        font.capitalization: Font.AllLowercase
                        color: downloadsItemTools.running ?
                                   uicore.priorityAndSnailColor(downloadsItemTools.item.priority) :
                                   uicore.priorityColor(downloadsItemTools.item.priority)
                    }
                }
            }

            component UrlField : RowLayout {
                property string url
                property string title
                visible: url
                Layout.fillWidth: true
                spacing: 8*appWindow.zoom
                BaseText_V2 {
                    text: title + ':'
                    color: appWindow.theme_v2.bg700
                }
                BaseText_V2 {
                    text: "<a href='#'>" + url + "</a>"
                    linkColor: appWindow.theme_v2.primary
                    onLinkActivated: App.openDownloadUrl(url)
                    Layout.fillWidth: true
                    elide: Text.ElideMiddle
                    MouseAreaWithHand_V2 {
                        anchors.fill: parent
                        acceptedButtons: Qt.RightButton
                        onClicked: (mouse) => parent.showMenu(parent, mouse)
                    }
                    function showMenu(anchor, mouse)
                    {
                        var component = Qt.createComponent(Qt.resolvedUrl("../../BottomPanel/CopyLinkMenu.qml"));
                        var menu = component.createObject(anchor, {
                                                              "url": url
                                                          });
                        menu.x = Math.round(mouse.x);
                        menu.y = Math.round(mouse.y);
                        menu.open();
                        menu.aboutToHide.connect(function(){
                            menu.destroy();
                        });
                    }
                }
            }

            Item {visible: webPageUrlField.visible; implicitHeight: 7*appWindow.zoom; implicitWidth: 1}

            UrlField {
                id: webPageUrlField
                title: qsTr("Web page") + App.loc.emptyString
                url: downloadsItemTools.webPageUrl
            }

            Item {visible: fileUrlField.visible; implicitHeight: 7*appWindow.zoom; implicitWidth: 1}

            UrlField {
                id: fileUrlField
                title: qsTr("File") + App.loc.emptyString
                url: downloadsItemTools.resourceUrl
            }
        }
    }

    ////////////////////////////////////////////////////////////////////////////////////
    // Qt 6.4.3 Layouts bug workaround
    // TODO: remove it when switched to Qt 6.8.2+
    property int __bugwaCounter: 0
    property int __bugwaCounter2: App.qtVersion() === "6.4.3" ? 0 : 1
    Timer {
        id: bugwa
        interval: 100
        repeat: true
        onTriggered: {
           __bugwaCounter = __bugwaCounter ? 0 : 1;
            if (++__bugwaCounter2 * interval / 1000.0 >= 0.3)
            {
                stop();
                __bugwaCounter = 0;
            }
        }
    }
    Connections {
        target: downloadsItemTools
        onItemIdChanged: doWorkaround()
    }
    Component.onCompleted: doWorkaround()
    function doWorkaround() {
        if (visible && !__bugwaCounter2)
            bugwa.start();
    }
    ////////////////////////////////////////////////////////////////////////////////////
}

