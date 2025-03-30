import QtQuick
import "../BaseElements/V2"
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.abstractdownloadsui

ToolbarFlatButton_V2
{
    title: missingFilesFilterItem.isActive ? missingFilesFilterItem.text :
           downloadsViewTools.downloadsTagFilter ? tagText(downloadsViewTools.downloadsTagFilter) + App.loc.emptyString :
           mode2name(App.downloads.model.downloadsStatesFilter) + App.loc.emptyString

    iconSource: Qt.resolvedUrl("filter_icon.svg")

    dropDownMenu: BaseMenu_V2
    {
        AllDownloadsFilterModeMenuItem {
            mode: 0
        }

        BaseMenuItem_V2 {
            id: missingFilesFilterItem

            readonly property int value: AbstractDownloadsUi.MffAcceptMissingFiles
            readonly property bool isActive: downloadsWithMissingFilesTools.missingFilesFilter == value
            readonly property int cnt: App.downloads.tracker.missingFilesDownloadsCount

            text: qsTr("Missing Files") + App.loc.emptyString

            visible: cnt > 0

            onClicked: downloadsViewTools.setMissingFilesFilter(value)

            onCntChanged: {
                if (!cnt && isActive)
                    downloadsViewTools.resetAllFilters();
            }
        }

        AllDownloadsFilterModeMenuItem {
            mode: AbstractDownloadsUi.FilterRunning
        }

        AllDownloadsFilterModeMenuItem {
            mode: AbstractDownloadsUi.FilterFinished
        }

        AllDownloadsFilterModeMenuItem {
            mode: AbstractDownloadsUi.FilterNonFinished
            visible: App.downloads.tracker.nonFinishedDownloadsCount > 0
        }

        BaseMenuSeparator_V2 {
            visible: tagsTools.nonHiddenSystemTags.length > 0
        }
        Repeater {
            model: tagsTools.nonHiddenSystemTags
            AllDownloadsFilterTagMenuItem {
                tag: modelData
            }
        }

        BaseMenuSeparator_V2 {
            visible: tagsTools.customTags.length > 0
        }
        Repeater {
            model: tagsTools.customTags
            AllDownloadsFilterTagMenuItem {
                tag: modelData
            }
        }
    }

    function mode2name(m)
    {
        switch(m)
        {
        case 0:
            return qsTr("All files");
        case AbstractDownloadsUi.FilterRunning:
            return qsTr("Active");
        case AbstractDownloadsUi.FilterFinished:
            return qsTr("Completed");
        case AbstractDownloadsUi.FilterNonFinished:
            return qsTr("Uncompleted");
        }
    }

    function tagText(tagId)
    {
        let tag = App.downloads.tags.tag(tagId);
        return tag.readOnly ? App.loc.tr(tag.name) : tag.name;
    }
}
