import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material
import org.freedownloadmanager.fdm
import "../"
import "../BaseElements"
import "../Dialogs"
import "../../common"
import "../../common/Tools"

Page {
    id: root
    property var downloadItemId
    property int tabIndex: 0
    property var currentTabsModel: []

    DownloadsItemTools {
        id: downloadsItemTools
        itemId: downloadItemId
        onHasDetailsChanged: updateCurrentTabsModel()

        property bool locked: downloadsItemTools.lockReason != ""
        property var itemOpacity: downloadsItemTools.locked ? 0.4 : 1
    }

    header: Column {
        id: toolbar
        height: 108
        width: root.width

        Toolbar {}

        ToolBarShadow {}

        ExtraToolBar {
            Row {
                id: filtersBar
                visible: currentTabsModel.length > 1

                property int filter: tabIndex

                height: parent.height
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: tabs.count > 3 ? 10 : 30

                Repeater {
                    id: tabs
                    model: currentTabsModel

                    ItemPageFilterButton {
                        text: modelData.name
                        value: modelData.id
                    }
                }
            }
        }
    }

    GeneralTab {
        visible: filtersBar.filter === 0
    }

    DetailsTab {
        visible: filtersBar.filter === 3
    }

    Files {
        visible: filtersBar.filter === 1
        downloadItemId: downloadsItemTools.itemId
        downloadInfo: downloadsItemTools.item
    }

    ConnectionsTab {
        visible: filtersBar.filter === 2
    }

    DeleteDownloadsDialog {
        id: deleteDownloadsDialog
        downloadIds: [downloadItemId]

        onDownloadsRemoved: stackView.pop()
    }

    SchedulerDialog {
        id: schedulerDlg
    }

    SchedulerTools {
        id: schedulerTools
        onBuildingFinished: {
            schedulerDlg.initialization();
            schedulerDlg.open();
        }
        onSettingsSaved: schedulerDlg.close()
    }

    Component.onCompleted: updateCurrentTabsModel();

    function updateCurrentTabsModel()
    {
        var ids = [0];
        var tabs = [{id: 0, name: qsTr("Info") + App.loc.emptyString}];

        var downloadInfo = App.downloads.infos.info(downloadItemId);

        if (downloadInfo.details) {
            tabs.push({id: 3, name: qsTr("Details") + App.loc.emptyString});
            ids.push("details");
        }

        if (downloadInfo.filesCount > 1) {
            tabs.push({id: 1, name: qsTr("Files") + App.loc.emptyString});
            ids.push("files");
        }

        if (!downloadInfo.finished || downloadInfo.hasPostFinishedTasks) {
            tabs.push({id: 2, name: qsTr("Connections") + App.loc.emptyString});
            ids.push("connections");
        }

        currentTabsModel = tabs;
    }
}
