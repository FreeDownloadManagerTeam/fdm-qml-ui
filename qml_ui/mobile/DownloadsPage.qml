import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.4
import org.freedownloadmanager.fdm 1.0
import "../common"
import "./BaseElements"
import "./Dialogs"
import "./Dialogs/TumModeDialog"
import "../common/Tools"

Page
{
    id: root

    header: Column {
        height: 108
        width: root.width

        MainToolbar {
            id: upperBarLoader
        }

        SearchToolbar {
            id: searchBar

            onSwitchMainView: { root.state = "mainView"; }
        }

        ToolBarShadow {}

        Connections {
            id: connectionsWithUpperBar
            target: upperBarLoader

            onHamburgerClicked: leftDrawer.open()
            onSwitchMainViewSelectMode: { root.state = "mainViewSelectMode"; }
            onSwitchSearchView: { root.state = "searchView"; }
        }

        MainFiltersBar {
            id: mainFiltersBar
            visible: appWindow.hasDownloadMgr
        }

        SelectModeTopBar {
            id: selectModeTopBar
            onSwitchSelectModeOff: root.switchSelectModeOff()
        }
    }

    onStateChanged: {
        if (state === "searchView") {
            searchBar.switchSearchView();
        }
    }

    state: "mainView"

    states: [
        State {
            name: "mainView"
            PropertyChanges {
                target: appWindow;
                showDownloadIcon: true;
                showDownloadCheckbox: false;
                showDownloadItemMenuBtn: true;
                selectMode: false;
                searchMode: false;
            }
            StateChangeScript {
                script: {
                    App.downloads.model.checkAll(false);
                }
            }
            PropertyChanges {
                target: newDownloadRoundBtn;
                visible: appWindow.hasDownloadMgr;
            }
//            PropertyChanges {
//                target: snailBtn;
//                visible: true;
//            }
            PropertyChanges {
                target: upperBarLoader;
                enabled: true
                visible: true;
            }
            PropertyChanges {
                target: searchBar;
                enabled: true
                visible: false;
            }
            PropertyChanges {
                target: mainFiltersBar;
                visible: appWindow.hasDownloadMgr;
            }
            PropertyChanges {
                target: selectModeTopBar;
                visible: false;
            }
            PropertyChanges {
                target: selectModeBar;
                visible: false;
            }
        },
        State {
            name: "mainViewSelectMode"
            PropertyChanges {
                target: appWindow;
                showDownloadIcon: false;
                showDownloadCheckbox: true;
                showDownloadItemMenuBtn: false;
                selectMode: true;
                searchMode: false;
            }
            PropertyChanges {
                target: newDownloadRoundBtn;
                visible: false;
            }
//            PropertyChanges {
//                target: snailBtn;
//                visible: false;
//            }
            PropertyChanges {
                target: upperBarLoader;
                enabled: false
                visible: true;
            }
            PropertyChanges {
                target: searchBar;
                enabled: false
                visible: false;
            }
            PropertyChanges {
                target: mainFiltersBar;
                visible: false;
            }
            PropertyChanges {
                target: selectModeTopBar;
                visible: true;
            }
            PropertyChanges {
                target: selectModeBar;
                visible: true;
            }
        },
        State {
            name: "searchView"
            PropertyChanges {
                target: appWindow;
                showDownloadIcon: true;
                showDownloadCheckbox: false;
                showDownloadItemMenuBtn: true;
                selectMode: false;
                searchMode: true;
            }
            StateChangeScript {
                script: {
                    App.downloads.model.checkAll(false);
                }
            }
            PropertyChanges {
                target: newDownloadRoundBtn;
                visible: false;
            }
//            PropertyChanges {
//                target: snailBtn;
//                visible: false;
//            }
            PropertyChanges {
                target: upperBarLoader;
                enabled: true
                visible: false;
            }
            PropertyChanges {
                target: searchBar;
                enabled: true
                visible: true;
            }
            PropertyChanges {
                target: mainFiltersBar;
                visible: appWindow.hasDownloadMgr;
            }
            PropertyChanges {
                target: selectModeTopBar;
                visible: false;
            }
            PropertyChanges {
                target: selectModeBar;
                visible: false;
            }
        },
        State {
            name: "searchViewSelectMode"
            PropertyChanges {
                target: appWindow;
                showDownloadIcon: false;
                showDownloadCheckbox: true;
                showDownloadItemMenuBtn: false;
                selectMode: true;
                searchMode: false;
            }
            PropertyChanges {
                target: newDownloadRoundBtn;
                visible: false;
            }
//            PropertyChanges {
//                target: snailBtn;
//                visible: false;
//            }
            PropertyChanges {
                target: upperBarLoader;
                enabled: false
                visible: false;
            }
            PropertyChanges {
                target: searchBar;
                enabled: false
                visible: true;
            }
            PropertyChanges {
                target: mainFiltersBar;
                visible: false;
            }
            PropertyChanges {
                target: selectModeTopBar;
                visible: true;
            }
            PropertyChanges {
                target: selectModeBar;
                visible: true;
            }
        }
    ]

    Rectangle {
        id: downloadPageBackground
        anchors.fill: parent
        color: appWindow.theme.background
    }

    LeftDrawer {
        id: leftDrawer
    }

    DownloadsView
    {
        id: downloadsView
        anchors.fill: parent
        visible: !App.downloads.infos.empty

        Component.onCompleted: {
            selectedDownloadsTools.registerListView(this);
        }

        Component.onDestruction: {
            selectedDownloadsTools.unregisterListView(this);
        }

        onDownloadSelected: {
            root.switchSelectModeOn();
        }

        onDownloadUnselected: {
            var checked_ids = App.downloads.model.checkedIds();
            if (checked_ids.length === 0) {
                root.switchSelectModeOff();
            }
        }

        onFlickingChanged: changeRoundButtonsVisibility(!downloadsView.flicking)
        onDraggingChanged: changeRoundButtonsVisibility(!downloadsView.dragging)

        function changeRoundButtonsVisibility(visibility) {
            if (root.state == "mainView") {
//                snailBtn.visible = visibility;
                newDownloadRoundBtn.visible = visibility && appWindow.hasDownloadMgr;
            }
        }
    }

    SelectSortFieldDialog {
        id: selectSortFieldDialog
    }

    RowLayout {
        anchors.fill: parent
        visible: appWindow.hasDownloadMgr && App.downloads.infos.empty

        BaseLabel {
            text: qsTr("Download list is empty. Add new download URL.") + App.loc.emptyString
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
            Layout.topMargin: 150
            horizontalAlignment: Text.AlignHCenter
        }
    }

    Label
    {
        visible: !appWindow.hasDownloadMgr && !App.rc.client.active
        text: "<a href='#'>" + qsTr("Connect to remote %1").arg(App.shortDisplayName) + "</a>" + App.loc.emptyString
        onLinkActivated: connectToRemoteAppDlg.open()
        Material.accent: appWindow.theme.link
        anchors.centerIn: parent
    }

    //empty search results
    Rectangle {
        anchors.fill: parent
        anchors.margins: 15
        color: "transparent"
        visible: !App.downloads.infos.empty && (downloadsViewTools.emptySearchResults || downloadsViewTools.emptyActiveDownloadsList || downloadsViewTools.emptyCompleteDownloadsList)

        ColumnLayout {
            anchors.top: parent.top
            anchors.topMargin: Math.round(parent.height * 0.3)
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width

            BaseLabel {
                Layout.alignment: Qt.AlignHCenter
                text: (downloadsViewTools.emptySearchResults ? qsTr("No results found for") + " \"" + downloadsViewTools.downloadsTitleFilter + "\"" :
                       downloadsViewTools.emptyActiveDownloadsList ? qsTr("No active downloads") :
                       downloadsViewTools.emptyCompleteDownloadsList ? qsTr("No completed downloads") : "") + App.loc.emptyString
                font.pixelSize: 14
                Layout.preferredWidth: parent.width
                wrapMode: Label.Wrap
                horizontalAlignment: Text.AlignHCenter
                opacity: 0.5
            }

            BaseLabel {
                Layout.alignment: Qt.AlignHCenter
                text: "<a href='#'>" + qsTr("Show all") + App.loc.emptyString + "</a>"
                Layout.preferredWidth: parent.width
                wrapMode: Label.Wrap
                horizontalAlignment: Text.AlignHCenter
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        downloadsViewTools.resetFilters()
                        root.state = "mainView";
                    }
                }
            }
        }
    }

