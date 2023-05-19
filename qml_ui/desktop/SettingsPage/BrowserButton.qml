import QtQuick 2.0
import QtQuick.Controls 2.4
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.knownwebbrowsers 1.0
import "../BaseElements"
import "../../common"

CustomButton {
    id: btn

    property var browser

    enabled: App.integration.isBrowserInstalled(browser.id)
    width: 30*appWindow.zoom+(browser.id == KnownWebBrowsers.Chrome ? 180 : 160)*appWindow.fontZoom
    height: 20*appWindow.zoom+24*appWindow.fontZoom

    WaSvgImage {
        id: img
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 8*appWindow.zoom
        width: 28*zoom
        height: 28*zoom
        source: browser.icon
        zoom: appWindow.zoom
    }

    BaseLabel {
        padding: 8*appWindow.zoom
        anchors.left: img.right
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        font.pixelSize: 12*appWindow.fontZoom
        text: (parent.enabled ? qsTr("Download %1 extension").arg(browser.title) : qsTr("%1 is not installed").arg(browser.title)) + App.loc.emptyString
        wrapMode: Label.WordWrap
        color: btn.isPressed ? btn.secondaryTextColor : btn.primaryTextColor
    }

    onClicked: {
       if (enabled) {
           App.integration.installBrowserExtension(browser.id);
           extensionClicked();
       }
    }
}
