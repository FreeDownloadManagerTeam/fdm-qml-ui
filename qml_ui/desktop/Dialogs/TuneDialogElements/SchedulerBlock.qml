import QtQuick 2.0
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0
import "../../BaseElements"

Rectangle {
    color: appWindow.uiver === 1 ?
               appWindow.theme.background :
               appWindow.theme_v2.dialogSpecialAreaColor
    border.width: 1*appWindow.zoom
    border.color: appWindow.uiver === 1 ?
                      appWindow.theme.border :
                      appWindow.theme_v2.outlineBorderColor
    radius: appWindow.uiver === 1 ? 0 : 8*appWindow.zoom

    implicitWidth: scheduler.implicitWidth
    implicitHeight: scheduler.implicitHeight

    Scheduler {
        id: scheduler
        anchors.fill: parent
        anchors.margins: 10*appWindow.zoom
    }

    function initialization() {
        scheduler.initialization();
    }

    function complete() {
        scheduler.complete();
    }
}
