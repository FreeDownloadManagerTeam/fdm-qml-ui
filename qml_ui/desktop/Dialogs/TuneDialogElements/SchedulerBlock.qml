import QtQuick 2.0
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0
import "../../BaseElements"

Rectangle {
    Layout.fillWidth: true
    color: appWindow.theme.background
    border.width: 1
    border.color: appWindow.theme.border

    Scheduler {
        id: scheduler
        anchors.fill: parent
        anchors.margins: 10
    }

    function initialization() {
        scheduler.initialization();
    }

    function complete() {
        scheduler.complete();
    }
}
