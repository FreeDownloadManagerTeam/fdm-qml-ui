import QtQuick 2.0
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0
import "../../BaseElements"

Rectangle {
    color: appWindow.theme.background
    border.width: 1*appWindow.zoom
    border.color: appWindow.theme.border

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
