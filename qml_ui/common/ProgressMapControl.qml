import QtQuick 2.12
import CppControls 1.0 as CppControls

CppControls.ProgressMap
{
    id: root

    property double zoom: 1.0

    filledSquareBorderColor: appWindow.uiver === 1 ? appWindow.theme.progressMapFillBorder : "transparent"
    filledSquareColor: appWindow.uiver === 1 ? appWindow.theme.progressMapFillBackground :
                                               appWindow.theme_v2.opacityColor(appWindow.theme_v2.primary, 0.5)
    emptySquareBorderColor: appWindow.uiver === 1 ? appWindow.theme.progressMapClearBorder : "transparent"
    emptySquareColor: appWindow.uiver === 1 ? appWindow.theme.background : appWindow.theme_v2.bg400
    squareSize: 8*root.zoom
    squareSpacing: 2*root.zoom
    squareRadius: appWindow.uiver === 1 ? 0 : 2*root.zoom
    justifyH: appWindow.uiver === 1
    justifyV: justifyH
}
