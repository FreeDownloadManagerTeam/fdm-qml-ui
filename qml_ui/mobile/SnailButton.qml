import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.4
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.dmcoresettings 1.0
import org.freedownloadmanager.fdm.tum 1.0

RoundButton
{
    property int prevTum: TrafficUsageMode.High
    property bool active: App.settings.tum.currentMode == TrafficUsageMode.Snail

    width: 58
    height: 58
    radius: Math.round(width/2)

    Material.elevation: 0
    Material.background: active ? appWindow.theme.snailButtonActiveColor : appWindow.theme.snailButtonInactiveColor
    display: AbstractButton.IconOnly

    icon.source: "../images/mobile/snail.png"
    icon.width: 20
    icon.height: 20
    icon.color: "#fff"

    onClicked: {
        if (App.ready) {
            if (App.settings.tum.currentMode == TrafficUsageMode.Snail) {
                App.settings.tum.currentMode = prevTum;
            } else {
                prevTum = App.settings.tum.currentMode;
                App.settings.tum.currentMode = TrafficUsageMode.Snail;
            }
        }
    }
}
