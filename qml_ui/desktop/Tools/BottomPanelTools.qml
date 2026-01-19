import QtQuick
import org.freedownloadmanager.fdm

Item {
    id: root

    readonly property int min_bottom_panel_height: (appWindow.uiver === 1 ? 150 :  210)*appWindow.zoom
    readonly property int min_other_elements_height: 350*appWindow.zoom

    property bool panelVisible: false
    property bool panelCanBeShown: false

    readonly property bool sufficientWindowHeight: appWindow.height >= min_bottom_panel_height+min_other_elements_height

    property int panelHeigth: Math.max(min_other_elements_height, 210*appWindow.zoom)

    property var currentTabsModel: []
    property string currentTab

    property int bottomPanelHeigthUserValue: uiSettingsTools.settings.bottomPanelHeigthUserValue
    property bool bottomPanelJustOpened: false

    Component.onCompleted: updateState();

    Connections {
        target: selectedDownloadsTools
        onCurrentDownloadIdChanged: updateState()
    }

    Connections {
        target: appWindow
        onHeightChanged: updatePanelHeigth()
    }

    onBottomPanelHeigthUserValueChanged: updatePanelHeigth()


    function setPanelHeigth(height)
    {
        bottomPanelHeigthUserValue = height;
        uiSettingsTools.settings.bottomPanelHeigthUserValue = height;
    }

    function updatePanelHeigth()
    {
        panelHeigth = normalizeBottomPanelHeight(bottomPanelHeigthUserValue);
    }

    function normalizeBottomPanelHeight(height)
    {
        if (height < min_bottom_panel_height) {
            height = min_bottom_panel_height;
        }
        if (appWindow.height - height < min_other_elements_height) {
            return appWindow.height - min_other_elements_height;
        }
        return height;
    }

    function updateState()
    {
        if (selectedDownloadsTools.currentDownloadId >= 0) {
            panelCanBeShown = true;

            updateCurrentTabsModel();

            if (currentTabsModel.find(obj => { return obj.id == uiSettingsTools.settings.bottomPanelCurrentTabUserValue })) {
                currentTab = uiSettingsTools.settings.bottomPanelCurrentTabUserValue;
            } else {
                currentTab = "general";
            }

            if (uiSettingsTools.settings.bottomPanelOpenedUserValue) {
                panelVisible = true;
            } else {
                panelVisible = false;
            }
        } else {
            panelCanBeShown = false;
            panelVisible = false;
            currentTab = "";
        }
    }

    function panelToggleClick(forceOpen = false)
    {
        if (panelCanBeShown) {
            if (!panelVisible) {
                bottomPanelJustOpened = true;
            }
            uiSettingsTools.settings.bottomPanelOpenedUserValue = forceOpen ? true : !panelVisible;
            updateState();
        }
    }

    function panelCloseClick()
    {
        if (panelCanBeShown) {
            uiSettingsTools.settings.bottomPanelOpenedUserValue = false;
            updateState();
        }
    }

    function panelTabClick(tab_name)
    {
        if (panelCanBeShown) {
            uiSettingsTools.settings.bottomPanelCurrentTabUserValue = tab_name;
            updateState();
        }
    }

    function openFilesTab()
    {
        panelToggleClick(true);
        currentTab = "files";
    }

    function updateCurrentTabsModel()
    {
        if (!panelCanBeShown) {
            return;
        }

        var tabs = [{id: "general", name: qsTr("General") + App.loc.emptyString}];

        if ( selectedDownloadsTools.currentDownloadId >= 0 ) {
            var downloadInfo = App.downloads.infos.info(selectedDownloadsTools.currentDownloadId);

            if (downloadInfo.details) {
                tabs.push({id: "details", name: qsTr("Details") + App.loc.emptyString});
            }

            if (!downloadInfo.hasChildDownloads) {
                tabs.push({id: "progress", name: qsTr("Progress") + App.loc.emptyString});
            }

            if (downloadInfo.filesCount > 1) {
                tabs.push({id: "files", name: qsTr("Files") + App.loc.emptyString});
            }

            if (!downloadInfo.finished || downloadInfo.hasPostFinishedTasks) {
                tabs.push({id: "connections", name: qsTr("Connections") + App.loc.emptyString});
            }
        }

        currentTabsModel = tabs;
    }

    Connections {
        target: App.loc
        onCurrentTranslationChanged: updateCurrentTabsModel();
    }
}
