import QtQuick
import "../BaseElements/V2"
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.abstractdownloadsui 1.0

ToolbarFlatButton_V2
{
    title: mode2name(sortTools.sortBy, sortTools.sortAscendingOrder) + App.loc.emptyString

    iconSource: Qt.resolvedUrl("sort_icon.svg")

    dropDownMenu: BaseMenu_V2
    {
        AllDownloadsSortModeMenuItem {
            sortBy: AbstractDownloadsUi.DownloadsSortByCreationTime
            acsending: false
        }
        AllDownloadsSortModeMenuItem {
            sortBy: AbstractDownloadsUi.DownloadsSortByCreationTime
            acsending: true
        }
        AllDownloadsSortModeMenuItem {
            sortBy: AbstractDownloadsUi.DownloadsSortByTitle
            acsending: true
        }
        AllDownloadsSortModeMenuItem {
            sortBy: AbstractDownloadsUi.DownloadsSortByTitle
            acsending: false
        }
        AllDownloadsSortModeMenuItem {
            sortBy: AbstractDownloadsUi.DownloadsSortBySize
            acsending: false
        }
        AllDownloadsSortModeMenuItem {
            sortBy: AbstractDownloadsUi.DownloadsSortBySize
            acsending: true
        }
        AllDownloadsSortModeMenuItem {
            sortBy: AbstractDownloadsUi.DownloadsSortByStatus
            acsending: true
        }
        AllDownloadsSortModeMenuItem {
            sortBy: AbstractDownloadsUi.DownloadsSortByStatus
            acsending: false
        }
    }

    function mode2name(m, a)
    {
        switch(m)
        {
        case AbstractDownloadsUi.DownloadsSortByCreationTime:
            return a ? qsTr("Old") : qsTr("Newest");
        case AbstractDownloadsUi.DownloadsSortByTitle:
            //: sort by title mode
            return a ? qsTr("A-Z") : qsTr("Z-A");
        case AbstractDownloadsUi.DownloadsSortBySize:
            return a ? qsTr("By size: small") : qsTr("By size: large");
        case AbstractDownloadsUi.DownloadsSortByStatus:
            return a ? qsTr("By status: ascending") : qsTr("By status: descending")
        }
    }
}
