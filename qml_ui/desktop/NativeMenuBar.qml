import QtQuick 2.11
import Qt.labs.platform 1.0 as QtLabs
import org.freedownloadmanager.fdm 1.0

QtLabs.MenuBar {
    QtLabs.Menu {
        QtLabs.MenuItem {
            visible: appWindow.updateSupported
            text: qsTr("Check for Updates...") + App.loc.emptyString
            role: QtLabs.MenuItem.ApplicationSpecificRole
            onTriggered: {
                if (!appWindow.canShowSettingsPage()) {
                    stackView.pop();
                }
                appWindow.nativeMenuItemTriggered()
                appWindow.checkUpdates()
            }
        }
        QtLabs.MenuItem {
            role: QtLabs.MenuItem.AboutRole
            onTriggered: {
                appWindow.nativeMenuItemTriggered()
                aboutDlg.open()
            }
        }
        QtLabs.MenuItem {
            text: qsTr("Preferences...") + App.loc.emptyString
            role: QtLabs.MenuItem.PreferencesRole
            onTriggered: {
                appWindow.nativeMenuItemTriggered();
                appWindow.openSettings()
            }
        }
        QtLabs.MenuItem {
            text: qsTr("Quit") + App.loc.emptyString
            role: QtLabs.MenuItem.QuitRole
            onTriggered: App.quit();
        }
    }

    QtLabs.Menu {
        title: qsTr("&File") + App.loc.emptyString

        QtLabs.MenuItem {
            text: qsTr("Add &new download") + App.loc.emptyString
            shortcut: StandardKey.New
            onTriggered: {
                appWindow.nativeMenuItemTriggered();
                buildDownloadDlg.newDownload();
            }
        }
    }

    QtLabs.Menu {
        title: qsTr("&Edit")
        type: QtLabs.Menu.EditMenu

        QtLabs.MenuItem {
            text: qsTr("&Copy")
            shortcut: StandardKey.Copy
            onTriggered: {
                appWindow.nativeMenuItemTriggered();
                selectedDownloadsTools.copyCurrentUrl()
            }
        }
        QtLabs.MenuItem {
            text: qsTr("&Paste")
            shortcut: StandardKey.Paste
            onTriggered: {
                appWindow.nativeMenuItemTriggered();
                buildDownloadDlg.newDownload();
            }
        }
    }

    QtLabs.Menu {
        title: qsTr("Downloads") + App.loc.emptyString

        QtLabs.MenuItem {
            text: qsTr("Start selected") + App.loc.emptyString
            onTriggered: {
                appWindow.nativeMenuItemTriggered();
                selectedDownloadsTools.startCheckedDownloads()
            }
        }
        QtLabs.MenuItem {
            text: qsTr("Pause selected") + App.loc.emptyString
            onTriggered: {
                appWindow.nativeMenuItemTriggered();
                selectedDownloadsTools.stopCheckedDownloads()
            }
        }
        QtLabs.MenuItem {
            text: qsTr("Restart selected") + App.loc.emptyString
            onTriggered: {
                appWindow.nativeMenuItemTriggered();
                selectedDownloadsTools.restartCheckedDownloads();
            }
        }
        QtLabs.MenuSeparator {}
        QtLabs.MenuItem {
            text: qsTr("Remove from List") + App.loc.emptyString
            onTriggered: {
                appWindow.nativeMenuItemTriggered();
                selectedDownloadsTools.removeCheckedFromList()
            }
            shortcut: StandardKey.Delete
        }
    }

    QtLabs.Menu {
        title: qsTr("Help") + App.loc.emptyString

        QtLabs.MenuItem {
            text: qsTr("Contact Support") + App.loc.emptyString
            onTriggered: {
                appWindow.nativeMenuItemTriggered();
                Qt.openUrlExternally('https://www.freedownloadmanager.org/support.htm?' + App.serverCommonGetParameters)
            }
        }
    }
}
