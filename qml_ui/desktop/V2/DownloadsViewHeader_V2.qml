import QtQuick
import QtQuick.Layouts
import org.freedownloadmanager.fdm 1.0

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

    readonly property alias dlColX: dlCol.x
    readonly property alias dlColWidth: dlCol.width

    readonly property alias uplColX: uplCol.x
    readonly property alias uplColWidth: uplCol.width

    readonly property alias addedColX: addedCol.x
    readonly property alias addedColWidth: addedCol.width

    readonly property alias trashColX: trashCol.x
    readonly property alias trashColWidth: trashCol.width

    property bool minuteUpdate: false // to update "Today"/"Yestarday" date strings
    Timer {
        interval: 60*1000
        repeat: true
        onTriggered: minuteUpdate = !minuteUpdate
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
            Layout.minimumWidth: 192*appWindow.zoom
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
                                 Math.max(fm.advanceWidth(App.loc.dateTimeToString_v2_maxString(false) + App.loc.emptyString),
                                          80*appWindow.fontZoom)
        }

        Item {
            Layout.preferredWidth: colSpacing
        }

        DownloadsViewHeaderItem_V2 {
            id: trashCol
            Layout.preferredWidth: (16+8+appWindow.theme_v2.mainWindowRightMargin)*appWindow.zoom
        }
    }

}

