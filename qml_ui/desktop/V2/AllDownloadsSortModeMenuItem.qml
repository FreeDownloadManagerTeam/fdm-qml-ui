import QtQuick
import "../BaseElements/V2"
import org.freedownloadmanager.fdm

BaseMenuItem_V2
{
    property int sortBy: -1
    property bool acsending: true

    text: mode2name(sortBy, acsending) + App.loc.emptyString

    onClicked: sortTools.setSortByAndAsc(sortBy, acsending)
}
