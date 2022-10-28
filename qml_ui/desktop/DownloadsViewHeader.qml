import QtQuick 2.10
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.abstractdownloadsui 1.0
import "./BaseElements"

RowLayout
{
    id: root

    property int nameColumnWidth: 0
    property int statusColumnWidth: 0
    property int speedColumnWidth: 0
    property int sizeColumnWidth: 0
    property int dateColumnWidth: 0

    readonly property int nameColumnFullWidth: nameItem.width + (nameItem.shareSpaceWithOrderItem ? orderItem.width : 0)
    readonly property int statusColumnFullWidth: statusItem.width + (statusItem.shareSpaceWithOrderItem ? orderItem.width : 0)
    readonly property int speedColumnFullWidth: speedItem.width + (speedItem.shareSpaceWithOrderItem ? orderItem.width : 0)
    readonly property int sizeColumnFullWidth: sizeItem.width + (sizeItem.shareSpaceWithOrderItem ? orderItem.width : 0)
    readonly property int dateColumnFullWidth: addedItem.width + (addedItem.shareSpaceWithOrderItem ? orderItem.width : 0)

    spacing: 0
    height: manageItem.height
    clip: true

    DownloadsViewHeaderItem {
        id: manageItem
        Layout.preferredWidth: (appWindow.compactView ? 45 : 80)*appWindow.zoom
        Layout.preferredHeight: manageItem.height
        onRightButtonClicked: (pt) => openMenu(pt)

        BaseCheckBox {
            id: cbx
            tristate: true
            xOffset: 0
            anchors.leftMargin: 8*appWindow.zoom
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            checkBoxStyle: "black"
            checkState: App.downloads.model.allCheckState
            onClicked: {
                if (App.downloads.model.allCheckState === Qt.Checked) {
                    checkState = Qt.Unchecked;
                    App.downloads.model.checkAll(false);
                } else {
                    checkState = Qt.Checked;
                    App.downloads.model.checkAll(true);
                }
            }
            Connections {
                target: App.downloads.model
                onAllCheckStateChanged: cbx.checkState = App.downloads.model.allCheckState
            }
        }
    }

    DownloadsViewHeaderItem {
        id: nameItem
        readonly property bool shareSpaceWithOrderItem: statusItem.shareSpaceWithOrderItem && !statusItem.visible
        sortBy: AbstractDownloadsUi.DownloadsSortByTitle
        text: qsTr("Name") + App.loc.emptyString
        Layout.fillWidth: true
        Layout.minimumWidth: Math.max(nameColumnWidth - (shareSpaceWithOrderItem ? orderItem.width : 0), headerMinimumWidth)
        Layout.fillHeight: true
        onRightButtonClicked: (pt) => openMenu(pt)
    }

    DownloadsViewHeaderItem {
        id: statusItem
        readonly property bool shareSpaceWithOrderItem: speedItem.shareSpaceWithOrderItem && !speedItem.visible
        sortBy: AbstractDownloadsUi.DownloadsSortByStatus
        text: qsTr("Status") + App.loc.emptyString
        Layout.preferredWidth: Math.max(statusColumnWidth - (shareSpaceWithOrderItem ? orderItem.width : 0), headerMinimumWidth)
        Layout.fillHeight: true
        onRightButtonClicked: (pt) => openMenu(pt)
    }

    DownloadsViewHeaderItem {
        id: speedItem
        readonly property bool shareSpaceWithOrderItem: sizeItem.shareSpaceWithOrderItem && !sizeItem.visible
        text: qsTr("Speed") + App.loc.emptyString
        Layout.preferredWidth: Math.max(speedColumnWidth - (shareSpaceWithOrderItem ? orderItem.width : 0), headerMinimumWidth)
        Layout.fillHeight: true
        onRightButtonClicked: (pt) => openMenu(pt)
    }

    DownloadsViewHeaderItem {
        id: sizeItem
        readonly property bool shareSpaceWithOrderItem: addedItem.shareSpaceWithOrderItem && !addedItem.visible
        sortBy: AbstractDownloadsUi.DownloadsSortBySize
        text: qsTr("Size") + App.loc.emptyString
        Layout.preferredWidth: Math.max(sizeColumnWidth - (shareSpaceWithOrderItem ? orderItem.width : 0), headerMinimumWidth)
        Layout.fillHeight: true
        onRightButtonClicked: (pt) => openMenu(pt)
    }

    DownloadsViewHeaderItem {
        id: addedItem
        readonly property bool shareSpaceWithOrderItem: orderItem.visible
        sortBy: AbstractDownloadsUi.DownloadsSortByCreationTime
        text: qsTr("Added") + App.loc.emptyString
        Layout.preferredWidth: Math.max(dateColumnWidth - (shareSpaceWithOrderItem ? orderItem.width : 0), headerMinimumWidth)
        Layout.fillHeight: true
        onRightButtonClicked: (pt) => openMenu(pt)
    }

    DownloadsViewHeaderItem {
        visible: uiSettingsTools.settings.enableUserDefinedOrderOfDownloads
        sortBy: AbstractDownloadsUi.DownloadsSortByOrder
        disableOrderTypeChange: true
        id: orderItem
        imageSource: appWindow.theme.userSortImg
        Layout.preferredWidth: headerMinimumWidth
        Layout.fillHeight: true
        onRightButtonClicked: (pt) => openMenu(pt)

        Rectangle {
            height: parent.height
            width: 1
            anchors.right: parent.right
            color: appWindow.theme.border
        }
    }

    readonly property var columns: [
        {name: "status", col: statusItem},
        {name: "speed", col: speedItem},
        {name: "size", col: sizeItem},
        {name: "added", col: addedItem},
    ]

    function columnByName(name) {
        for (let i = 0; i < columns.length; ++i)
        {
            if (columns[i].name === name)
                return columns[i].col;
        }
        return null;
    }

    function nameByColumn(col) {
        for (let i = 0; i < columns.length; ++i)
        {
            if (columns[i].col === col)
                return columns[i].name;
        }
        return null;
    }

    function openMenu(pt)
    {
        pt = root.mapFromGlobal(pt.x, pt.y);
        cm.x = pt.x;
        cm.y = pt.y;
        cm.open();
    }

    BaseContextMenu {
        id: cm
        transformOrigin: Menu.TopRight

        BaseContextMenuItem {
            text: statusItem.text
            onTriggered: toggleVisibility(statusItem)
            checkable: true
            checked: statusItem.visible
        }

        BaseContextMenuItem {
            text: speedItem.text
            onTriggered: toggleVisibility(speedItem)
            checkable: true
            checked: speedItem.visible
        }

        BaseContextMenuItem {
            text: sizeItem.text
            onTriggered: toggleVisibility(sizeItem)
            checkable: true
            checked: sizeItem.visible
        }

        BaseContextMenuItem {
            text: addedItem.text
            onTriggered: toggleVisibility(addedItem)
            checkable: true
            checked: addedItem.visible
        }
    }

    function itemAt(index)
    {
        switch(index)
        {
        case 0: return manageItem;
        case 1: return nameItem;
        case 2: return statusItem;
        case 3: return speedItem;
        case 4: return sizeItem;
        case 5: return addedItem;
        case 6: return orderItem;
        }
    }

    function toggleVisibility(col)
    {
        col.visible = !col.visible;
        saveColsState();
    }

    function saveColsState()
    {
        let o = {};
        for (let i = 0; i < columns.length; ++i)
        {
            o[columns[i].name] = {
                visible: columns[i].col.visible
            };
        }
        uiSettingsTools.settings.downloadsListColumns = JSON.stringify(o);
    }

    function readColsState()
    {
        if (uiSettingsTools.settings.downloadsListColumns)
        {
            let o = JSON.parse(uiSettingsTools.settings.downloadsListColumns);
            if (o)
            {
                for (let i = 0; i < columns.length; ++i)
                {
                    if (columns[i].name in o)
                        columns[i].col.visible = o[columns[i].name].visible;
                }
            }
        }
    }

    Component.onCompleted: {
        readColsState();
    }

    Connections {
        target: uiSettingsTools
        onWasReset: {
            for (let i = 0; i < columns.length; ++i)
                columns[i].col.visible = true;
        }
    }
}
