import QtQuick 2.12
import QtQuick.Controls 2.12
import org.freedownloadmanager.fdm 1.0

ListView
{
    model: App.plugins.model

    delegate: PluginsViewItem {
        width: parent.width
    }

    spacing: 20*appWindow.zoom
}
