import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import "../../common"
import org.freedownloadmanager.fdm 1.0

Rectangle
{
    implicitWidth: 240*appWindow.zoom
    implicitHeight: 32*appWindow.zoom

    radius: 8*appWindow.zoom
    color: appWindow.theme_v2.bg300

    RowLayout
    {
        anchors.fill: parent
        anchors.leftMargin: 4*appWindow.zoom
        anchors.rightMargin: 8*appWindow.zoom
        spacing: 4*appWindow.zoom

        WaSvgImage
        {
            source: Qt.resolvedUrl("search_icon.svg")
            zoom: appWindow.zoom
            layer.effect: ColorOverlay { color: appWindow.theme_v2.bg800 }
            layer.enabled: true
        }

        TextField
        {
            Layout.fillWidth: true

            background: Item {}
            font.family: appWindow.theme_v2.fontFamily
            font.pixelSize: appWindow.theme_v2.fontSize*appWindow.fontZoom
            font.weight: 500
            color: appWindow.theme_v2.textColor

            placeholderText: qsTr("Search in downloads...") + App.loc.emptyString
            placeholderTextColor: appWindow.theme_v2.placeholderTextColor

            Keys.onEscapePressed: {
                text = "";
                focus = false;
            }

            onTextChanged: downloadsViewTools.setDownloadsTitleFilter(text)
        }
    }
}