//    SnailButton
//    {
//        id: snailBtn
//        anchors {
//            left: parent.left
//            bottom: parent.bottom
//            leftMargin: 20
//            bottomMargin: 20
//        }
//    }

    //Round add button - BEGIN
    RoundButton
    {
        id: newDownloadRoundBtn

        visible: appWindow.hasDownloadMgr

        onClicked: appWindow.createDownloadDialog()

        width: 58
        height: 58
        radius: Math.round(width / 2)

        padding: 0
        spacing: 0

        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: 20
        anchors.bottomMargin: 20

        Material.elevation: 0
        Material.background: appWindow.theme.selectModeBarAndPlusBtn
        display: AbstractButton.IconOnly

        icon.source: Qt.resolvedUrl("../images/mobile/plus.svg")
        icon.width: 24
        icon.height: 24
        icon.color: "#fff"
    }
    //Round add button - End

    SelectModeBar {
        id: selectModeBar

        onSwitchSelectModeOff: root.switchSelectModeOff()
    }

    TumModeDialog {
        id: tumModeDialog
    }

    DeleteDownloadsDialog {
        id: deleteDownloadsDialog

        onDownloadsRemoved: root.switchSelectModeOff()
    }

    DeleteDownloadsFailedDialog {}

    ConfirmDeleteExtraneousFilesDialog {}

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

    Connections {
        target: App.downloads.infos
        onEmptyChanged: {
            if (App.downloads.infos.empty) {
                root.switchSelectModeOff();
            }
        }
    }

    function switchSelectModeOff()
    {
        if (root.state === "searchViewSelectMode") {
            root.state = "searchView";
        } else if (root.state === "mainViewSelectMode") {
            root.state = "mainView";
        }
    }

    function switchSelectModeOn()
    {
        if (root.state === "searchView") {
            root.state = "searchViewSelectMode";
        } else if (root.state === "mainView") {
            root.state = "mainViewSelectMode";
        }
    }

    ConvertFilesFailedDialog
    {
        id: convertFilesFailedDialog
    }

    ConvertDestinationFilesExistsDialog
    {
        id: convertDestinationFilesExistsDialog

        onClosed: {
            if (requests.length)
                onGotRequest();
        }

        property var requests: []

        function onGotRequest()
        {
            if (opened || !requests.length)
                return;

            var r = requests.shift();

            taskId = r.taskId;
            files = r.files;

            open();
        }
    }

    Connections
    {
        target: App.downloads.mgr

        onConvertDestinationFilesExists: function(taskId, files)
        {
            files.forEach((e,i,a) => a[i] = App.toNativeSeparators(e));

            convertDestinationFilesExistsDialog.requests.push(
                        {
                            taskId: taskId,
                            files: files
                        });

            convertDestinationFilesExistsDialog.onGotRequest();
        }

        onConvertTaskFinished: function(taskId, failedFiles)
        {
            if (convertDestinationFilesExistsDialog.opened &&
                    convertDestinationFilesExistsDialog.taskId == taskId)
            {
                convertDestinationFilesExistsDialog.close();
            }

            if (failedFiles.length > 0)
            {
                failedFiles.forEach((e,i,a) => a[i] = App.toNativeSeparators(e));

                if (convertFilesFailedDialog.opened)
                {
                    var arr = convertFilesFailedDialog.failedFiles;
                    arr.push(...files);
                    convertFilesFailedDialog.files = arr;
                }
                else
                {
                    convertFilesFailedDialog.files = failedFiles;
                    convertFilesFailedDialog.open();
                }
            }
        }
    }

    Connections {
        target: appWindow
        onOpenScheduler: (downloadId) => schedulerDlg.setUpSchedulerAction([downloadId])
    }
}
