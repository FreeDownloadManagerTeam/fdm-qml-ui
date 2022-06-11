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

Page
{
    id: root

    //property string lastInvalidSettingsMessage: ""

    header: PageHeaderWithBackArrow {
        pageTitle: qsTr("Settings") + App.loc.emptyString
        onPopPage: root.StackView.view.pop()
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
                    id: generalSettings
                    Layout.fillWidth: true
                }

                Rectangle {
                    id: contentColumnRect
                    Layout.fillWidth: true
                    Layout.preferredHeight: contentColumn.height
                    color: appWindow.theme.background
                    radius: 26

                    Rectangle {
                        width: parent.width
                        anchors.top: parent.top
                        anchors.bottomMargin: 20
                        anchors.bottom: parent.bottom
                        color: parent.color
                    }

                    Column {
                        id: contentColumn

                        anchors.left: parent.left
                        anchors.right: parent.right

                        //Downloads settings
                        SettingsItem {
                            description: qsTr("Downloads settings") + App.loc.emptyString
                            onClicked: stackView.waPush(Qt.resolvedUrl("DownloadsSettings.qml"))
                            textWeight: Font.Bold
                        }

                        SettingsSeparator{}

                        //Proxy settings
                        SettingsItem {
                            description: qsTr("Network settings") + App.loc.emptyString
                            onClicked: stackView.waPush(Qt.resolvedUrl("NetworkSettings.qml"))
                            textWeight: Font.Bold
                        }

                        SettingsSeparator{}

                        //Traffic settings
                        SettingsItem {
                            description: qsTr("Traffic limits") + App.loc.emptyString
                            onClicked: stackView.waPush(Qt.resolvedUrl("TrafficLimitsSettings.qml"))
                            textWeight: Font.Bold
                        }

                        SettingsSeparator{}

                        SettingsItem {
                            description: qsTr("Sounds settings") + App.loc.emptyString
                            onClicked: stackView.waPush(Qt.resolvedUrl("SoundsSettings.qml"))
                            textWeight: Font.Bold
                        }

                        SettingsSeparator{}

                        SettingsItem {
                            description: qsTr("Advanced settings") + App.loc.emptyString
                            onClicked: stackView.waPush(Qt.resolvedUrl("AdvancedSettings.qml"))
                            textWeight: Font.Bold
                        }
                    }
                }

                Rectangle {
                    color: appWindow.theme.background
                    height: 20
                    width: parent.width
                }

                BaseLabel
                {
                    Layout.leftMargin: 20
                    font.pixelSize: 14
                    font.bold: true
                    text: qsTr("Go back to default settings") + App.loc.emptyString
                }

                DialogButton
                {
                    Layout.leftMargin: 30
                    enabled: App.settings.hasNonDefaultValues || uiSettingsTools.hasNonDefaultValues
                    text: qsTr("Reset")
                    onClicked: okToResetMsg.open()
                    MessageDialog
                    {
                        id: okToResetMsg
                        title: qsTr("Default settings") + App.loc.emptyString
                        text: qsTr("Restore default settings?") + App.loc.emptyString
                        buttons: buttonOk | buttonCancel
                        onAccepted: {
                            App.settings.resetToDefaults();
                            uiSettingsTools.resetToDefaults();
                            stackView.pop();
                            stackView.waPush(Qt.resolvedUrl("SettingsPage.qml"));
                        }
                    }
                }
            }

            /*Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: all.bottom
                height: parent.height - contentHeight
                color: appWindow.theme.background
            }*/
        }


    }
}
//----------- Settings content - END ----------------
}
