import QtQuick
import QtQuick.Controls
import "../BaseElements"
import org.freedownloadmanager.fdm.abstractdownloadsui 

BaseFilterButton {
    selected: !downloadsViewTools.downloadsTagFilter &&
              downloadsViewTools.downloadsParentIdFilter == -1 &&
              downloadsViewTools.downloadsStatesFilter == value &&
              downloadsWithMissingFilesTools.missingFilesFilter != AbstractDownloadsUi.MffAcceptMissingFiles
    onClicked: downloadsViewTools.setDownloadsStatesFilter(value)
}
