import QtQuick 2.0
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.qtupdate 1.0
import org.freedownloadmanager.fdm.appsettings 1.0

Item {

    id: root

    property variant updater: App.updates.wholeApp
    property var state: updater.state
    property var stage: updater.stage
    property int progress: updater.progress
    property string lastErrorDescription: updater.lastErrorDescription ? updater.lastErrorDescription : ''
    property bool restartRequired: updater.restartRequired ? updater.restartRequired : false
    property bool updatesAvailable: updater.updatesAvailable ? updater.updatesAvailable : false
    property bool arrowsRotate: (updater.state == QtUpdate.InProgress)
    property string version: updater.version
    property string changelog: updater.changelog

    property bool showDialog: false
    property bool showArrows: false

    Connections {
        target:  appWindow
        onUpdateDlgClosed: {showDialog = false}
        onUpdateDlgOpened: {showArrows = true; showDialog = true;}
    }

    function toggleDialog() {
        if (showDialog) {
            appWindow.updateDlgClosed();
        } else {
            appWindow.updateDlgOpened();
        }
    }

    function checkForUpdates() {
        appWindow.updateDlgOpened();
        updater.checkForUpdates();
    }

    function cancel() {
        showArrows = false;
        appWindow.updateDlgClosed();
        updater.reset();
    }

    function ok() {
        showArrows = false;
        appWindow.updateDlgClosed();
    }

    function relaunch() {
        showArrows = false;
        appWindow.updateDlgClosed();
        updater.performRestart();
    }

    function openWhatsNewDialog()
    {
        appWindow.updateDlgClosed();
        appWindow.openWhatsNewDialog(root.version, root.changelog);
    }

    Connections {
        target: updater
        onStateChanged: {
            if (updater.initiator == QtUpdate.InitiatorAutomatic) {
                if (!App.settings.toBool(App.settings.app.value(AppSettings.InstallUpdatesAutomatically))) {
                    if (updateTools.state == QtUpdate.Finished && updateTools.updatesAvailable) {
                        appWindow.updateDlgOpened();
                    }
                } else {
                    if (updateTools.state == QtUpdate.Finished && updateTools.restartRequired) {
                        appWindow.updateDlgOpened();
                    }
                }
            } else {
                if (updateTools.stage == QtUpdate.CheckUpdates &&
                        updateTools.state == QtUpdate.Finished &&
                        updateTools.updatesAvailable &&
                        root.changelog.length > 0) {
                    openWhatsNewDialog();
                }
                //install updates automatically after download, if InitiatorUser
                else if (updateTools.stage == QtUpdate.PostDownloadCheck && updateTools.state == QtUpdate.Finished) {
                    updateTools.updater.installUpdates();
                }
                else if (updateTools.stage == QtUpdate.InstallUpdates &&
                        updateTools.state == QtUpdate.Finished &&
                        !App.quitRequiresConfirmation &&
                        updateTools.restartRequired)
                {
                    relaunch();
                }
            }
        }
    }

    Connections {
        target: appWindow
        onDoDownloadUpdate: {
            updateTools.updater.downloadUpdates();
            appWindow.updateDlgOpened();
        }
    }
}
