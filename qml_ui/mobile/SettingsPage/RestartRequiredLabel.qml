import QtQuick
import "../../common"
import "../BaseElements"
import org.freedownloadmanager.fdm

Row {

    spacing: 5

    WaSvgImage {
        source: appWindow.theme.attentionImg
        anchors.verticalCenter: parent.verticalCenter
    }

    BaseLabel {
        text: qsTr("<a href='#'>Restart is required</a>") + App.loc.emptyString
        //font.pixelSize: 11*appWindow.fontZoom
        anchors.verticalCenter: parent.verticalCenter
        onLinkActivated: App.restart()
    }
}
