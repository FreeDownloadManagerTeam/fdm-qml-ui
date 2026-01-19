import QtQuick
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import "../../desktop/BaseElements"
import "../../desktop/BaseElements/V2"
import "../../desktop/Banners"
import "../../common"

BannerStrip {
    id: root

    readonly property bool shouldBeVisible: appWindow.showIntegrationBanner
    visible: shouldBeVisible

    implicitWidth: meat.implicitWidth + meat.anchors.leftMargin + meat.anchors.rightMargin
    implicitHeight: meat.implicitHeight + meat.anchors.topMargin + meat.anchors.bottomMargin

    readonly property int __spacing: (appWindow.uiver === 1 ? 10 : 16)*appWindow.zoom

    RowLayout {
        id: meat

        anchors.fill: parent
        anchors.leftMargin: (appWindow.uiver === 1 ? 10 : 12)*appWindow.zoom
        anchors.rightMargin: anchors.leftMargin
        anchors.topMargin: (appWindow.uiver === 1 ? 0 : 8)*appWindow.zoom
        anchors.bottomMargin: anchors.topMargin

        spacing: 0

        BaseLabel {
            text: App.my_BT_qsTranslate("IntegrationBanner", "Would you like to make %1 the default torrent client?").arg(App.shortDisplayName) + App.loc.emptyString
            font.pixelSize: 13*appWindow.fontZoom
            elide: Text.ElideRight
            color: appWindow.uiver === 1 ? appWindow.theme.foreground : appWindow.theme_v2.secondary
        }

        Item {
            implicitHeight: 1
            Layout.fillWidth: true
            Layout.minimumWidth: __spacing
        }

        BannerCustomButton {
            text: qsTr("Set as Default") + App.loc.emptyString
            onClicked: root.doOK()
        }

        Item {implicitWidth: __spacing; implicitHeight: 1}

        BannerCustomButton {
            text: qsTr("Don't ask again") + App.loc.emptyString
            onClicked: root.cancel()
        }

        Item {implicitWidth: __spacing; implicitHeight: 1}

        Item {
            visible: appWindow.uiver === 1
            implicitWidth: 30*appWindow.zoom
            implicitHeight: 30*appWindow.zoom
            WaSvgImage {
                anchors.centerIn: parent
                source: appWindow.theme.elementsIconsRoot + "/close.svg"
                zoom: appWindow.zoom
                MouseArea {
                    anchors.fill: parent
                    onClicked: root.close()
                }
            }
        }

        SvgImage_V2 {
            visible: appWindow.uiver !== 1
            source: Qt.resolvedUrl("../../desktop/BaseElements/V2/close.svg")
            MouseAreaWithHand_V2 {
                anchors.fill: parent
                onClicked: root.close()
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
