import QtQuick
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.abstractdownloadsui 

Item {
    property int downloadsRowsCount: App.downloads.model.rowCount
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
    readonly property bool showingDownloadsWithMissingFilesOnly: App.downloads.model.missingFilesFilter == AbstractDownloadsUi.MffAcceptMissingFiles

    onDownloadsTagFilterChanged: filterChanged()
    onDownloadsStatesFilterChanged: filterChanged()
    onDownloadsTitleFilterChanged: filterChanged()

    signal filterChanged()

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
        downloadsWithMissingFilesTools.resetFilter();
        App.downloads.model.downloadsStatesFilter = value;
        // work around of bug losing the keyboard focus
        if (stackView.currentItem && stackView.currentItem.keyboardFocusItem)
            stackView.currentItem.keyboardFocusItem.focus = true;
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
        downloadsWithMissingFilesTools.resetFilter();
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
        return Qt.binding(function(){
            if (App.downloads.model.parentDownloadIdFilter < 0)
                return "";
            var info = App.downloads.infos.info(App.downloads.model.parentDownloadIdFilter);
            if (!info)
                return "";
            let title = info.title.replace(/\n/g, " ");
            return appWindow.uiver === 1 ?
                        (title + " (" + App.downloads.model.rowCount + ")") :
                        (title/* + " — " + qsTr("Downloads: %1").arg(App.downloads.model.rowCount) + App.loc.emptyString*/);
        });
    }

    function setMissingFilesFilter(value)
    {
        resetDownloadsStatesFilter();
        resetParentDownloadIdFilter();
        resetDownloadsTagFilter();
        downloadsWithMissingFilesTools.missingFilesFilter = value;
    }

    function resetFilters(){
        if (emptySearchResults) {
            resetDownloadsTitleFilter();
        } else {
            setDownloadsStatesFilter(0);
        }
    }

    function resetAllFilters()
    {
        resetDownloadsTitleFilter();
        resetDownloadsStatesFilter();
        resetParentDownloadIdFilter();
        resetDownloadsTagFilter();
        downloadsWithMissingFilesTools.resetFilter();
    }

    Timer {
        id: changedTimer
        interval: 100;
        running: false;
        repeat: false
        onTriggered: {
            App.downloads.model.downloadsTitleFilter = lastTmpDownloadsTitleFilter;
            downloadsTitleFilter = lastTmpDownloadsTitleFilter;
        }
    }

    Component.onCompleted: {
        downloadsTitleFilter = App.downloads.model.downloadsTitleFilter;
    }
}
