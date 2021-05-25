import QtQuick 2.0
import QtQuick.Controls 2.4
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.knownwebbrowsers 1.0
import "../BaseElements"

CustomButton {
    id: btn

    property var browser

    enabled: App.integration.isBrowserInstalled(browser.id)
    width: browser.id == KnownWebBrowsers.Chrome ? 210 : 190
    height: 44

    Image {
        id: img
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 8
        sourceSize.width: 28
        sourceSize.height: 28
        source: browser.icon
    }

    BaseLabel {
        padding: 8
        anchors.left: img.right
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        font.pixelSize: 12
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
