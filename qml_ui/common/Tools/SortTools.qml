import QtQuick 2.0
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.dmcoresettings 1.0
import org.freedownloadmanager.fdm.appsettings 1.0

Item {

    property int sortBy
    property string sortByTitle

    property int sortAscendingOrder //0 - down; 1 - up

    property var sortByValues: [1,2,3] // creation date, name, size
    property var sortByTitles: [null, "creation_date", "name", "size"]
    property var sortByFullTitles: ['', qsTr("By date") + App.loc.emptyString, qsTr("By name") + App.loc.emptyString, qsTr("By size") + App.loc.emptyString]//mobile only

    onSortByChanged: {
        sortByTitle = sortByTitles[sortBy];
    }

    //desktop only
    function sortTitleClick(title)
    {
        if (sortByTitle === title) {
            changeSortAscendingOrder()
        } else {
            var sort_id = sortByTitles.indexOf(title);
            if (sort_id > 0) {
                setSortById(sort_id);
            }
        }
    }

    //desktop only
    function changeSortAscendingOrder() {

        App.settings.app.setValue(
                    AppSettings.SortAscendingOrder,
                    App.settings.fromBool(!sortAscendingOrder));

        sortAscendingOrder = App.settings.app.value(AppSettings.SortAscendingOrder);
    }

    //desktop only
    function setSortById(sortById) {

        App.settings.app.setValue(
                    AppSettings.SortBy,
                    sortById);

        App.settings.app.setValue(
                    AppSettings.SortAscendingOrder,
                    App.settings.fromBool(true));

        sortBy = App.settings.app.value(AppSettings.SortBy);
        sortAscendingOrder = App.settings.app.value(AppSettings.SortAscendingOrder);
    }

    //mobile only
    function setSortBy(sortByVal, sortAsc) {

        App.settings.app.setValue(
                    AppSettings.SortBy,
                    sortByVal);

        App.settings.app.setValue(
                    AppSettings.SortAscendingOrder,
                    App.settings.fromBool(sortAsc));

        sortBy = App.settings.app.value(AppSettings.SortBy);
        sortAscendingOrder = App.settings.app.value(AppSettings.SortAscendingOrder);
    }

    //mobile only
    function getSortTitle(sortById)
    {

        if (sortByFullTitles[sortById]) {
            return sortByFullTitles[sortById];
        }
        return "";
    }

    function updateState()
    {
        sortBy = App.settings.app.value(AppSettings.SortBy);
        sortAscendingOrder = App.settings.app.value(AppSettings.SortAscendingOrder);
    }

    Component.onCompleted: {
        updateState();
        sortByChanged();
    }

    Connections{
        target: appWindow
        onUiReadyStateChanged: {
            updateState();
            sortByChanged();
        }
    }
}
