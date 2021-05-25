import QtQuick 2.10
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0
import "./BaseElements"

RowLayout
{
    property int nameColumnWidth: 0
    property int statusColumnWidth: 0
    property int speedColumnWidth: 0
    property int sizeColumnWidth: 0
    property int dateColumnWidth: 0

    spacing: 0
    height: manageItem.height
    clip: true

    DownloadsViewHeaderItem {
        id: manageItem
        Layout.preferredWidth: appWindow.compactView ? 45 : 80
        Layout.preferredHeight: manageItem.height

        BaseCheckBox {
            id: cbx
            tristate: true
            xOffset: 0
            anchors.leftMargin: 8
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
        sortOptionName: "name"
        id: nameItem
        text: qsTr("Name") + App.loc.emptyString
        Layout.fillWidth: true
        Layout.minimumWidth: Math.max(nameColumnWidth, headerMinimumWidth)
        Layout.fillHeight: true
    }

    DownloadsViewHeaderItem {
        id: statusItem
        text: qsTr("Status") + App.loc.emptyString
        Layout.preferredWidth: Math.max(statusColumnWidth, headerMinimumWidth)
        Layout.fillHeight: true
    }

    DownloadsViewHeaderItem {
        id: speedItem
        text: qsTr("Speed") + App.loc.emptyString
        Layout.preferredWidth: Math.max(speedColumnWidth, headerMinimumWidth)
        Layout.fillHeight: true
    }

    DownloadsViewHeaderItem {
        sortOptionName: "size"
        id: sizeItem
        text: qsTr("Size") + App.loc.emptyString
        Layout.preferredWidth: Math.max(sizeColumnWidth, headerMinimumWidth)
        Layout.fillHeight: true
    }

    DownloadsViewHeaderItem {
        sortOptionName: "creation_date"
        id: addedItem
        text: qsTr("Added") + App.loc.emptyString
        Layout.preferredWidth: Math.max(dateColumnWidth, headerMinimumWidth)
        Layout.fillHeight: true

        Rectangle {
            height: parent.height
            width: 1
            anchors.right: parent.right
            color: appWindow.theme.border
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
        }
    }
}
