import QtQuick
import QtQuick.Layouts
import org.freedownloadmanager.fdm 1.0
import "../../../common"

BaseBaseErrorLabel
{
    id: root

    spacing: 3*appWindow.zoom

    WaSvgImage
    {
        visible: root.showIcon

        zoom: appWindow.zoom
        source: appWindow.theme.elementsIconsRoot + "/exclamation.svg"

        Layout.alignment: Qt.AlignVCenter
        Layout.topMargin: 2*appWindow.zoom + (appWindow.zoom2 < 0.9 ? -1 : appWindow.zoom2 > 1.3 ? 1 : 0)
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
            enabled: parent.truncated

            propagateComposedEvents: true
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor

            onClicked : function (mouse) {mouse.accepted = false;}
            onPressed: function (mouse) {mouse.accepted = false;}

            BaseToolTip_V2
            {
                text: root.errorText
                visible: parent.containsMouse
            }
        }
    }
}
