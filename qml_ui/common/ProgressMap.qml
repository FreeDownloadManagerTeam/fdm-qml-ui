import QtQuick 2.10
import org.freedownloadmanager.fdm 1.0
import CppControls 1.0 as CppControls

Item {

    id: root

    anchors.fill: parent

    property var downloadId
    property double zoom: 1.0

    CppControls.ProgressMap
    {
        property var mapObj: App.downloads.infos.info(root.downloadId).progressMap(columnsCount*rowsCount)
        anchors.fill: parent
        map: mapObj.map
        filledSquareBorderColor: appWindow.uiver === 1 ? appWindow.theme.progressMapFillBorder : "transparent"
        filledSquareColor: appWindow.uiver === 1 ? appWindow.theme.progressMapFillBackground : appWindow.theme_v2.bg700
        emptySquareBorderColor: appWindow.uiver === 1 ? appWindow.theme.progressMapClearBorder : "transparent"
        emptySquareColor: appWindow.uiver === 1 ? appWindow.theme.background : appWindow.theme_v2.bg400
        squareSize: 8*root.zoom
        squareSpacing: 2*root.zoom
        squareRadius: appWindow.uiver === 1 ? 0 : 2*root.zoom
        justifyH: appWindow.uiver === 1
        justifyV: justifyH
    }
}
