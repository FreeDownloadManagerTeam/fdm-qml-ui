import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "../BaseElements"

TablesHeaderItem {
    id: root
    Layout.alignment: Qt.AlignTop

    onClicked: sortClick(sortBy)

    showSortIndicator: myModel && myModel.sortBy == sortBy
    sortAscendingOrder: myModel && myModel.sortOrder == Qt.AscendingOrder

    function sortClick(sortBy)
    {
        if (myModel) {
            if (myModel.sortBy != sortBy) {
                myModel.sortBy = sortBy;
                myModel.sortOrder = Qt.AscendingOrder;
            } else {
                myModel.sortOrder = myModel.sortOrder == Qt.AscendingOrder ? Qt.DescendingOrder : Qt.AscendingOrder;
            }
        }
    }
}
