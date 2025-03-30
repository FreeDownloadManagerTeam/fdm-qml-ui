import QtQuick 2.10
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.appfeatures 1.0
import "../../desktop/BaseElements"
import "../../desktop/SettingsPage"

Column {
    id: integrationCol
    spacing: 8*appWindow.zoom
    property bool isIntegrationSupported: App.integration.isIntegrationSupported(appWindow.integrationId)
    property bool isIntegrationEnabled: App.integration.isIntegrationEnabled(appWindow.integrationId)
    property bool isIntegrationAutoCheckEnabled: App.integration.isIntegrationAutoCheckEnabled(appWindow.integrationId)
    readonly property bool hasSystemDefaultApps: App.features.hasFeature(AppFeatures.SystemDefaultApps)
    readonly property bool canOpenSystemDefaultAppsSetting: App.features.hasFeature(AppFeatures.OpenSystemDefaultAppsSetting)

    width: parent.width
    visible: isIntegrationSupported || hasSystemDefaultApps

    Column {
        visible: isIntegrationSupported
        spacing: 8*appWindow.zoom
        width: parent.width

        SettingsCheckBox {
            id: intCheck
            text: App.my_BT_qsTranslate("IntegrationSettings", "Check if %1 is your default torrent client").arg(App.shortDisplayName) + App.loc.emptyString
            checked: integrationCol.isIntegrationAutoCheckEnabled
            onClicked: App.integration.enableIntegrationAutoCheck(appWindow.integrationId, !integrationCol.isIntegrationAutoCheckEnabled)
        }

        BaseButton {
            id: intBtn
            anchors.left: parent.left
            anchors.leftMargin: 38*appWindow.zoom
            blueBtn: true
            enabled: !integrationCol.isIntegrationEnabled
            text: App.my_BT_qsTranslate("IntegrationSettings", "Make %1 default torrent client").arg(App.shortDisplayName) + App.loc.emptyString
            onClicked: {
                App.integration.enableIntegration(appWindow.integrationId, true);
                appWindow.showIntegrationBanner = false;
            }
        }
    }

    BaseHyperLabel {
        visible: !isIntegrationSupported
        width: parent.width
        anchors.left: parent.left
        anchors.leftMargin: intCheck.anchors.leftMargin + intCheck.xOffset// (12+6)*appWindow.zoom
        readonly property string preLink: canOpenSystemDefaultAppsSetting ? "<a href='#'>" : ""
        readonly property string postLink: canOpenSystemDefaultAppsSetting ? "</a>" : ""
        //: Please keep %2 and %3 as is. They will be replaced with a hyperlink code or an empty string (depends on platform)
        text: App.my_BT_qsTranslate("IntegrationSettings",
                                    "Please use %2Default apps system settings%3 to make %1 the default torrent client")
                                    .arg(App.shortDisplayName).arg(preLink).arg(postLink) + App.loc.emptyString
        onLinkActivated: App.openSystemDefaultAppsSettings()
        wrapMode: Text.WordWrap
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
