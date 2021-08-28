import QtQuick 2.0
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.dmcoresettings 1.0
import org.freedownloadmanager.fdm.appsettings 1.0
import org.freedownloadmanager.fdm.abstractdownloadsui 1.0

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
        sortBy = App.settings.app.value(AppSettings.SortBy);
        sortAscendingOrder = App.settings.toBool(App.settings.app.value(AppSettings.SortAscendingOrder));
    }

    Component.onCompleted: {
        updateState();
    }

    Connections{
        target: appWindow
        onUiReadyStateChanged: {
            updateState();
        }
    }
}
