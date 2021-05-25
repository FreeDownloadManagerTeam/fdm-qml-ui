import QtQuick 2.10
import org.freedownloadmanager.fdm 1.0
import "../../desktop/BaseElements"
import "../../desktop/SettingsPage"

Column {
    id: integrationCol
    spacing: 8
    property bool isIntegrationSupported: App.integration.isIntegrationSupported(appWindow.integrationId)
    property bool isIntegrationEnabled: App.integration.isIntegrationEnabled(appWindow.integrationId)
    property bool isIntegrationAutoCheckEnabled: App.integration.isIntegrationAutoCheckEnabled(appWindow.integrationId)

    width: parent.width
    visible: isIntegrationSupported

    SettingsCheckBox {
        id: intCheck
        text: App.my_BT_qsTranslate("IntegrationSettings", "Check if %1 is your default torrent client").arg(App.shortDisplayName) + App.loc.emptyString
        checked: integrationCol.isIntegrationAutoCheckEnabled
        onClicked: App.integration.enableIntegrationAutoCheck(appWindow.integrationId, !integrationCol.isIntegrationAutoCheckEnabled)
    }

    CustomButton {
        id: intBtn
        anchors.left: parent.left
        anchors.leftMargin: 38
        blueBtn: true
        enabled: !integrationCol.isIntegrationEnabled
        text: App.my_BT_qsTranslate("IntegrationSettings", "Make %1 default torrent client").arg(App.shortDisplayName) + App.loc.emptyString
        onClicked: {
            App.integration.enableIntegration(appWindow.integrationId, true);
            appWindow.showIntegrationBanner = false;
        }
    }

    function updateIntegration()
    {
        integrationCol.isIntegrationSupported = App.integration.isIntegrationSupported(appWindow.integrationId);
        integrationCol.isIntegrationEnabled = App.integration.isIntegrationEnabled(appWindow.integrationId);
        integrationCol.isIntegrationAutoCheckEnabled = App.integration.isIntegrationAutoCheckEnabled(appWindow.integrationId);
    }

    Connections {
        target: App.integration
        onChanged: integrationCol.updateIntegration()
    }

    Component.onCompleted: {
        App.integration.refresh();
    }
}
