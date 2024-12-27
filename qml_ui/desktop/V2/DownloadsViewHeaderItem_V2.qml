import QtQuick
import "../BaseElements/V2"

Item
{
    property alias text: t.text
    property alias font: t.font

    implicitWidth: text ? t.implicitWidth : 0
    implicitHeight: text ? t.implicitHeight : 0

    BaseText_V2 {
        id: t
        visible: text
        anchors.verticalCenter: parent.verticalCenter
        color: appWindow.theme_v2.bg700
    }
}
