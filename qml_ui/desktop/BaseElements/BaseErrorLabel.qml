import QtQuick 2.12
import QtQuick.Layouts 1.12
import org.freedownloadmanager.fdm 1.0
import "../../common"

BaseBaseErrorLabel
{
    id: root

    spacing: 3*appWindow.zoom

    Item
    {
        visible: root.showIcon

        Layout.alignment: Qt.AlignTop
        Layout.topMargin: 2*appWindow.zoom + (appWindow.zoom2 < 0.9 ? -1 : appWindow.zoom2 > 1.3 ? 1 : 0)

        clip: true

        implicitWidth: 17*appWindow.zoom
        implicitHeight: 15*appWindow.zoom

        WaSvgImage
        {
            zoom: appWindow.zoom
            x: -41*zoom
            y: -269*zoom
            source: appWindow.theme.elementsIcons
        }
    }

    BaseLabel
    {
        id: errorLabel

        text: root.errorText
        elide: Text.ElideRight

        Layout.fillWidth: true

        clip: true

        color: appWindow.theme.errorMessage

        font.pixelSize: (appWindow.compactView ? 12 : 13)*appWindow.fontZoom

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

            BaseToolTip
            {
                text: root.errorText
                visible: parent.containsMouse
            }
        }
    }
}
