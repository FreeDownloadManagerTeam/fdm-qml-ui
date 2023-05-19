import QtQuick 2.12
import "../../common"
import "../BaseElements"
import org.freedownloadmanager.fdm 1.0

Row {

    spacing: 5*appWindow.zoom

    WaSvgImage {
        source: appWindow.theme.attentionImg
        zoom: Math.max(1.0, appWindow.zoom*0.8)
        anchors.verticalCenter: parent.verticalCenter
    }

    BaseHandCursorLabel {
        text: qsTr("<a href='#'>Restart is required</a>") + App.loc.emptyString
        font.pixelSize: 11*appWindow.fontZoom
        anchors.verticalCenter: parent.verticalCenter
        onLinkActivated: App.restart()
    }
}
