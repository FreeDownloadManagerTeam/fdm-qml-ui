import QtQuick 2.10
import QtQuick.Controls 2.3

Column {
    spacing: (appWindow.uiver === 1 ? 8 : 16)*appWindow.zoom
    topPadding: (appWindow.uiver === 1 ? 20 : 16)*appWindow.zoom
    bottomPadding: 3*appWindow.zoom
}
