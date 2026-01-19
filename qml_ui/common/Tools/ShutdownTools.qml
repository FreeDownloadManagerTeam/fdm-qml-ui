import QtQuick
import org.freedownloadmanager.fdm

Item {
    property var powerManagement: appWindow.supportComputerShutdown && App.powerManagement ? App.powerManagement : null
    property bool showBanner: powerManagement && powerManagement.shutdownComputerWhenDownloadsFinished && !shutdownDlg.opened

    signal shutdownCancelled()

    function cancelShutdown() {
        App.powerManagement.shutdownComputerWhenDownloadsFinished = false;
        shutdownCancelled();
    }

    function acceptShutdown(val) {
        if (powerManagement.shutdownComputerWhenDownloadsFinished) {
             App.powerManagement.shutdownAccepted(val);
        }
        App.powerManagement.shutdownComputerWhenDownloadsFinished = false;
    }

    function setShutdownType(new_option, checked) {
        if (!checked) {
            shutdownTools.cancelShutdown();
        } else {
            App.powerManagement.shutdownComputerWhenDownloadsFinished = true;
            App.powerManagement.shutdownType = new_option;
        }
    }
}
