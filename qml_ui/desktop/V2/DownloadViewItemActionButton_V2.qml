import QtQuick
import QtQuick.Effects
import org.freedownloadmanager.fdm
import "../../common"
import "../BaseElements/V2"

WaSvgImage
{
    property var buttonType
    property string moduleUid: ""
    property bool hasChildren: false

    readonly property bool canDoAction: !App.rc.client.active || buttonType !== "showInFolder"

    zoom: appWindow.zoom

    opacity: enabled ? 1 : 0.3

    source: Qt.resolvedUrl(
                buttonType === "showInFolder" ? (hasChildren ? "batch_download_icon.svg" : (Qt.platform.os === "osx" ? "single_download_folder_mac.svg" : "single_download_folder.svg")) :
                buttonType === "pause" ? "single_download_pause.svg" :
                buttonType === "start" ? "single_download_play.svg" :
                buttonType === "scheduler" ? "single_download_scheduler.svg" :
                buttonType === "restart" ? "single_download_error.svg" :
                "")

    layer.enabled: true
    layer.effect: MultiEffect {
        colorization: 1.0
        colorizationColor: buttonType === "showInFolder" ? appWindow.theme_v2.primary :
               buttonType === "restart" ? appWindow.theme_v2.danger :
               appWindow.theme_v2.textColor
    }

    MouseAreaWithHand_V2 {
        visible: canDoAction
        anchors.fill: parent
        onClicked: {
            downloadsItemTools.doAction()
        }
    }
}
