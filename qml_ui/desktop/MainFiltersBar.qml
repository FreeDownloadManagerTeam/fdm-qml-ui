import QtQuick 2.10
import QtQuick.Controls 2.3
import "./BaseElements"
import "./Dialogs"
import "../qt5compat"
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.abstractdownloadsui 1.0

Rectangle {
    id: root
    width: parent.width
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
            anchors.left: parent.left
            height: parent.height
            spacing: 8*appWindow.fontZoom

            Row {
                id: statesFilters
                height: parent.height
                spacing: 8*appWindow.fontZoom

                onWidthChanged: calculateTagsWidth()

                MainFilterButton {
                    cnt: App.downloads.tracker.totalDownloadsCount
                    title: qsTr("All") + App.loc.emptyString
                    value: 0
                }

                BaseFilterButton {
                    title: qsTr("Missing Files") + App.loc.emptyString
                    cnt: App.downloads.tracker.missingFilesDownloadsCount
                    visible: cnt > 0 && downloadsWithMissingFilesTools.autoRemoveDownloads
                    value: AbstractDownloadsUi.MffAcceptMissingFiles
                    selected: downloadsWithMissingFilesTools.missingFilesFilter == value
                    onClicked: downloadsViewTools.setMissingFilesFilter(value)
                    onCntChanged: {
                        if (!cnt && downloadsWithMissingFilesTools.missingFilesFilter == value)
                            downloadsViewTools.resetAllFilters();
                    }
                }

                MainFilterButton {
                    title: qsTr("Active") + App.loc.emptyString
                    cnt: App.downloads.tracker.runningDownloadsCount
                    value: AbstractDownloadsUi.FilterRunning
                }

                MainFilterButton {
                    title: qsTr("Completed") + App.loc.emptyString
                    cnt: App.downloads.tracker.finishedDownloadsCount
                    value: AbstractDownloadsUi.FilterFinished
                }

                MainFilterButton {
                    title: qsTr("Uncompleted") + App.loc.emptyString
                    cnt: App.downloads.tracker.nonFinishedDownloadsCount
                    visible: cnt > 0
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
