import QtQuick
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.appconstants
import "../BaseElements/V2"

Item
{
    readonly property int numberColNameColSpacing: 8*appWindow.zoom
    readonly property int colSpacing: 16*appWindow.zoom

    readonly property alias numColX: nCol.x
    readonly property alias numColWidth: nCol.width

    readonly property alias nameColX: nameCol.x
    readonly property alias nameColWidth: nameCol.width

    readonly property alias sizeColX: sizeCol.x
    readonly property alias sizeColWidth: sizeCol.width

    readonly property alias statusColX: statusCol.x
    readonly property alias statusColWidth: statusCol.width

    readonly property alias priorityColX: priorityCol.x
    readonly property alias priorityColWidth: priorityCol.width
    readonly property int priorityTextMaxWidth: Math.max(fm.advanceWidth(qsTr('Normal') + App.loc.emptyString),
                                                         fm.advanceWidth(qsTr('High') + App.loc.emptyString),
                                                         fm.advanceWidth(qsTr('Low') + App.loc.emptyString))

    component HeaderItem : BaseText_V2 {
        color: appWindow.theme_v2.bg700
    }

    FontMetrics {
        id: fm
        font: nCol.font
    }

    implicitWidth: meat.implicitWidth
    implicitHeight: meat.implicitHeight

    RowLayout
    {
        id: meat

        anchors.fill: parent

        spacing: 0

        HeaderItem {
            id: nCol
            text: "#"
            Layout.preferredWidth: 40*appWindow.zoom
        }

        Item {
            Layout.preferredWidth: numberColNameColSpacing
        }

        HeaderItem {
            id: nameCol
            text: qsTr("Name") + App.loc.emptyString
            Layout.fillWidth: true
            Layout.minimumWidth: 100*appWindow.fontZoom
        }

        Item {
            Layout.preferredWidth: colSpacing
        }

        HeaderItem {
            id: sizeCol
            text: qsTr("Size") + App.loc.emptyString
            Layout.preferredWidth: Math.max(fm.advanceWidth(text),
                                            fm.advanceWidth(App.bytesAsText(999*AppConstants.BytesInKB) + App.loc.emptyString)) +
                                   16*appWindow.zoom + fm.font.pixelSize*0
        }

        Item {
            Layout.preferredWidth: colSpacing
        }

        HeaderItem {
            id: statusCol
            visible: !createDownloadDialog
            text: qsTr("Status") + App.loc.emptyString
            Layout.preferredWidth: Math.max(fm.advanceWidth(text),
                                            fm.advanceWidth(qsTr("Completed") + App.loc.emptyString),
                                            fm.advanceWidth("99%")) +
                                   16*appWindow.zoom + fm.font.pixelSize*0
        }

        Item {
            Layout.preferredWidth: colSpacing
        }

        HeaderItem {
            id: priorityCol
            text: qsTr("Priority") + App.loc.emptyString
            Layout.preferredWidth: Math.max(fm.advanceWidth(text), priorityTextMaxWidth + 50*appWindow.zoom) +
                                   appWindow.theme_v2.mainWindowRightMargin*appWindow.zoom + fm.font.pixelSize*0
            Layout.minimumWidth: 80*appWindow.zoom
        }
    }
}

