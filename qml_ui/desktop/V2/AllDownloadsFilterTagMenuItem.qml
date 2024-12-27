import QtQuick
import "../BaseElements/V2"
import org.freedownloadmanager.fdm

BaseMenuItem_V2
{
    property var tag

    text: tag.readOnly ? (App.loc.tr(tag.name) + App.loc.emptyString) : tag.name

    onClicked: downloadsViewTools.setDownloadsTagFilter(tag.id)
}
