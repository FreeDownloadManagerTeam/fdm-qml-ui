import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.abstractdownloadsui
import "../BaseElements/V2"
import "../../common/Tools"
import "../../common"
import ".."

Item
{
    id: root

    signal justPressed(var mouse)
    signal justReleased(var mouse)
    signal justClicked(var mouse)

    property var downloadsViewHeader
    property bool noActionsAllowed: false

    readonly property int myVerticalPadding: 8*appWindow.zoom
    readonly property bool containsMouse: ma.containsMouse || statusField.containsMouse || nameCol.containsMouse ||
                                          priorityBlock.containsMouse

    implicitWidth: childrenRect.width

    implicitHeight: myVerticalPadding*2 - 1 +
                    Math.max(numCol.implicitHeight, nameCol.implicitHeight, statusCol.implicitHeight)

    component MyCellBase : RowLayout
    {
        readonly property bool maContainsMouse: ma.containsMouse && ma.mouseX >= x && ma.mouseX < x+width
        height: parent.height
    }

    component MyCell : MyCellBase
    {
        y: myVerticalPadding
        height: parent.height - myVerticalPadding*2
    }

    component HighlightedItem : Rectangle
    {
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.6; color: appWindow.theme_v2.highlightedDownloadGradientStart }
            GradientStop { position: 1.0; color: appWindow.theme_v2.highlightedDownloadGradientEnd }
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
        id: hightlightedItem
        anchors.fill: parent
        anchors.bottomMargin: 1*appWindow.zoom
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
            hasChildren: downloadsItemTools.hasChildDownloads
            enabled: !noActionsAllowed && !downloadsItemTools.locked &&
                     (downloadsItemTools.finished || !downloadsItemTools.stopping)

            SelectedDownloadsDragArea {
                downloadTitleControl: nameText
                anchors.fill: parent
                mouseCursorShape: Qt.PointingHandCursor
                onJustClicked: {
                    if (parent.canDoAction)
                        downloadsItemTools.doAction()
                }
            }
        }
    }

    MyCell
    {
        id: nameCol

        readonly property bool containsMouse: maContainsMouse || nameText.containsMouse || maTagContainsMouse

        property int maTagContainsMouse: 0

        x: downloadsViewHeader.nameColX
        width: downloadsViewHeader.nameColWidth

        ElidedTextWithTooltip_V2 {
            id: nameText
            sourceText: downloadsItemTools.titleSingleLine
            Layout.fillWidth: true

            /*SelectedDownloadsDragArea {
                downloadTitleControl: nameText
                anchors.fill: parent
                Component.onCompleted: {
                    justPressed.connect(root.justPressed);
                    justReleased.connect(root.justReleased);
                    justClicked.connect(root.justClicked);
                }
            }*/
        }

        RowLayout {
            spacing: 3*appWindow.zoom
            Repeater {
                model: downloadsItemTools.allTags
                delegate: Rectangle {
                    implicitWidth: appWindow.theme_v2.tagSquareSize*appWindow.zoom
                    implicitHeight: implicitWidth
                    color: modelData.color
                    radius: 4*appWindow.zoom
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        propagateComposedEvents: true
                        acceptedButtons: Qt.NoButton
                        //onClicked: downloadsViewTools.setDownloadsTagFilter(modelData.id)
                        BaseToolTip_V2 {
                            text: modelData.name
                            visible: parent.containsMouse
                        }
                        onContainsMouseChanged: {
                            if (containsMouse)
                                ++nameCol.maTagContainsMouse;
                            else
                                --nameCol.maTagContainsMouse;
                        }
                    }
                }
            }
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

        DownloadsViewItemStatus_V2
        {
            id: statusField
            highlighted: hightlightedItem.visible
            Layout.fillWidth: true
        }
    }

    MyCell
    {
        id: dlCol

        visible: !priorityBlock.visible

        x: downloadsViewHeader.dlColX
        width: downloadsViewHeader.dlColWidth

        BaseText_V2 {
            text: App.speedAsText(downloadsItemTools.downloadSpeed) + App.loc.emptyString
            color: priorityColor(model.priority)
        }
    }

    MyCell
    {
        id: uplCol

        visible: !priorityBlock.visible

        x: downloadsViewHeader.uplColX
        width: downloadsViewHeader.uplColWidth

        BaseText_V2 {
            text: App.speedAsText(downloadsItemTools.uploadSpeed) + App.loc.emptyString
            color: priorityColor(model.priority)
        }
    }

    component DownloadPriorityButton : Item
    {
        property alias containsMouse: maDlPriorityBtn.containsMouse
        property bool isUp: true

        enabled: isUp ? model.priority != AbstractDownloadsUi.DownloadPriorityHigh :
                        model.priority != AbstractDownloadsUi.DownloadPriorityLow

        implicitWidth: 24*appWindow.zoom
        implicitHeight: implicitWidth

        SvgImage_V2
        {
            source: Qt.resolvedUrl("download_priority_up.svg")
            rotation: isUp ? 0 : 180
            imageColor: {
                if (!enabled || !maDlPriorityBtn.containsMouse)
                    return supposedImageColor;

                if (isUp) {
                    if (model.priority == AbstractDownloadsUi.DownloadPriorityNormal)
                        return appWindow.theme_v2.secondary;
                } else {
                    if (model.priority == AbstractDownloadsUi.DownloadPriorityNormal)
                        return appWindow.theme_v2.danger;
                }

                return supposedImageColor;
            }
            anchors.centerIn: parent
        }

        MouseAreaWithHand_V2
        {
            id: maDlPriorityBtn
            hoverEnabled: true
            anchors.fill: parent
            onClicked: {
                if (isUp) {
                    if (model.priority == AbstractDownloadsUi.DownloadPriorityNormal) {
                        App.downloads.infos.info(model.id).priority = AbstractDownloadsUi.DownloadPriorityHigh;
                    } else if (model.priority == AbstractDownloadsUi.DownloadPriorityLow) {
                        App.downloads.infos.info(model.id).priority = AbstractDownloadsUi.DownloadPriorityNormal;
                    }
                } else {
                    if (model.priority == AbstractDownloadsUi.DownloadPriorityHigh) {
                        App.downloads.infos.info(model.id).priority = AbstractDownloadsUi.DownloadPriorityNormal;
                    } else if (model.priority == AbstractDownloadsUi.DownloadPriorityNormal) {
                        App.downloads.infos.info(model.id).priority = AbstractDownloadsUi.DownloadPriorityLow;
                    }
                }
            }
        }
    }

    function priorityColor(priority)
    {
        return priority == AbstractDownloadsUi.DownloadPriorityHigh ? appWindow.theme_v2.secondary :
               priority == AbstractDownloadsUi.DownloadPriorityLow ? appWindow.theme_v2.danger :
               appWindow.theme_v2.textColor;
    }

    MyCellBase
    {
        id: priorityBlock

        readonly property bool containsMouse: maContainsMouse || priorityDown.containsMouse || priorityUp.containsMouse

        visible: !downloadsItemTools.finished &&
                 (dlCol.maContainsMouse || uplCol.maContainsMouse || containsMouse)

        x: downloadsViewHeader.dlColX
        width: downloadsViewHeader.uplColX - downloadsViewHeader.dlColX + downloadsViewHeader.uplColWidth

        spacing: 8*appWindow.zoom

        DownloadPriorityButton
        {
            id: priorityDown
            isUp: false
        }

        BaseText_V2
        {
            text: qsTr("Priority") + App.loc.emptyString
            color: priorityColor(model.priority)
            Layout.fillWidth: true
            Layout.maximumWidth: implicitWidth
        }

        DownloadPriorityButton
        {
            id: priorityUp
            isUp: true
        }

        Item {Layout.fillWidth: true; implicitHeight: 1}
    }

    MyCell
    {
        id: addedCol

        x: downloadsViewHeader.addedColX
        width: downloadsViewHeader.addedColWidth

        BaseText_V2 {
            id: stoppedText
            visible: !downloadsItemTools.running && !downloadsItemTools.finished
            text: qsTr("Stopped")
            color: appWindow.theme_v2.bg500
        }

        BaseText_V2 {
            visible: !stoppedText.visible && downloadsItemTools.eta >= 0
            text: qsTr("Remaining")
        }

        /*SvgImage_V2 {
            visible: downloadsItemTools.eta >= 0
            source: visible ? Qt.resolvedUrl("hourglass.svg") : ""
        }*/

        BaseText_V2 {
            visible: !stoppedText.visible
            text: downloadsItemTools.eta >= 0 ?
                      JsTools.timeUtils.remainingTime(downloadsItemTools.eta) :
                      (model.added ?
                           (App.loc.dateTimeToString_v2(model.added, false, false) + App.loc.emptyString + (downloadsViewHeader.minuteUpdate ? "" : "")) :
                           "")
            Layout.fillWidth: true
        }
    }
}
