import QtQuick 2.11
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.dmcoresettings 1.0
import org.freedownloadmanager.fdm.appsettings 1.0
import org.freedownloadmanager.fdm.tum 1.0
import "."
import "../BaseElements/"

Page {
    id: root

    property bool smallScreen: width < 500

    header: PageHeaderWithBackArrow {
        pageTitle: qsTr("Traffic limits") + App.loc.emptyString
        //onPopPage: root.StackView.view.pop()
        onPopPage:  {
            invalidSettingsMessageDialog.lastInvalidSettingsMessage = root.invalidSettingsMessage();
            if (invalidSettingsMessageDialog.lastInvalidSettingsMessage !== "")
            {
                invalidSettingsMessageDialog.open();
                return;
            }
            root.StackView.view.pop()
        }
    }

    InvalidSettingsMessageDialog {
        id: invalidSettingsMessageDialog
        lastInvalidSettingsMessage: ""
        onPopPage: root.StackView.view.pop()
    }

    Rectangle {
        id: settingsWraper
        color: "transparent"
        anchors.fill: parent

        Flickable
        {
            anchors.fill: parent
            flickableDirection: Flickable.VerticalFlick
            ScrollIndicator.vertical: ScrollIndicator { }
            boundsBehavior: Flickable.StopAtBounds

            //contentWidth: contentColumn.width
            contentHeight: contentColumn.height + 20

            ColumnLayout {
                id: contentColumn
                anchors.left: parent.left
                anchors.right: parent.right

                anchors.leftMargin: appWindow.showBordersInDownloadsList ? settingsWraper.width * 0.1 : 0
                anchors.rightMargin: appWindow.showBordersInDownloadsList ? settingsWraper.width * 0.1 : 0

                spacing: 0

//-- contentColumn content - BEGIN -------------------------------------------------------------------

    //--- Download speed - BEGIN ------------------------
                SettingsGroupHeader {
                    name: qsTr("Download speed") + App.loc.emptyString
                    Layout.fillWidth: true
                }

                GridLayout {
                    columns: smallScreen ? 1 : 3

                    //anchors.left: parent.left
                    //anchors.right: parent.right
                    Layout.leftMargin: 20
                    Layout.rightMargin: 20

                    SpeedComboBoxWrapper {
                        comboBoxText: qsTr("Low") + App.loc.emptyString
                        speedLimitMode: TrafficUsageMode.Low
                        speedLimitSetting: DmCoreSettings.MaxDownloadSpeed
                    }

                    SpeedComboBoxWrapper {
                        comboBoxText: qsTr("Medium") + App.loc.emptyString
                        speedLimitMode: TrafficUsageMode.Medium
                        speedLimitSetting: DmCoreSettings.MaxDownloadSpeed
                    }

                    SpeedComboBoxWrapper {
                        comboBoxText: qsTr("High") + App.loc.emptyString
                        speedLimitMode: TrafficUsageMode.High
                        speedLimitSetting: DmCoreSettings.MaxDownloadSpeed
                    }
                }
    //--- Download speed - END ------------------------

    //--- Upload speed - BEGIN ------------------------
                SettingsGroupHeader {
                    name: qsTr("Upload speed") + App.loc.emptyString
                    Layout.fillWidth: true
                }

                GridLayout {
                    columns: smallScreen ? 1 : 3

                    //anchors.left: parent.left
                    //anchors.right: parent.right
                    Layout.leftMargin: 20
                    Layout.rightMargin: 20

                    SpeedComboBoxWrapper {
                        comboBoxText: qsTr("Low") + App.loc.emptyString
                        speedLimitMode: TrafficUsageMode.Low
                        speedLimitSetting: DmCoreSettings.MaxUploadSpeed
                    }

                    SpeedComboBoxWrapper {
                        comboBoxText: qsTr("Medium") + App.loc.emptyString
                        speedLimitMode: TrafficUsageMode.Medium
                        speedLimitSetting: DmCoreSettings.MaxUploadSpeed
                    }

                    SpeedComboBoxWrapper {
                        comboBoxText: qsTr("High") + App.loc.emptyString
                        speedLimitMode: TrafficUsageMode.High
                        speedLimitSetting: DmCoreSettings.MaxUploadSpeed
                    }
                }
    //--- Upload speed - END ------------------------

    //--- Maximum number of connections - BEGIN ------------------------
                SettingsGroupHeader
                {
                    name: qsTr("Maximum number of connections") + App.loc.emptyString
                    Layout.fillWidth: true
                }

                GridLayout
                {
                   columns: smallScreen ? 1 : 3

                   Layout.leftMargin: 20
                   Layout.rightMargin: 20

                   MaxConnectionsWrapper {
                       id: maxConn1
                       labelText: qsTr("Low") + App.loc.emptyString
                       trafficUsageMode: TrafficUsageMode.Low
                       maxDownloadSpeedSetting: DmCoreSettings.MaxConnections
                   }

                   MaxConnectionsWrapper {
                       id: maxConn2
                       labelText: qsTr("Medium") + App.loc.emptyString
                       trafficUsageMode: TrafficUsageMode.Medium
                       maxDownloadSpeedSetting: DmCoreSettings.MaxConnections
                   }

                   MaxConnectionsWrapper {
                       id: maxConn3
                       labelText: qsTr("High") + App.loc.emptyString
                       trafficUsageMode: TrafficUsageMode.High
                       maxDownloadSpeedSetting: DmCoreSettings.MaxConnections
                   }
                }
    //--- Maximum number of connections - END ------------------------

    /*
    //--- Maximum number of connections per server - BEGIN ------------------------
                SettingsGroupHeader
                {
                    id: h1
                    name: qsTr("Maximum number of connections per server") + App.loc.emptyString
                    Layout.fillWidth: true
                }

                GridLayout
                {
                   columns: smallScreen ? 1 : 3

                   Layout.leftMargin: 20
                   Layout.rightMargin: 20

                   MaxConnectionsWrapper {
                       id: maxConn4
                       labelText: qsTr("Low") + App.loc.emptyString
                       trafficUsageMode: TrafficUsageMode.Low
                       maxDownloadSpeedSetting: DmCoreSettings.MaxConnectionsPerServer
                   }

                   MaxConnectionsWrapper {
                       id: maxConn5
                       labelText: qsTr("Medium") + App.loc.emptyString
                       trafficUsageMode: TrafficUsageMode.Medium
                       maxDownloadSpeedSetting: DmCoreSettings.MaxConnectionsPerServer
                   }

                   MaxConnectionsWrapper {
                       id: maxConn6
                       labelText: qsTr("High") + App.loc.emptyString
                       trafficUsageMode: TrafficUsageMode.High
                       maxDownloadSpeedSetting: DmCoreSettings.MaxConnectionsPerServer
                   }
                }
    //--- Maximum number of connections per server - END ------------------------
    */
    //--- Maximum number of simultaneous downloads - BEGIN ------------------------
                SettingsGroupHeader
                {
                    name: qsTr("Maximum number of simultaneous downloads") + App.loc.emptyString
                    Layout.fillWidth: true
                }

                GridLayout
                {
                   columns: smallScreen ? 1 : 3

                   Layout.leftMargin: 20
                   Layout.rightMargin: 20

                   MaxConnectionsWrapper {
                       id: maxConn7
                       labelText: qsTr("Low") + App.loc.emptyString
                       trafficUsageMode: TrafficUsageMode.Low
                       maxDownloadSpeedSetting: DmCoreSettings.MaxDownloads
                   }

                   MaxConnectionsWrapper {
                       id: maxConn8
                       labelText: qsTr("Medium") + App.loc.emptyString
                       trafficUsageMode: TrafficUsageMode.Medium
                       maxDownloadSpeedSetting: DmCoreSettings.MaxDownloads
                   }

                   MaxConnectionsWrapper {
                       id: maxConn9
                       labelText: qsTr("High") + App.loc.emptyString
                       trafficUsageMode: TrafficUsageMode.High
                       maxDownloadSpeedSetting: DmCoreSettings.MaxDownloads
                   }
                }
    //--- Maximum number of simultaneous downloads - END ------------------------
    //--- MaxURatio - BEGIN ------------------------
                Loader {
                    id : maxURatioGroup
                    active: appWindow.btSupported
                    source: "../../bt/mobile/MaxURatioLabel.qml"
                    Layout.fillWidth: true
                }

                GridLayout {
                    visible: maxURatioGroup.active
                    columns: smallScreen ? 1 : 3
                    Layout.leftMargin: 20
                    Layout.rightMargin: 20

                    MaxURatioComboBoxWrapper {
                        comboBoxText: qsTr("Low") + App.loc.emptyString
                        speedLimitMode: TrafficUsageMode.Low
                        speedLimitSetting: maxURatioGroup.visible ? DmCoreSettings.MaxURatio : -1
                    }

                    MaxURatioComboBoxWrapper {
                        comboBoxText: qsTr("Medium") + App.loc.emptyString
                        speedLimitMode: TrafficUsageMode.Medium
                        speedLimitSetting: maxURatioGroup.visible ? DmCoreSettings.MaxURatio : -1
                    }

                    MaxURatioComboBoxWrapper {
                        comboBoxText: qsTr("High") + App.loc.emptyString
                        speedLimitMode: TrafficUsageMode.High
                        speedLimitSetting: maxURatioGroup.visible ? DmCoreSettings.MaxURatio : -1
                    }
                }
    //--- MaxURatio - END ------------------------
//-- contentColumn content - END ---------------------------------------------------------------------
            }

        }
    }

    function invalidSettingsMessage()
    {
        if (!maxConn1.isValidTumSetting() ||
            !maxConn2.isValidTumSetting() ||
            !maxConn3.isValidTumSetting() ||
//            !maxConn4.isValidTumSetting() ||
//            !maxConn5.isValidTumSetting() ||
//            !maxConn6.isValidTumSetting() ||
            !maxConn7.isValidTumSetting() ||
            !maxConn8.isValidTumSetting() ||
            !maxConn9.isValidTumSetting())
        {
            return qsTr("Invalid traffic limits settings") + App.loc.emptyString;
        }
        return "";
    }
}



