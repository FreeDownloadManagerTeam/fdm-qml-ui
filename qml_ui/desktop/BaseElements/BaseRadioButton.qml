import QtQuick 2.11
import QtQuick.Controls 2.4
import "../../qt5compat"
import "../../common"

RadioButton {
    id: control
    property string textColor
    property int xOffset: 6*appWindow.zoom

    padding: 0

    indicator: WaSvgImage {
        anchors.verticalCenter: parent.verticalCenter
        x: LayoutMirroring.enabled ? control.width - width - control.xOffset : control.xOffset
        zoom: appWindow.zoom
        source: appWindow.uiver === 1 ?
                    (appWindow.theme.checkboxIconsRoot + "/blue/radio/" + (control.checked ? "checked" : "unchecked") + ".svg") :
                    Qt.resolvedUrl("V2/radio_" + (control.checked ? "checked" : "unchecked") + ".svg")
        layer {
            effect: ColorOverlay {
                color: appWindow.uiver === 1 ?
                           appWindow.theme.inactiveControl :
                           (control.enabled && control.checked ? appWindow.theme_v2.primary : appWindow.theme_v2.bg600)
            }
            enabled: appWindow.uiver === 1 ? !appWindow.active : true
        }
    }

    contentItem: BaseLabel {
        anchors.left: parent.left
        anchors.verticalCenter: control.verticalCenter
        leftPadding: qtbug.leftPadding(control.xOffset + control.indicator.width + 8*appWindow.zoom, 0)
        rightPadding: qtbug.rightPadding(control.xOffset + control.indicator.width + 8*appWindow.zoom, 0)
        text: parent.text
        color: parent.textColor ? parent.textColor : appWindow.theme.foreground
    }
}
