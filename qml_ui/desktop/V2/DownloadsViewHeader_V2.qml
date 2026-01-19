import QtQuick
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import "../BaseElements"
import "../BaseElements/V2"

Item
{
    readonly property bool batchDownload: downloadsViewTools.downloadsParentIdFilter > -1
    readonly property int batchDownloadIndent: batchDownload ? 32*appWindow.zoom : 0

    readonly property int numberColNameColSpacing: 8*appWindow.zoom
    readonly property int colSpacing: 16*appWindow.zoom

    readonly property int numColX: nCol.x + batchDownloadIndent
    readonly property int numColWidth: nCol.width

    readonly property int nameColX: nameCol.x + batchDownloadIndent
    readonly property int nameColWidth: nameCol.width - batchDownloadIndent

    readonly property alias sizeColX: sizeCol.x
    readonly property alias sizeColWidth: sizeCol.width

    readonly property alias statusColX: statusCol.x
    readonly property alias statusColWidth: statusCol.width

    readonly property alias dlColX: dlCol.x
    readonly property alias dlColWidth: dlCol.width

    readonly property alias uplColX: uplCol.x
    readonly property alias uplColWidth: uplCol.width

    readonly property alias addedColX: addedCol.x
    readonly property alias addedColWidth: addedCol.width

    FontMetrics {
        id: fm
        font: nCol.font
    }

    implicitWidth: meat.implicitWidth
    implicitHeight: meat.implicitHeight

    ColumnLayout
    {
        id: meat

        anchors.fill: parent

        spacing: 0

        RowLayout
        {
            Layout.fillWidth: true

            spacing: 0

            DownloadsViewHeaderItem_V2 {
                id: nCol
                text: "#"
                Layout.minimumWidth: 40*appWindow.zoom
                Layout.leftMargin: appWindow.theme_v2.mainWindowLeftMargin*appWindow.zoom
            }

            Item {
                Layout.preferredWidth: numberColNameColSpacing
            }

            DownloadsViewHeaderItem_V2 {
                id: nameCol
                text: qsTr("Name") + App.loc.emptyString
                Layout.fillWidth: true
                Layout.minimumWidth: 100*appWindow.fontZoom
            }

            Item {
                Layout.preferredWidth: colSpacing
            }

            DownloadsViewHeaderItem_V2 {
                id: sizeCol
                text: qsTr("Size") + App.loc.emptyString
                Layout.minimumWidth: 64*appWindow.fontZoom
            }

            Item {
                Layout.preferredWidth: colSpacing
            }

            DownloadsViewHeaderItem_V2 {
                id: statusCol
                text: qsTr("Status") + App.loc.emptyString
                Layout.minimumWidth: 161*appWindow.zoom
                Layout.preferredWidth: Layout.minimumWidth
            }

            Item {
                Layout.preferredWidth: colSpacing
            }

            DownloadsViewHeaderItem_V2 {
                id: dlCol
                text: qsTr("Download") + App.loc.emptyString
                Layout.minimumWidth: 80*appWindow.fontZoom
            }

            Item {
                Layout.preferredWidth: colSpacing
            }

            DownloadsViewHeaderItem_V2 {
                id: uplCol
                text: qsTr("Upload") + App.loc.emptyString
                Layout.minimumWidth: 80*appWindow.fontZoom
            }

            Item {
                Layout.preferredWidth: colSpacing
            }

            DownloadsViewHeaderItem_V2 {
                id: addedCol
                text: qsTr("Added") + App.loc.emptyString
                Layout.minimumWidth: fm.font.pixelSize*0 +
                                     Math.max(fm.advanceWidth(App.loc.dateTimeToString_v2_maxString(false, true) + App.loc.emptyString),
                                              fm.advanceWidth(qsTr("Remaining") + " 23h 59m" + App.loc.emptyString),
                                              fm.advanceWidth(qsTr("Stopped") + App.loc.emptyString),
                                              80*appWindow.fontZoom)
            }

            Item {
                Layout.preferredWidth: appWindow.theme_v2.mainWindowRightMargin*appWindow.zoom
            }
        }

        Item {
            visible: batchDownload

            implicitWidth: batchDownloadHdr.implicitWidth
            implicitHeight: batchDownloadHdr.implicitHeight

            Layout.fillWidth: true
            Layout.topMargin: 8*appWindow.zoom
            Layout.bottomMargin: Layout.topMargin

            /*Rectangle {
                id: batchDownloadGradient

                anchors.fill: parent


                property color baseColor: appWindow.theme_v2.isLightTheme ?
                                              appWindow.theme_v2.bg200 :
                                              Qt.lighter(appWindow.theme_v2.bg200, 1.2)

                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0.0; color: batchDownloadGradient.baseColor }  // Start color
                    GradientStop { position: 0.6; color: batchDownloadGradient.baseColor }  // 60% stop with solid color
                    GradientStop { position: 1.0; color: Qt.rgba(Qt.color(batchDownloadGradient.baseColor).r,
                                                                 Qt.color(batchDownloadGradient.baseColor).g,
                                                                 Qt.color(batchDownloadGradient.baseColor).b,
                                                                 appWindow.theme_v2.isLightTheme ? 0 : 0.5) }  // End color with transparency
                }
            }*/

            RowLayout {
                id: batchDownloadHdr

                anchors.fill: parent

                spacing: 8*appWindow.zoom

                SvgImage_V2 {
                    source: Qt.resolvedUrl("level_up.svg")
                    Layout.leftMargin: appWindow.theme_v2.mainWindowLeftMargin*appWindow.zoom
                    MouseAreaWithHand_V2 {
                        anchors.fill: parent
                        onClicked: selectedDownloadsTools.selectDownloadItemById(downloadsViewTools.downloadsParentIdFilter)
                    }
                }

                SvgImage_V2 {
                    source: Qt.resolvedUrl("batch_download_icon.svg")
                    imageColor: appWindow.theme_v2.primary
                }

                BaseLabel {
                    elide: BaseLabel.ElideMiddle
                    Component.onCompleted: text = downloadsViewTools.getParentDownloadTitle()
                    Layout.fillWidth: true
                }

                Item {
                    Layout.preferredWidth: appWindow.theme_v2.mainWindowRightMargin*appWindow.zoom
                }
            }
        }
    }
}

