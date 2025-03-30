import QtQuick 2.10
import org.freedownloadmanager.fdm 1.0

Item {

    id: root

    anchors.fill: parent

    property var downloadId
    property double zoom: 1.0

    ProgressMapControl
    {
        property var mapObj: App.downloads.infos.info(root.downloadId).progressMap(columnsCount*rowsCount)
        anchors.fill: parent
        map: mapObj.map
        zoom: root.zoom
    }
}
