import QtQuick 2.10
import QtQuick.Window 2.10
import QtQuick.Controls 2.3
import Qt.labs.settings 1.0
import org.freedownloadmanager.fdm 1.0

Item
{
    property Window window
    property string windowName: ""
    property bool setVisibleWhenCompleted: false
    property bool forceHidden: false

    Settings
    {
        id: s
        fileName: App.appqSettingsIniFilePath()
        category: windowName
        property int x
        property int y
        property int width
        property int height
        property int visibility
    }

    Component.onCompleted:
    {
        if (s.width && s.height)
        {
            window.x = s.x;
            window.y = s.y;
            window.width = s.width;
            window.height = s.height;
            if (!forceHidden)
                window.visibility = s.visibility;
            else
                window.visible = false;
            scheduleCheckWindowPos();
        }
        else
        {
            if (!forceHidden)
            {
                if (setVisibleWhenCompleted)
                    window.visible = true;
            }
            else
            {
                window.visible = false;
            }
        }
    }

    Connections
    {
        target: window
        onXChanged: saveSettingsTimer.restart()
        onYChanged: saveSettingsTimer.restart()
        onWidthChanged: saveSettingsTimer.restart()
        onHeightChanged: saveSettingsTimer.restart()
        onVisibilityChanged: saveSettingsTimer.restart()
    }

    Timer
    {
        id: saveSettingsTimer
        interval: 1000
        repeat: false
        onTriggered: saveSettings()
    }

    function saveSettings()
    {
        switch(window.visibility)
        {
        case ApplicationWindow.Windowed:
            s.x = window.x;
            s.y = window.y;
            s.width = window.width;
            s.height = window.height;
            s.visibility = window.visibility;
            break;
        case ApplicationWindow.FullScreen:
            s.visibility = window.visibility;
            break;
        case ApplicationWindow.Maximized:
            s.visibility = window.visibility;
            break;
        }
    }

    Timer
    {
        id: checkWindowPosTimer
        interval: 1000
        repeat: false
        onTriggered: checkWindowPos()
    }

    function scheduleCheckWindowPos()
    {
        checkWindowPosTimer.restart();
    }

    function checkWindowPos()
    {
        App.log("Checking window position.");
        App.log("Window position: (" + window.x + "," + window.y + ")");
        App.log("desktopAvailableWidth: " + window.screen.desktopAvailableWidth);
        App.log("desktopAvailableHeight: " + window.screen.desktopAvailableHeight);
        // Math.max(0, ...) could not be used due to bug:
        //  https://bugreports.qt.io/browse/QTBUG-85454
        if (window.x < 0 || window.x >= window.screen.desktopAvailableWidth - 50)
            window.x = Math.max(50, (window.screen.desktopAvailableWidth - window.width) / 2);
        if (window.y < 0 || window.y >= window.screen.desktopAvailableHeight - 50)
            window.y = Math.max(50, (window.screen.desktopAvailableHeight - window.height) / 2);
    }
}
