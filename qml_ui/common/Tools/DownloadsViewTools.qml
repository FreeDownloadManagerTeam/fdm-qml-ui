import QtQuick 2.0
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.abstractdownloadsui 1.0

Item {
    property int downloadsRowsCount: 0
    property string downloadsTitleFilter
    property string lastTmpDownloadsTitleFilter
    property int downloadsTagFilter: App.downloads.model.tagIdFilter
    property string downloadsSelectedTag
    property int downloadsStatesFilter: App.downloads.model.downloadsStatesFilter
    property double downloadsParentIdFilter: App.downloads.model.parentDownloadIdFilter
    property bool emptySearchResults: downloadsRowsCount === 0 && downloadsTitleFilter.length > 0
    property bool emptyTagResults: downloadsRowsCount === 0 && downloadsTagFilter != 0
    property bool emptyActiveDownloadsList: downloadsRowsCount === 0 && downloadsStatesFilter == AbstractDownloadsUi.FilterRunning
    property bool emptyCompleteDownloadsList: downloadsRowsCount === 0 && downloadsStatesFilter == AbstractDownloadsUi.FilterFinished

    onDownloadsTagFilterChanged: filterChanged()
    onDownloadsStatesFilterChanged: filterChanged()
    onDownloadsTitleFilterChanged: filterChanged()

    signal filterChanged()

    function updateRowsCount()
    {
        downloadsRowsCount = App.downloads.model.rowCount();
    }

    function setDownloadsTitleFilter(search_str)
    {
        lastTmpDownloadsTitleFilter = search_str;
        changedTimer.restart();
    }

    function resetDownloadsTitleFilter()
    {
        lastTmpDownloadsTitleFilter = "";
        changedTimer.restart();
    }

    function setDownloadsStatesFilter(value)
    {
        resetParentDownloadIdFilter();
        resetDownloadsTagFilter();
        App.downloads.model.downloadsStatesFilter = value;
    }

    function resetDownloadsStatesFilter()
    {
        App.downloads.model.downloadsStatesFilter = 0;
    }

    function setDownloadsTagFilter(value)
    {
        tagsTools.setViewTag(value);
        downloadsSelectedTag = tagsTools.getTagName(value);

        App.downloads.model.parentDownloadIdFilter = -2;
        resetDownloadsStatesFilter();
        App.downloads.model.tagIdFilter = value;
    }

    function resetDownloadsTagFilter()
    {
        App.downloads.model.tagIdFilter = 0;
    }

    function setParentDownloadIdFilter(downloadId) {
        resetDownloadsTagFilter();
        resetDownloadsStatesFilter();
        App.downloads.model.parentDownloadIdFilter = downloadId;
    }

    function resetParentDownloadIdFilter() {
        App.downloads.model.parentDownloadIdFilter = -1;
    }
    function getParentDownloadTitle() {
        var info = App.downloads.infos.info(App.downloads.model.parentDownloadIdFilter);
        return info.title + " (" + info.childDownloadsCount + ")";
    }

    function resetFilters(){
        if (emptySearchResults) {
            resetDownloadsTitleFilter();
        } else {
            setDownloadsStatesFilter(0);
        }
    }

    Timer {
        id: changedTimer
        interval: 100;
        running: false;
        repeat: false
        onTriggered: {
            App.downloads.model.downloadsTitleFilter = lastTmpDownloadsTitleFilter;
            downloadsTitleFilter = lastTmpDownloadsTitleFilter;
            updateRowsCount()
        }
    }

    Component.onCompleted: {
        downloadsTitleFilter = App.downloads.model.downloadsTitleFilter;
        updateRowsCount()
    }

    Connections {
        target: App.downloads.model
        onModelReset: updateRowsCount()
    }
}
