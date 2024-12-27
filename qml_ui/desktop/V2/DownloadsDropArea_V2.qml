import QtQuick
import QtQuick.Layouts
import "../BaseElements/V2"
import org.freedownloadmanager.fdm

Item
{
    property int visibleAreaTopMargin: 0

    DottedBorder_V2
    {
        anchors.fill: parent
        anchors.topMargin: visibleAreaTopMargin

        RowLayout
        {
            anchors.centerIn: parent

            spacing: 4*appWindow.zoom

            SvgImage_V2
            {
                imageColor: appWindow.theme_v2.bg400
                source: Qt.resolvedUrl("mouse_drop.svg")
            }

            BaseText_V2
            {
                text: App.cfg.ddUrlText + App.loc.emptyString
                color: appWindow.theme_v2.bg500
                font.pixelSize: 16*appWindow.fontZoom
            }
        }
    }

    DropArea {
        enabled: !appWindow.disableDrop
        anchors.fill: parent
        onDropped: {
            if (!drag.source)
                App.onDropped(drop)
        }
    }
}
