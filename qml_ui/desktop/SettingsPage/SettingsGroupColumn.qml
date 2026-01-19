import QtQuick
import QtQuick.Controls

Column {
    spacing: (appWindow.uiver === 1 ? 8 : 16)*appWindow.zoom
    topPadding: (appWindow.uiver === 1 ? 20 : 16)*appWindow.zoom
    bottomPadding: 3*appWindow.zoom
}
