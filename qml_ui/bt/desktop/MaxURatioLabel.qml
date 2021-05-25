import QtQuick 2.10
import org.freedownloadmanager.fdm 1.0
import "../../desktop/SettingsPage"

Rectangle {
    anchors.fill: parent
    color: "transparent"
    SettingsGridLabel {
        width: parent.width
        anchors.verticalCenter: parent.verticalCenter
        text: App.my_BT_qsTranslate("SettingsPage", "Stop seeding at ratio") + App.loc.emptyString
        wrapMode: Text.Wrap
    }
}
