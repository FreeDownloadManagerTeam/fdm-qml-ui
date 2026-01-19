import QtQuick
import QtQuick.Controls
import "../BaseElements"

BaseFilterButton {
    selected: filtersBar.filter == value
    onClicked: {
        filtersBar.filter = value;
    }
}
