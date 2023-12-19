import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.4
import "../../qt5compat"
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.dmcoresettings 1.0
import org.freedownloadmanager.fdm.appsettings 1.0
import org.freedownloadmanager.fdm.tum 1.0
import "../BaseElements/"
import "../../common"

Page
{
    id: root

    //property string lastInvalidSettingsMessage: ""

    header: PageHeaderWithBackArrow {
        pageTitle: qsTr("Settings") + App.loc.emptyString
        onPopPage: root.StackView.view.pop()
        onClickedNtimes: uiSettingsTools.settings.showTroubleshootingUi = true
    }

//----------- Settings content - BEGIN ----------------
Rectangle {
    id: settingsWraper
    color: appWindow.theme.generalSettingsBackground
    anchors.fill: parent

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Flickable
        {
            id: flick

            Layout.fillWidth: true
            Layout.fillHeight: true

            Layout.leftMargin: appWindow.showBordersInDownloadsList ? settingsWraper.width * 0.1 : 0
            Layout.rightMargin: appWindow.showBordersInDownloadsList ? settingsWraper.width * 0.1 : 0

            flickableDirection: Flickable.VerticalFlick
            ScrollIndicator.vertical: ScrollIndicator { }
            boundsBehavior: Flickable.StopAtBounds

            contentWidth: width
            contentHeight: all.height

            ColumnLayout
            {
                id: all
                spacing: 0
                width: parent.width

                //General settings
                GeneralSettings {
                    Layout.fillWidth: true
                }
                Item {implicitHeight: 7; implicitWidth: 1}

                Rectangle {
                    id: contentColumnRect
                    Layout.fillWidth: true
                    Layout.preferredHeight: contentColumn.height
                    color: appWindow.theme.background
                    radius: 26

                    Column {
                        id: contentColumn

                        anchors.left: parent.left
                        anchors.right: parent.right

                        GeneralSettings2 {}

                        //Downloads settings
                        SettingsItem {
                            visible: appWindow.hasDownloadMgr
                            description: qsTr("Downloads settings") + App.loc.emptyString
                            onClicked: stackView.waPush(Qt.resolvedUrl("DownloadsSettings.qml"))
                            textWeight: Font.Bold
                        }

                        SettingsSeparator{
                            visible: appWindow.hasDownloadMgr
                        }

                        //Proxy settings
                        SettingsItem {
                            description: qsTr("Network settings") + App.loc.emptyString
                            onClicked: stackView.waPush(Qt.resolvedUrl("NetworkSettings.qml"))
                            textWeight: Font.Bold
                        }

                        SettingsSeparator{}

                        //Traffic settings
                        SettingsItem {
                            visible: appWindow.hasDownloadMgr
                            description: qsTr("Traffic limits") + App.loc.emptyString
                            onClicked: stackView.waPush(Qt.resolvedUrl("TrafficLimitsSettings.qml"))
                            textWeight: Font.Bold
                        }

                        SettingsSeparator{
                            visible: appWindow.hasDownloadMgr
                        }

                        SettingsItem {
                            visible: appWindow.hasDownloadMgr
                            description: qsTr("Sounds settings") + App.loc.emptyString
                            onClicked: stackView.waPush(Qt.resolvedUrl("SoundsSettings.qml"))
                            textWeight: Font.Bold
                        }

                        SettingsSeparator{
                            visible: appWindow.hasDownloadMgr
                        }

                        SettingsItem {
                            visible: appWindow.btSupported
                            description: appWindow.btSupported ? appWindow.btS.settingsTitle : ""
                            onClicked: stackView.waPush(Qt.resolvedUrl("../../bt/mobile/BtSettings.qml"))
                            textWeight: Font.Bold
                        }

                        SettingsSeparator {
                            visible: appWindow.btSupported
                        }

                        SettingsItem {
                            description: qsTr("Remote control settings") + App.loc.emptyString
                            onClicked: stackView.waPush(Qt.resolvedUrl("RemoteControlSettings.qml"))
                            textWeight: Font.Bold
                        }

                        SettingsSeparator{}

                        SettingsItem {
                            description: qsTr("Advanced settings") + App.loc.emptyString
                            onClicked: stackView.waPush(Qt.resolvedUrl("AdvancedSettings.qml"))
                            textWeight: Font.Bold
                        }

                        SettingsSeparator{
                            visible: uiSettingsTools.settings.showTroubleshootingUi
                        }
                        SettingsItem {
                            visible: uiSettingsTools.settings.showTroubleshootingUi
                            description: qsTr("Troubleshooting") + App.loc.emptyString
                            onClicked: stackView.waPush(Qt.resolvedUrl("TroubleshootingSettings.qml"))
                            textWeight: Font.Bold
                        }
                    }
                }

                DialogButton
                {
                    Layout.leftMargin: qtbug.leftMargin(10, 0)
                    Layout.rightMargin: qtbug.rightMargin(10, 0)
                    enabled: App.settings.hasNonDefaultValues || uiSettingsTools.hasNonDefaultValues
                    text: qsTr("Reset settings") + App.loc.emptyString
                    onClicked: okToResetMsg.open()
                    MessageDialog
                    {
                        id: okToResetMsg
                        title: qsTr("Default settings") + App.loc.emptyString
                        text: qsTr("Restore default settings?") + App.loc.emptyString
                        buttons: buttonOk | buttonCancel
                        onOkClicked: {
                            App.settings.resetToDefaults();
                            uiSettingsTools.resetToDefaults();
                            stackView.pop();
                            stackView.waPush(Qt.resolvedUrl("SettingsPage.qml"));
                        }
                    }
                }
            }
        }


    }
}
//----------- Settings content - END ----------------
}
