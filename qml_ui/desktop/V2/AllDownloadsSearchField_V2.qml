import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import "../../common"
import "../BaseElements/V2"
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
            id: searchField

            Layout.fillWidth: true

            background: Item {}
            font.family: appWindow.theme_v2.fontFamily
            font.pixelSize: appWindow.theme_v2.fontSize*appWindow.fontZoom
            font.weight: appWindow.theme_v2.fontWeight
            color: appWindow.theme_v2.textColor

            placeholderText: qsTr("Search in downloads...") + App.loc.emptyString
            placeholderTextColor: appWindow.theme_v2.placeholderTextColor

            Keys.onEscapePressed: {
                text = "";
                focus = false;
            }

            onTextChanged: downloadsViewTools.setDownloadsTitleFilter(text)
        }

        SvgImage_V2 {
            source: Qt.resolvedUrl("close.svg")
            imageColor: appWindow.theme_v2.bg600
            visible: searchField.text
            MouseAreaWithHand_V2 {
                anchors.fill: parent
                onClicked: {
                    searchField.text = "";
                    searchField.forceActiveFocus();
                }
            }
        }
    }
}
