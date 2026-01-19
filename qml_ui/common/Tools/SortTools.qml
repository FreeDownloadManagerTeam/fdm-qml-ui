import QtQuick
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.dmcoresettings
import org.freedownloadmanager.fdm.appsettings
import org.freedownloadmanager.fdm.abstractdownloadsui 

Item {

    property int sortBy
    property bool sortAscendingOrder

    function sortByClick(sortBy_)
    {
        if (sortBy === sortBy_)
            changeSortAscendingOrder();
        else
            setSortByAndAsc(sortBy_, false);
    }

    function changeSortAscendingOrder() {
        setSortAscendingOrder(!sortAscendingOrder);
    }

    function setSortBy(sortById) {

        App.settings.app.setValue(
                    AppSettings.SortBy,
                    sortById);

        sortBy = sortById;
    }

    function setSortAscendingOrder(sortAsc) {

        App.settings.app.setValue(
                    AppSettings.SortAscendingOrder,
                    App.settings.fromBool(sortAsc));

        sortAscendingOrder = sortAsc;
    }

    function setSortByAndAsc(sortByVal, sortAsc) {

        setSortBy(sortByVal);
        setSortAscendingOrder(sortAsc);
    }

    function updateState()
    {
        sortBy = parseInt(App.settings.app.value(AppSettings.SortBy));
        sortAscendingOrder = App.settings.toBool(App.settings.app.value(AppSettings.SortAscendingOrder));
    }

    Component.onCompleted: {
        updateState();
        applyEnableUserDefinedOrderOfDownloads();
    }

    Connections{
        target: appWindow
        onUiReadyStateChanged: updateState()
        onUiverChanged: applyEnableUserDefinedOrderOfDownloads()
    }

    function applyEnableUserDefinedOrderOfDownloads()
    {
        if (uiSettingsTools.settings.enableUserDefinedOrderOfDownloads &&
                appWindow.uiver === 1)
        {
            if (sortBy != AbstractDownloadsUi.DownloadsSortByOrder)
                setSortByAndAsc(AbstractDownloadsUi.DownloadsSortByOrder, false);
        }
        else
        {
            if (sortBy == AbstractDownloadsUi.DownloadsSortByOrder)
                setSortByAndAsc(AbstractDownloadsUi.DownloadsSortByCreationTime, false);
        }
    }

    Connections {
        target: uiSettingsTools.settings
        onEnableUserDefinedOrderOfDownloadsChanged: applyEnableUserDefinedOrderOfDownloads()
    }
}
