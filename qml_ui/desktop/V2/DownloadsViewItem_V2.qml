import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import org.freedownloadmanager.fdm 1.0
import "../BaseElements/V2"
import "../../common/Tools"
import "../../common"

Item
{
    property var downloadsViewHeader
    property bool noActionsAllowed: false

    readonly property int myVerticalPadding: 8*appWindow.zoom
    readonly property bool containsMouse: ma.containsMouse || ma2.containsMouse || nameText.containsMouse

    implicitWidth: childrenRect.width

    implicitHeight: myVerticalPadding*2 - 1 +
                    Math.max(numCol.implicitHeight, nameCol.implicitHeight, statusCol.implicitHeight)

    component MyCell : RowLayout
    {
        y: myVerticalPadding
        height: parent.height - myVerticalPadding*2
    }

    component HighlightedItem : Rectangle
    {
        property color baseColor: appWindow.theme_v2.isLightTheme ?
                                 appWindow.theme_v2.bg200 :
                                 Qt.lighter(appWindow.theme_v2.bg200, 1.2)

        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: baseColor }  // Start color
            GradientStop { position: 0.6; color: baseColor }  // 60% stop with solid color
            GradientStop { position: 1.0; color: Qt.rgba(Qt.color(baseColor).r,
                                                         Qt.color(baseColor).g,
                                                         Qt.color(baseColor).b,
                                                         appWindow.theme_v2.isLightTheme ? 0 : 0.5) }  // End color with transparency
        }
    }

    DownloadsItemTools {
        id: downloadsItemTools
        itemId: model.id
        property bool locked: downloadsItemTools.lockReason != ""
        property double itemOpacity: downloadsItemTools.locked ? 0.4 : 1
    }

    MouseArea
    {
        id: ma
        anchors.fill: parent
        propagateComposedEvents: true
        hoverEnabled: true
        acceptedButtons: Qt.NoButton
    }

    HighlightedItem
    {
        anchors.fill: parent
        visible: containsMouse || model.id === selectedDownloadsTools.currentDownloadId
    }

    MyCell
    {
        id: numCol

        x: downloadsViewHeader.numColX
        width: downloadsViewHeader.numColWidth

        spacing: 8*appWindow.zoom

        CheckBox_V2
        {
            enabled: !downloadsItemTools.locked
            checked: model.checked ?? false
            onClicked: model.checked = checked
        }

        DownloadViewItemActionButton_V2
        {
            moduleUid: downloadsItemTools.moduleUid
            buttonType: downloadsItemTools.buttonType
            enabled: !noActionsAllowed && !downloadsItemTools.locked &&
                     (downloadsItemTools.finished || !downloadsItemTools.stopping)
        }
    }

    MyCell
    {
        id: nameCol

        x: downloadsViewHeader.nameColX
        width: downloadsViewHeader.nameColWidth

        ElidedTextWithTooltip_V2 {
            id: nameText
            sourceText: downloadsItemTools.tplTitle
            Layout.fillWidth: true
        }
    }

    MyCell
    {
        id: sizeCol

        x: downloadsViewHeader.sizeColX
        width: downloadsViewHeader.sizeColWidth

        BaseText_V2 {
            text: (downloadsItemTools.selectedSize != -1 ? App.bytesAsText(downloadsItemTools.selectedSize) :
                  downloadsItemTools.bytesDownloaded > 0 ? App.bytesAsText(downloadsItemTools.bytesDownloaded) + " +" :
                  qsTr("n/a")) + App.loc.emptyString
        }
    }

    MyCell
    {
        id: statusCol

        x: downloadsViewHeader.statusColX
        width: downloadsViewHeader.statusColWidth

        DownloadStatus_V2 {
            Layout.fillWidth: true
            Layout.fillHeight: true
            MouseArea
            {
                id: ma2
                anchors.fill: parent
                propagateComposedEvents: true
                hoverEnabled: true
                acceptedButtons: Qt.NoButton
            }
        }

        WaSvgImage {
            visible: downloadsItemTools.canBeRestarted
            source: Qt.resolvedUrl("repeat.svg")
            layer.enabled: true
            layer.effect: ColorOverlay {
                color: appWindow.theme_v2.textColor
            }

            MouseAreaWithHand_V2 {
                anchors.fill: parent
                onClicked: App.downloads.mgr.restartDownload([model.id])
            }
        }
    }

    MyCell
    {
        id: dlCol

        x: downloadsViewHeader.dlColX
        width: downloadsViewHeader.dlColWidth

        BaseText_V2 {
            text: App.speedAsText(downloadsItemTools.downloadSpeed) + App.loc.emptyString
        }
    }

    MyCell
    {
        id: uplCol

        x: downloadsViewHeader.uplColX
        width: downloadsViewHeader.uplColWidth

        BaseText_V2 {
            text: App.speedAsText(downloadsItemTools.uploadSpeed) + App.loc.emptyString
        }
    }

    MyCell
    {
        id: addedCol

        x: downloadsViewHeader.addedColX
        width: downloadsViewHeader.addedColWidth

        BaseText_V2 {
            text: App.loc.dateTimeToString_v2(model.added, false) + App.loc.emptyString +
                  (downloadsViewHeader.minuteUpdate ? "" : "")
        }
    }

    MyCell
    {
        id: trashCol

        x: downloadsViewHeader.trashColX
        width: downloadsViewHeader.trashColWidth

        WaSvgImage {
            zoom: appWindow.zoom
            source: Qt.resolvedUrl("delete.svg")
            layer.enabled: true
            layer.effect: ColorOverlay {
                color: appWindow.theme_v2.bg700
            }

            MouseAreaWithHand_V2 {
                anchors.fill: parent
                onClicked: trashMenu.open()

                BaseMenu_V2 {
                    id: trashMenu
                    BaseMenuItem_V2 {
                        text: qsTr("Delete file") + App.loc.emptyString;
                        onClicked: deleteDownloadsDlgSimple.removeAction([model.id])
                    }
                    BaseMenuItem_V2 {
                        text: qsTr("Remove from list") + App.loc.emptyString;
                        onClicked: selectedDownloadsTools.removeFromList([model.id])
                    }
                }
            }
        }
    }
}
