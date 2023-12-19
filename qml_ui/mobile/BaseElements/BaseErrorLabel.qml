import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import org.freedownloadmanager.fdm 1.0
import "../../common"
import "../../qt5compat"

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
            effect: ColorOverlay {
                color: appWindow.theme.errorMessage
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
