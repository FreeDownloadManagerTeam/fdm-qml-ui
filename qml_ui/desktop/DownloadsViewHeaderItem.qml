import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "./BaseElements"

TablesHeaderItem {
    id: root
    Layout.alignment: Qt.AlignTop
    property string sortOptionName

    color: downloadsViewTools.downloadsParentIdFilter > -1 ? appWindow.theme.batchDownloadBackground : "transparent"

    showSortIndicator: sortOptionName === sortTools.sortByTitle
    sortAscendingOrder: sortTools.sortAscendingOrder !== 0

    onClicked: sortTools.sortTitleClick(sortOptionName)

    Rectangle {
        width: parent.width
        height: 1
        anchors.top: parent.top
        color: appWindow.theme.border
    }
}
