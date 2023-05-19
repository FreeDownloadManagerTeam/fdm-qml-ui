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
        filledSquareBorderColor: appWindow.theme.progressMapFillBorder
        filledSquareColor: appWindow.theme.progressMapFillBackground
        emptySquareBorderColor: appWindow.theme.progressMapClearBorder
        emptySquareColor: appWindow.theme.background
        squareSize: 8*root.zoom
        squareSpacing: 3*root.zoom
    }
}
