import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.4
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.dmcoresettings 1.0
import org.freedownloadmanager.fdm.tum 1.0

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
