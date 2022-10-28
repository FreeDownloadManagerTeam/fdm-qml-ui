import QtQuick 2.11
import org.freedownloadmanager.fdm 1.0
import "../BaseElements"

BaseContextMenu {
    id: root
    y: 50*appWindow.zoom
    signal macroSelected(string macro)

    BaseContextMenuItem {
        text: qsTr("%content_type% - content type (e.g. \"Music\")") + App.loc.emptyString
        onTriggered: macroSelected("%content_type%")
    }

    BaseContextMenuItem {
        text: qsTr("%server% - name of the server (e.g. \"%1\")").arg("FreeDownloadManager.org") + App.loc.emptyString
        onTriggered: macroSelected("%server%")
    }

    BaseContextMenuItem {
        text: qsTr("%path_on_server% - path to the downloading file on the server") + App.loc.emptyString
        onTriggered: macroSelected("%path_on_server%")
    }

    BaseContextMenuItem {
        text: qsTr("%year% - current year") + App.loc.emptyString
        onTriggered: macroSelected("%year%")
    }

    BaseContextMenuItem {
        text: qsTr("%month% - current month (number from 1 to 12)") + App.loc.emptyString
        onTriggered: macroSelected("%month%")
    }

    BaseContextMenuItem {
        text: qsTr("%day% - current day") + App.loc.emptyString
        onTriggered: macroSelected("%day%")
    }

    BaseContextMenuItem {
        text: qsTr("%date% - equivalent to %year%-%month%-%day%") + App.loc.emptyString
        onTriggered: macroSelected("%date%")
    }
}
