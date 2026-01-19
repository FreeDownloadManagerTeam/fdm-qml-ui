import QtQuick
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import "../../../common"

BaseBaseErrorLabel
{
    id: root

    property alias containsMouse: ma.containsMouse

    spacing: 3*appWindow.zoom

    SvgImage_V2
    {
        visible: root.showIcon
        source: Qt.resolvedUrl("triangle_alert.svg")
        imageColor: appWindow.theme_v2.danger
    }

    BaseText_V2
    {
        id: errorLabel

        text: root.errorText
        elide: Text.ElideRight

        Layout.alignment: Qt.AlignVCenter
        Layout.fillWidth: true

        clip: true

        color: appWindow.theme_v2.danger

        wrapMode: root.shortVersion ? Text.NoWrap : Text.WordWrap

        onLinkActivated: root.onErrorLinkActivated()

        MouseArea
        {
            id: ma
            enabled: parent.truncated
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.NoButton

            BaseToolTip_V2
            {
                text: root.errorText
                visible: parent.containsMouse
            }
        }
    }
}
