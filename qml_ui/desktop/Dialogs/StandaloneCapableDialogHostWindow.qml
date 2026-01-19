import QtQuick
import QtQuick.Controls
import QtQuick.Window
import org.freedownloadmanager.fdm
import CppControls 1.0 as CppControls

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

    LayoutMirroring.enabled: appWindow.LayoutMirroring.enabled
    LayoutMirroring.childrenInherit: appWindow.LayoutMirroring.childrenInherit

    Component.onCompleted: {
        x = Qt.binding(() => Screen.width / 2 - width / 2);
        y = Qt.binding(() => Screen.height / 2 - height / 2);
    }

    CppControls.WindowAppearanceInOs
    {
        darkMode: App.useDarkTheme
        titleBarBackgroundColor: App.titleBarBackgroundColor
        titleBarTextColor: App.titleBarTextColor
    }

    Timer {
        id: makeForegroundTimer
        interval: 5
        repeat: true
        onTriggered: {
            if (root.visible)
                root.setForegroundWindow(true);
            if (!root.visible || root.active)
                stop();
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
