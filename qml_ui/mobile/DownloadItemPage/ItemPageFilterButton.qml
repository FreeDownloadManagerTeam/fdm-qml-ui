import QtQuick 2.10
import QtQuick.Controls 2.3
import "../BaseElements"

BaseFilterButton {
    selected: filtersBar.filter == value
    onClicked: {
        filtersBar.filter = value;
    }
}
