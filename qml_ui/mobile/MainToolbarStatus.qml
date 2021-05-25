import QtQuick 2.0
import org.freedownloadmanager.fdm 1.0
import "BaseElements"

ModeButton {
    anchors.horizontalCenter: parent.horizontalCenter
    currentTumMode: App.settings.tum.currentMode
    visible: !tumModeDialog.opened
    onNoticeChanged: { if (notice) tumModeDialog.close();}
}
