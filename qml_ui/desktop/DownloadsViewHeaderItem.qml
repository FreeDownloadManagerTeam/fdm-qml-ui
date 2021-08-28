import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "./BaseElements"

TablesHeaderItem {
    id: root
    Layout.alignment: Qt.AlignTop
    property int sortBy: -1
    property bool disableOrderTypeChange: false

    color: downloadsViewTools.downloadsParentIdFilter > -1 ? appWindow.theme.batchDownloadBackground : "transparent"

    showSortIndicator: sortBy === sortTools.sortBy
    sortAscendingOrder: sortTools.sortAscendingOrder

    onClicked: {
        if (sortBy != -1)
        {
            if (!disableOrderTypeChange || sortTools.sortBy != sortBy)
                sortTools.sortByClick(sortBy);
        }
    }

    Rectangle {
        width: parent.width
        height: 1
        anchors.top: parent.top
        color: appWindow.theme.border
    }
}
