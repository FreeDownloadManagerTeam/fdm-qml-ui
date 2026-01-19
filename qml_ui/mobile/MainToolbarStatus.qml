import QtQuick
import org.freedownloadmanager.fdm
import "BaseElements"

ModeButton {
    anchors.horizontalCenter: parent.horizontalCenter
    currentTumMode: App.settings.tum.currentMode
    visible: !tumModeDialog.opened
    onNoticeChanged: { if (notice) tumModeDialog.close();}
}
