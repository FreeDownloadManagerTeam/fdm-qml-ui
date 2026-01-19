import QtQuick
import QtQuick.Controls
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.dmcoresettings
import org.freedownloadmanager.fdm.appsettings
import org.freedownloadmanager.fdm.appfeatures
import "../BaseElements"
import "../../common"

Column {
    id: clmn
    anchors.left: parent.left
    anchors.right: parent.right
    topPadding: 7

    SwitchSetting {
        id: switchSetting3
        visible: App.features.hasFeature(AppFeatures.Updates)
        description: qsTr("Check for updates automatically") + App.loc.emptyString
        switchChecked: App.settings.toBool(App.settings.app.value(AppSettings.CheckUpdatesAutomatically))
        onClicked: {
            switchChecked = !switchChecked;
            App.settings.app.setValue(
                        AppSettings.CheckUpdatesAutomatically,
                        App.settings.fromBool(switchChecked));
        }
    }

    SettingsSeparator{
        visible: switchSetting3.visible
    }

    SwitchSetting {
        id: switchSetting4
        visible: App.features.hasFeature(AppFeatures.Updates)
        description: qsTr("Install updates automatically") + App.loc.emptyString
        switchChecked: App.settings.toBool(App.settings.app.value(AppSettings.InstallUpdatesAutomatically))
        onClicked: {
            switchChecked = !switchChecked;
            App.settings.app.setValue(
                        AppSettings.InstallUpdatesAutomatically,
                        App.settings.fromBool(switchChecked));
        }
    }

    SettingsSeparator{
        visible: switchSetting4.visible
    }

    SwitchSetting {
        id: switchSetting5
        description: qsTr("Use mobile network") + App.loc.emptyString
        visible: App.features.hasFeature(AppFeatures.AllowedNetworkTypesList)
        switchChecked: App.settings.toBool(App.settings.dmcore.value(DmCoreSettings.AllowToUseMobileNetworks))
        onClicked: {
            switchChecked = !switchChecked;
            App.settings.dmcore.setValue(
                        DmCoreSettings.AllowToUseMobileNetworks,
                        App.settings.fromBool(switchChecked));
        }
    }

    SwitchSetting {
        id: switchSetting6
        description: qsTr("Allow data roaming") + App.loc.emptyString
        visible: App.features.hasFeature(AppFeatures.AllowedNetworkTypesList)
        switchChecked: App.settings.toBool(App.settings.dmcore.value(DmCoreSettings.AllowToUseRoamingNetworks))
        onClicked: {
            switchChecked = !switchChecked;
            App.settings.dmcore.setValue(
                        DmCoreSettings.AllowToUseRoamingNetworks,
                        App.settings.fromBool(switchChecked));
        }
    }

    BaseLabel {
        visible: App.features.hasFeature(AppFeatures.AllowedNetworkTypesList)
        text: qsTr("Using mobile data while roaming may result in additional charges.") + App.loc.emptyString
        leftPadding: qtbug.leftPadding(switchSetting6.textMargins + 5, 0)
        rightPadding: qtbug.rightPadding(switchSetting6.textMargins + 5, 0)
        bottomPadding: switchSetting6.padding + 3
        wrapMode: Text.WordWrap
        width: clmn.width - leftPadding
    }

    SettingsSeparator{
        visible: switchSetting5.visible
    }
}
