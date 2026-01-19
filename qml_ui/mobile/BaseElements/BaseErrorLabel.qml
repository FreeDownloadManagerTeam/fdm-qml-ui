import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import org.freedownloadmanager.fdm
import "../../common"

BaseBaseErrorLabel
{
    id: root

    spacing: 3

    Image
    {
        visible: root.showIcon
        sourceSize.width: 16
        sourceSize.height: 16
        source: Qt.resolvedUrl("../../images/mobile/error.svg")
        layer {
            effect: MultiEffect {
                colorization: 1.0
                colorizationColor: appWindow.theme.errorMessage
            }
            enabled: true
        }
        Layout.alignment: Qt.AlignTop
        Layout.topMargin: 2
    }

    BaseLabel
    {
        Layout.fillWidth: true
        clip: true
        elide: Text.ElideRight
        text: root.errorText
        color: appWindow.theme.errorMessage
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: 14
        font.weight: Font.Light
        wrapMode: root.shortVersion ? Text.NoWrap : Text.WordWrap
        onLinkActivated: root.onErrorLinkActivated()
    }
}
