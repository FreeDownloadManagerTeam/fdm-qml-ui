import QtQuick 2.10
import QtQuick.Controls 2.3
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.dmcoresettings 1.0
import org.freedownloadmanager.fdm.appsettings 1.0
import org.freedownloadmanager.fdm.appfeatures 1.0
import "../BaseElements"
import "../../common"

Column {
    spacing: 7

    property var flags: {"en_US": -250, "ar_EG": -260, "zh_CN": -130, "zh_TW": -270, "ug": -130, "uk_UA": -220,
                         "da_DK": -100, "nl_NL": -80, "fr_FR": -30, "de_DE": -20, "el_GR": -120, "id_ID": -180,
                         "it_IT": -50, "ja_JP": -150, "pl_PL": -70, "pt_BR": -200, "ro_RO": -60, "ru_RU": -110,
                         "sl_SI": -140, "es_ES": -10, "sv_SE": -90, "tr_TR": -160, "vi_VN": -190, "fa": -210,
                         "hu_HU": -230, "fa_IR": -240, "bg_BG": -280, "ko_KR": -290, "hi_IN": -300 }

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        height: 52
        radius: 26
        color: appWindow.theme.background
        Rectangle {
            width: parent.width
            height: parent.height / 2
            color: parent.color
        }

        BaseLabel {
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr("Language") + App.loc.emptyString
            font.pixelSize: 16
        }
        Row {
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.verticalCenter: parent.verticalCenter
            spacing: 6
            Rectangle {
                clip: true
                color: "transparent"
                width: 18
                height: 10
                anchors.verticalCenter: parent.verticalCenter

                WaSvgImage {
                    x: 0
                    y: flags[App.loc.currentTranslation]
                    source: Qt.resolvedUrl("../../images/flags.svg")
                }
            }
            BaseLabel {
                text: App.loc.translationLanguageString(App.loc.currentTranslation) + " (" + App.loc.translationCountryString(App.loc.currentTranslation) + ")"
                font.capitalization: Font.Capitalize
                font.pixelSize: 16
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: langDialog.open()
        }
    }

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        height: clmn.height
        radius: 26
        color: appWindow.theme.background

        Rectangle {
            width: parent.width
            anchors.top: parent.top
            anchors.topMargin: 20
            anchors.bottom: parent.bottom
            color: parent.color
        }

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
                leftPadding: switchSetting6.textMargins + 5
                bottomPadding: switchSetting6.padding + 3
                wrapMode: Text.WordWrap
                width: clmn.width - leftPadding
            }

            SettingsSeparator{
                visible: switchSetting5.visible
            }

        }
    }

    LanguageDialog {
        id: langDialog
    }
}
