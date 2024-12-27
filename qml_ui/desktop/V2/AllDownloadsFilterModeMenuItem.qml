import QtQuick
import "../BaseElements/V2"
import org.freedownloadmanager.fdm 1.0

BaseMenuItem_V2
{
    property int mode: 0

    text: mode2name(mode) + App.loc.emptyString

    onClicked: downloadsViewTools.setDownloadsStatesFilter(mode)
}
