import QtQuick
import QtQuick.Controls
import org.freedownloadmanager.fdm

ListView
{
    model: App.plugins.model

    delegate: PluginsViewItem {
        width: parent.width
    }

    spacing: 20*appWindow.zoom
}
