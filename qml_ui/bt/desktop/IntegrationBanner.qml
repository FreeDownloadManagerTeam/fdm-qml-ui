import QtQuick 2.0
import org.freedownloadmanager.fdm 1.0
import "../../desktop/BaseElements"
import "../../common"

Rectangle {
    id: root
    visible: appWindow.showIntegrationBanner
    width: parent.width
    height: parent.height
    color: appWindow.theme.bannerBackground

    BaseLabel {
        anchors.leftMargin: 10*appWindow.zoom
        anchors.left: parent.left
        anchors.right: buttons.left
        anchors.verticalCenter: parent.verticalCenter
        text: App.my_BT_qsTranslate("IntegrationBanner", "Would you like to make %1 the default torrent client?").arg(App.shortDisplayName) + App.loc.emptyString
        font.pixelSize: 13*appWindow.fontZoom
        elide: Text.ElideRight
        color: appWindow.theme.foreground
    }

    Row {
        id: buttons
        anchors.right: parent.right
        anchors.rightMargin: 10*appWindow.zoom
        anchors.verticalCenter: parent.verticalCenter
        spacing: 10*appWindow.zoom

        BannerCustomButton {
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr("Set as Default") + App.loc.emptyString
            onClicked: root.doOK()
        }

        BannerCustomButton {
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr("Don't ask again") + App.loc.emptyString
            onClicked: root.cancel()
        }

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            width: 30*appWindow.zoom
            height: 30*appWindow.zoom
            color: "transparent"
            clip: true
            WaSvgImage {
                source: appWindow.theme.elementsIcons
                zoom: appWindow.zoom
                x: 11*zoom
                y: -224*zoom
                MouseArea {
                    anchors.fill: parent
                    onClicked: root.close()
                }
            }
        }
    }

    function doOK() {
        App.integration.enableIntegration(appWindow.integrationId, true);
        close();
    }

    function cancel() {
        uiSettingsTools.settings.hideIntegrationBanner = true;
        close();
    }

    function close() {
        appWindow.showIntegrationBanner = false;
    }

    function checkIntegrationBannerVisibility() {
        if (!uiSettingsTools.settings.hideIntegrationBanner
                && App.integration.isIntegrationSupported(appWindow.integrationId)
                && !App.integration.isIntegrationEnabled(appWindow.integrationId)) {
            appWindow.showIntegrationBanner = true;
        } else {
            appWindow.showIntegrationBanner = false;
        }
    }

    Component.onCompleted: {
        checkIntegrationBannerVisibility();
    }
}
