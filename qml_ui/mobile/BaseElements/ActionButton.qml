import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.4
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.appfeatures 1.0

RoundButton {
    property bool locked: false
    width: 38
    height: 38
    radius: width / 2
    flat: true
    display: AbstractButton.IconOnly
    padding: 0
    Material.elevation: 0
    Material.background: downloadsItemTools.buttonType === "showInFolder" ? appWindow.theme.actionBtnFolder :
                         downloadsItemTools.buttonType === "start" ? appWindow.theme.actionBtnStart :
                         downloadsItemTools.buttonType === "pause" ? appWindow.theme.actionBtnPause :
                         downloadsItemTools.buttonType === "restart" ? appWindow.theme.actionBtnRestart :
                         downloadsItemTools.buttonType === "scheduler" ? appWindow.theme.actionBtnStart : ""


    icon.source: downloadsItemTools.buttonType === "showInFolder" ? Qt.resolvedUrl("../../images/mobile/open_folder.svg") :
                 downloadsItemTools.buttonType === "start" ? Qt.resolvedUrl("../../images/mobile/play.svg") :
                 downloadsItemTools.buttonType === "pause" ? Qt.resolvedUrl("../../images/mobile/pause.svg") :
                 downloadsItemTools.buttonType === "restart" ? Qt.resolvedUrl("../../images/mobile/repeat.svg") :
                 downloadsItemTools.buttonType === "scheduler" ? Qt.resolvedUrl("../../images/mobile/scheduler.svg") : ""

    icon.color: appWindow.theme.foreground
    icon.height: 16
    icon.width: 16
    opacity: locked ? 0.4 : 1

    onClicked: {
        if (!locked) {
            if (downloadsItemTools.buttonType === "showInFolder" && !App.features.hasFeature(AppFeatures.OpenFolder)) {
                fileManagerSupportDlg.open();
            }
            else {
                downloadsItemTools.doAction()
            }
        }
    }
}
