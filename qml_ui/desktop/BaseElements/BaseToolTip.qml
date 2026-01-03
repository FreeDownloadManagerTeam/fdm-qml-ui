import QtQuick 2.0
import QtQuick.Controls 2.3
import "../../qt5compat"

ToolTip {
    id: root
    delay: Qt.styleHints.mousePressAndHoldInterval
    timeout: 12000
    property int fontSize: appWindow.uiver === 1 ?
                               13*appWindow.fontZoom :
                               appWindow.theme_v2.tooltipFontSize*appWindow.fontZoom

    contentItem: BaseLabel {
        text: root.text
        font.pixelSize: fontSize
        font.weight: appWindow.uiver === 1 ? Font.Light : appWindow.theme_v2.fontWeight
        wrapMode: Text.Wrap
        color: appWindow.uiver === 1 ?
                   appWindow.theme.toolTipText :
                   appWindow.theme_v2.tooltipTextColor
    }

    background: Item {
        RectangularGlow {
            visible: appWindow.uiver !== 1 && appWindow.theme_v2.useGlow
            anchors.fill: tooltipBackground
            color: appWindow.theme_v2.glowColor
            glowRadius: 0
            spread: 0
            cornerRadius: tooltipBackground.radius
        }
        Rectangle {
            id: tooltipBackground

            anchors.fill: parent

            color: appWindow.uiver === 1 ?
                       appWindow.theme.toolTipBackground :
                       appWindow.theme_v2.tooltipBgColor

            border.color: appWindow.uiver === 1 ?
                              appWindow.theme.toolTipBorder :
                              "transparent"

            radius: appWindow.uiver === 1 ? 0 : 4*appWindow.zoom
        }
    }
}
