import QtQuick
import Qt5Compat.GraphicalEffects
import org.freedownloadmanager.fdm
import "../../common"
import "../BaseElements/V2"

WaSvgImage
{
    property var buttonType
    property string moduleUid: ""

    zoom: appWindow.zoom

    opacity: enabled ? 1 : 0.3

    source: Qt.resolvedUrl(
                buttonType === "showInFolder" ? "single_download_folder.svg" :
                buttonType === "pause" ? "single_download_pause.svg" :
                buttonType === "start" ? "single_download_play.svg" :
                buttonType === "scheduler" ? "single_download_scheduler.svg" :
                buttonType === "restart" ? "single_download_error.svg" :
                "")

    layer.enabled: true
    layer.effect: ColorOverlay {
        color: buttonType === "showInFolder" ? appWindow.theme_v2.primary :
               buttonType === "restart" ? appWindow.theme_v2.danger :
               appWindow.theme_v2.textColor
    }

    MouseAreaWithHand_V2 {
        visible: buttonType !== "showInFolder" || !App.rc.client.active
        anchors.fill: parent
        onClicked: {
            downloadsItemTools.doAction()
        }
    }
}
