import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.dmcoresettings
import org.freedownloadmanager.fdm.tum

RoundButton
{
    width: 58
    height: 58
    radius: Math.round(width/2)

    Material.elevation: 0
    Material.background: snailTools.isSnail ? appWindow.theme.snailButtonActiveColor : appWindow.theme.snailButtonInactiveColor
    display: AbstractButton.IconOnly

    icon.source: "../images/mobile/snail.png"
    icon.width: 20
    icon.height: 20
    icon.color: "#fff"

    onClicked: snailTools.toggleSnailMode()
}
