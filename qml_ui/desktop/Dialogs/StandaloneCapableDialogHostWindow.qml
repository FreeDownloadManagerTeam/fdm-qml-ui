import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.12
import org.freedownloadmanager.fdm 1.0

ApplicationWindow
{
    id: root

    signal closeClicked

    visible: false

    flags: Qt.Dialog

    title: App.displayName

    property var theme: appWindow.theme

    palette.highlight: theme.textHighlight
    palette.windowText: theme.foreground
    palette.window: theme.background
    palette.base: theme.background
    palette.text: theme.foreground

    Component.onCompleted: {
        x = Qt.binding(() => Screen.width / 2 - width / 2);
        y = Qt.binding(() => Screen.height / 2 - height / 2);
    }

    Timer {
        id: makeForegroundTimer
        interval: 5
        repeat: true
        onTriggered: {
            if (!root.visible || root.active) {
                stop();
                return;
            }
            root.setForegroundWindow(true);
        }
    }

    onVisibleChanged: {
        if (visible)
            makeForegroundTimer.start()
    }

    onClosing: {
        close.accepted = false;
        closeClicked();
    }

    function setForegroundWindow(force)
    {
        raise();
        requestActivate();
        if (force)
            App.forceSetWindowForeground(this);
    }
}
