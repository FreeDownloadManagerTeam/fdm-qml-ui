import QtQuick 2.10
import QtQuick.Controls 2.3
import "./BaseElements"
import "../qt5compat"
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.abstractdownloadsui 1.0

Rectangle {
    id: root
    width: parent.width - 10
    height: 34*appWindow.fontZoom
    clip: true
    color: "transparent"
    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter

    //filters
    Rectangle {
        anchors.left: parent.left
        anchors.right: batchDownloadMarker.left
        anchors.top: parent.top
        anchors.topMargin: 8*appWindow.fontZoom
        height: 18*appWindow.fontZoom
        color: "transparent"

        Row {
            height: parent.height
            spacing: 8*appWindow.fontZoom

            Row {
                id: statesFilters
                height: parent.height
                spacing: 8*appWindow.fontZoom

                onWidthChanged: calculateTagsWidth()

                MainFilterButton {
                    cnt: App.downloads.tracker.totalDownloadsCount
                    text: qsTr("All") + App.loc.emptyString + (cnt > 0 ? " (%1)".arg(cnt) : "")
                    value: 0
                }

                BaseFilterButton {
                    readonly property int cnt: App.downloads.tracker.missingFilesDownloadsCount
                    visible: cnt > 0 && downloadsWithMissingFilesTools.autoRemoveDownloads
                    text: qsTr("Missing Files") + App.loc.emptyString + (cnt > 0 ? " (%1)".arg(cnt) : "")
                    value: AbstractDownloadsUi.MffAcceptMissingFiles
                    selected: downloadsWithMissingFilesTools.missingFilesFilter == value
                    onClicked: downloadsViewTools.setMissingFilesFilter(value)
                    onCntChanged: {
                        if (!cnt && downloadsWithMissingFilesTools.missingFilesFilter == value)
                            downloadsViewTools.resetAllFilters();
                    }
                }

                MainFilterButton {
                    cnt: App.downloads.tracker.runningDownloadsCount
                    text: qsTr("Active") + App.loc.emptyString + (cnt > 0 ? " (%1)".arg(cnt) : "")
                    value: AbstractDownloadsUi.FilterRunning
                }

                MainFilterButton {
                    cnt: App.downloads.tracker.finishedDownloadsCount
                    text: qsTr("Completed") + App.loc.emptyString + (cnt > 0 ? " (%1)".arg(cnt) : "")
                    value: AbstractDownloadsUi.FilterFinished
                }

                MainFilterButton {
                    visible: cnt > 0
                    cnt: App.downloads.tracker.nonFinishedDownloadsCount
                    text: qsTr("Uncompleted") + App.loc.emptyString + (cnt > 0 ? " (%1)".arg(cnt) : "")
                    value: AbstractDownloadsUi.FilterNonFinished
                }
            }

            Repeater {
                model: tagsTools.visibleTags
                delegate: TagButton {
                    tag: modelData
                }
            }

            TagsPanelActionButton {
                id: tagPanelBtn
            }

            MessageDialog {
                id: removeTagDlg
                property int tagId
                text: qsTr("OK to remove tag?") + App.loc.emptyString
                buttons: buttonOk | buttonCancel
                onAccepted: {
                    if (App.downloads.model.tagIdFilter == tagId)
                        downloadsViewTools.resetDownloadsTagFilter();
                    tagsTools.removeTag(tagId);
                }
            }
        }
    }

    //batch download marker
    BatchDownloadTitle {
        id: batchDownloadMarker
        onVisibilityChanged: calculateTagsWidth()
    }

    Component.onCompleted: calculateTagsWidth()

    Connections {
        target: appWindow
        onWidthChanged: calculateTagsWidth()
    }

    onWidthChanged: calculateTagsWidth()

    function calculateTagsWidth() {
        tagsTools.setTagsPanelWidth(root.width - statesFilters.width - tagPanelBtn.width - statesFilters.spacing*2 - (batchDownloadMarker.visible ? batchDownloadMarker.width : 30));
    }
}
