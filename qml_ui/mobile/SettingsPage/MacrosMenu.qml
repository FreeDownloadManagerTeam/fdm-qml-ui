import QtQuick 2.10
import QtQuick.Controls 2.3
import org.freedownloadmanager.fdm 1.0
import "../BaseElements"


Menu
{
    id: root

    modal: true
    dim: false

    width: 300

    signal macroSelected(string macro)

    BaseMenuItem {
        text: qsTr("%content_type% - content type (e.g. \"Music\")") + App.loc.emptyString
        onTriggered: macroSelected("%content_type%")
    }
    BaseMenuSeparator {}
    BaseMenuItem {
        text: qsTr("%server% - name of the server (e.g. \"%1\")").arg("FreeDownloadManager.org") + App.loc.emptyString
        onTriggered: macroSelected("%server%")
    }
    BaseMenuSeparator {}
    BaseMenuItem {
        text: qsTr("%path_on_server% - path to the downloading file on the server") + App.loc.emptyString
        onTriggered: macroSelected("%path_on_server%")
    }
    BaseMenuSeparator {}
    BaseMenuItem {
        text: qsTr("%year% - current year") + App.loc.emptyString
        onTriggered: macroSelected("%year%")
    }
    BaseMenuSeparator {}
    BaseMenuItem {
        text: qsTr("%month% - current month (number from 1 to 12)") + App.loc.emptyString
        onTriggered: macroSelected("%month%")
    }
    BaseMenuSeparator {}
    BaseMenuItem {
        text: qsTr("%day% - current day") + App.loc.emptyString
        onTriggered: macroSelected("%day%")
    }
    BaseMenuSeparator {}
    BaseMenuItem {
        text: qsTr("%date% - equivalent to %year%-%month%-%day%") + App.loc.emptyString
        onTriggered: macroSelected("%date%")
    }
}
