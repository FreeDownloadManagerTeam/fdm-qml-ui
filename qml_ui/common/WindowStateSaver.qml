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
        property int desktopAvailableWidth
        property int desktopAvailableHeight
    }

    Component.onCompleted:
    {
        if (s.width && s.height &&
                s.desktopAvailableWidth === Screen.desktopAvailableWidth &&
                s.desktopAvailableHeight === Screen.desktopAvailableHeight)
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
        s.desktopAvailableWidth = Screen.desktopAvailableWidth;
        s.desktopAvailableHeight = Screen.desktopAvailableHeight;
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
        // I don't know if this can really happen, but just in case...
        if (!window.screen)
        {
            scheduleCheckWindowPos();
            return;
        }

        let isXinvalid = (window.x + window.width < window.screen.virtualX + 50) ||
            (window.x > window.screen.virtualX + window.screen.width - 50);

        let isYinvalid = (window.y < window.screen.virtualY) ||
            (window.y > window.screen.virtualY + window.screen.height - 50);

        /*App.log("Checking window position.");
        App.log("Window position: (" + window.x + "," + window.y + ")");
        App.log("Screen.virtualX: " + window.screen.virtualX);
        App.log("Screen.virtualY: " + window.screen.virtualY);
        App.log("Screen.width: " + window.screen.width);
        App.log("Screen.height: " + window.screen.height);
        App.log("desktopAvailableWidth: " + window.screen.desktopAvailableWidth);
        App.log("desktopAvailableHeight: " + window.screen.desktopAvailableHeight);
        App.log("X invalid: " + isXinvalid + ", Y invalid: " + isYinvalid);*/

        if (isXinvalid)
            window.x = window.screen.virtualX + Math.max(50, (window.screen.width - window.width) / 2);

        if (isYinvalid)
            window.y = window.screen.virtualY + Math.max(50, (window.screen.height - window.height) / 2);
    }
}
