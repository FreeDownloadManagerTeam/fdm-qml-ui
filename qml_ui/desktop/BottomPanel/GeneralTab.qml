import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.appfeatures
import "../../common/Tools"
import "../BaseElements"
import "../../common"
import "../"

Flickable {
    id: flickable

    anchors.fill: parent

    property int bottomPanelHeight
    property bool hasVerticalScrollbar: contentHeight > height

    clip: true

    flickableDirection: Flickable.VerticalFlick
    ScrollBar.vertical: ScrollBar {
        policy: flickable.hasVerticalScrollbar ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
    }
    boundsBehavior: Flickable.StopAtBounds

    contentHeight: myContent.height

    MouseArea {
        anchors.fill: parent
        onClicked: forceActiveFocus()
    }

    Column
    {
        id: myContent

        width: parent.width

        spacing: 0

        Rectangle {id: topSpacingRect; height: 20; width: 1; color: "transparent"}

        Row {
            id: myContent2

            x: 10*appWindow.zoom
            width: parent.width - x*2

            spacing: 20*appWindow.zoom

            Image {
                id: img
                readonly property var preview: App.downloads.previews.preview(selectedDownloadsTools.currentDownloadId)
                readonly property var previewUrl: preview ? preview.large : null
                source: previewUrl.toString() ? previewUrl : (downloadsItemTools.hasChildDownloads ? appWindow.theme.batchDownloadIcon : appWindow.theme.defaultFileIcon)
                fillMode: Image.PreserveAspectFit
                height: Math.min(sourceSize.height, bottomPanelHeight, Math.floor(sourceSize.height * Math.min(sourceSize.width, parent.width * 0.3) / sourceSize.width))

                MouseArea {
                    visible: !App.rc.client.active && downloadsItemTools.finished
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: App.downloads.mgr.openDownload(downloadsItemTools.itemId, -1)
                }
            }

            Column {
                id: topColumn
                width: parent.width - img.width - parent.spacing - (flickable.hasVerticalScrollbar ? 13 : 0)

                clip: true

                spacing: 8*appWindow.zoom

                Flow {
                    id: flow
                    spacing: 5*appWindow.zoom
                    width: parent.width

                    BaseSelectableLabel {
                        text: downloadsItemTools.title
                        font.pixelSize: (appWindow.smallWindow ? 15 : 18)*appWindow.fontZoom
                        width: parent.width
                    }

                    Repeater {
                        model: downloadsItemTools.allTags

                        delegate: TagLabel{
                            tag: modelData
                            downloadId: downloadsItemTools.itemId
                        }
                    }
                }

                StatusItem
                {
                    id: statusItem
                    width: parent.width
                    visible: !showingCompletedState
                }

                GridLayout
                {
                    readonly property int horizSpacing: 30*appWindow.zoom

                    anchors.left: parent.left
                    anchors.leftMargin: -horizSpacing

                    columns: (parent.width > (300+200*appWindow.fontZoom)) ? 4 : 2
                    rowSpacing: topColumn.spacing

                    BaseLabel {
                        visible: downloadsItemTools.finished
                        font.pixelSize: appWindow.fonts.defaultSize
                        color: appWindow.theme.generalTabKey
                        text: qsTr("Status") + ':' + App.loc.emptyString
                        leftPadding: qtbug.leftPadding(parent.horizSpacing, 0)
                        rightPadding: qtbug.rightPadding(parent.horizSpacing, 0)
                    }
                    BaseLabel {
                        visible: downloadsItemTools.finished
                        font.pixelSize: appWindow.fonts.defaultSize
                        color: appWindow.theme.generalTabValue
                        text: qsTr("completed") + App.loc.emptyString
                    }

                    BaseLabel {
                        visible: downloadsItemTools.state.length > 0
                        font.pixelSize: appWindow.fonts.defaultSize
                        color: appWindow.theme.generalTabKey
                        text: qsTr("State") + ':' + App.loc.emptyString
                        leftPadding: qtbug.leftPadding(parent.horizSpacing, 0)
                        rightPadding: qtbug.rightPadding(parent.horizSpacing, 0)
                    }
                    BaseLabel {
                        visible: downloadsItemTools.state.length > 0
                        font.pixelSize: appWindow.fonts.defaultSize
                        color: appWindow.theme.generalTabValue
                        text: downloadsItemTools.state
                    }

                    readonly property bool showSpeed: downloadsItemTools.showDownloadSpeed || downloadsItemTools.showUploadSpeed
                    BaseLabel {
                        visible: parent.showSpeed
                        font.pixelSize: appWindow.fonts.defaultSize
                        color: appWindow.theme.generalTabKey
                        text: qsTr("Speed") + ':' + App.loc.emptyString
                        leftPadding: qtbug.leftPadding(parent.horizSpacing, 0)
                        rightPadding: qtbug.rightPadding(parent.horizSpacing, 0)
                    }
                    DownloadSpeed {
                        visible: parent.showSpeed
                        myDownloadsItemTools: downloadsItemTools
                        textColor: appWindow.theme.generalTabKey
                    }

                    BaseLabel {
                        font.pixelSize: appWindow.fonts.defaultSize
                        color: appWindow.theme.generalTabKey
                        text: (downloadsItemTools.finished ? qsTr("Total size:") : qsTr("Downloaded:")) + App.loc.emptyString
                        leftPadding: qtbug.leftPadding(parent.horizSpacing, 0)
                        rightPadding: qtbug.rightPadding(parent.horizSpacing, 0)
                    }
                    BaseLabel {
                        font.pixelSize: appWindow.fonts.defaultSize
                        color: appWindow.theme.generalTabValue
                        text: (downloadsItemTools.finished || downloadsItemTools.unknownFileSize ? App.bytesAsText(downloadsItemTools.selectedBytesDownloaded) :
                                                                                                  qsTr("%1 of %2").arg(App.bytesAsText(downloadsItemTools.selectedBytesDownloaded)).arg(App.bytesAsText(downloadsItemTools.selectedSize))) + App.loc.emptyString
                    }

                    BaseLabel {
                        visible: downloadsItemTools.canUpload
                        font.pixelSize: appWindow.fonts.defaultSize
                        color: appWindow.theme.generalTabKey
                        text: qsTr("Uploaded") + ':' + App.loc.emptyString
                        leftPadding: qtbug.leftPadding(parent.horizSpacing, 0)
                        rightPadding: qtbug.rightPadding(parent.horizSpacing, 0)
                    }
                    BaseLabel {
                        visible: downloadsItemTools.canUpload
                        font.pixelSize: appWindow.fonts.defaultSize
                        color: appWindow.theme.generalTabValue
                        text: App.bytesAsText(downloadsItemTools.bytesUploaded) +
                              " (" + qsTr("ratio") + ": " + downloadsItemTools.ratioText + ")" +
                              App.loc.emptyString
                    }

                    BaseLabel {
                        visible: downloadsItemTools.added
                        font.pixelSize: appWindow.fonts.defaultSize
                        color: appWindow.theme.generalTabKey
                        text: qsTr("Added at:") + App.loc.emptyString
                        leftPadding: qtbug.leftPadding(parent.horizSpacing, 0)
                        rightPadding: qtbug.rightPadding(parent.horizSpacing, 0)
                    }
                    BaseLabel {
                        visible: downloadsItemTools.added
                        font.pixelSize: appWindow.fonts.defaultSize
                        color: appWindow.theme.generalTabValue
                        text: downloadsItemTools.added ?
                                  App.loc.dateOrTimeToString(downloadsItemTools.added, false) + App.loc.emptyString :
                                  ""
                        MouseArea {
                            propagateComposedEvents: true
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked : function (mouse) {mouse.accepted = false;}
                            onPressed: function (mouse) {mouse.accepted = false;}
                            BaseToolTip {
                                text: downloadsItemTools.added ?
                                          App.loc.dateTimeToString(downloadsItemTools.added, true) + App.loc.emptyString :
                                          ""
                                visible: parent.containsMouse
                            }
                        }
                    }
                }

                Row {
                    visible: downloadsItemTools.destinationPath
                    width: parent.width

                    Item {
                        width: 14*appWindow.zoom
                        height: 18*appWindow.zoom
                        anchors.verticalCenter: parent.verticalCenter
                        WaSvgImage {
                            source: appWindow.theme.elementsIconsRoot + "/folder.svg"
                            zoom: appWindow.zoom
                            anchors.centerIn: parent
                        }
                        MouseArea {
                            anchors.fill: parent
                            visible: App.features.hasFeature(AppFeatures.OpenFolder) && !App.rc.client.active
                            cursorShape: Qt.PointingHandCursor
                            onClicked: App.downloads.mgr.openDownloadFolder(downloadsItemTools.itemId, -1)
                        }
                    }

                    Item {
                        width: 2*appWindow.zoom
                        height: 1
                    }

                    BaseSelectableLabel {
                        font.pixelSize: appWindow.fonts.defaultSize
                        color: appWindow.theme.generalTabValue
                        Layout.fillWidth: true
                        width: parent.width - 18
                        wrapMode: Text.WrapAnywhere
                        text: App.toNativeSeparators(downloadsItemTools.destinationPath)
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                LinkWithIcon {
                    id: webPageLinkWithIcon
                    visible: downloadsItemTools.needToShowWebPageUrl
                    width: parent.width
                    title: qsTr("Web page") + App.loc.emptyString
                    url: downloadsItemTools.webPageUrl
                    downloadModuleUid: downloadsItemTools.moduleUid
                    titleColor: appWindow.theme.generalTabValue
                }

                LinkWithIcon {
                    visible: downloadsItemTools.needToShowResourceUrl
                    width: parent.width
                    title: qsTr("File") + App.loc.emptyString
                    url: downloadsItemTools.resourceUrl
                    downloadModuleUid: downloadsItemTools.moduleUid
                    titleColor: appWindow.theme.generalTabValue
                }
            }
        }

        Item {
            visible: flickable.height < (topSpacingRect.height + myContent2.height)
            height: topSpacingRect.height
            width: 1
        }
    }
}
