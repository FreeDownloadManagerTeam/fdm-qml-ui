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

        width: parent.width
        y: 16*appWindow.zoom

        spacing: 16*appWindow.zoom

        Item
        {
            Layout.alignment: Qt.AlignTop
            Layout.preferredWidth: 104*appWindow.zoom
            Layout.preferredHeight: 128*appWindow.zoom
            Layout.leftMargin: appWindow.theme_v2.mainWindowLeftMargin*appWindow.zoom

            WaSvgImage
            {
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.leftMargin: 3*appWindow.zoom
                anchors.bottomMargin: 6*appWindow.zoom
                zoom: appWindow.zoom
                source: Qt.resolvedUrl("folder.svg")
            }
        }

        ColumnLayout
        {
            Layout.alignment: Qt.AlignTop
            Layout.fillWidth: true
            Layout.rightMargin: appWindow.theme_v2.mainWindowRightMargin*appWindow.zoom
            spacing: 0

            ElidedTextWithTooltip_V2 {
                sourceText: downloadsItemTools.tplTitle
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
                Layout.fillWidth: true
                Layout.maximumWidth: 524*appWindow.zoom
            }

            Item {implicitHeight: 11*appWindow.zoom; implicitWidth: 1}

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
                                  App.loc.dateTimeToString_v2(downloadsItemTools.added, true) + App.loc.emptyString :
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
            }

            Item {implicitHeight: 7*appWindow.zoom; implicitWidth: 1}

            RowLayout {
                visible: downloadsItemTools.webPageUrl.toString()
                Layout.fillWidth: true
                spacing: 8*appWindow.zoom
                BaseText_V2 {
                    text: qsTr("Web page") + ':' + App.loc.emptyString
                    color: appWindow.theme_v2.bg700
                }
                BaseText_V2 {
                    text: "<a href='#'>" + downloadsItemTools.webPageUrl + "</a>"
                    linkColor: appWindow.theme_v2.primary
                    onLinkActivated: App.openDownloadUrl(downloadsItemTools.webPageUrl)
                    Layout.fillWidth: true
                    elide: Text.ElideMiddle
                    MouseAreaWithHand_V2 {
                        anchors.fill: parent
                        acceptedButtons: Qt.RightButton
                        onClicked: (mouse) => parent.showMenu(parent, mouse, downloadsItemTools.webPageUrl)
                    }
                    function showMenu(anchor, mouse, url)
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
        }
    }
}

