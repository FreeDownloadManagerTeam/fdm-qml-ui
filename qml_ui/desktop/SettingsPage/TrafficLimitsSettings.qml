import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.dmcoresettings 1.0
import org.freedownloadmanager.fdm.appsettings 1.0
import org.freedownloadmanager.fdm.tum 1.0
import "../BaseElements"

Column {
    spacing: 10

    SettingsGroupHeader {
        text: qsTr("Traffic Limits") + App.loc.emptyString
    }

    GridLayout {
        columns: 4
        id: grid

        property int labelMaxWidth: 165
        property int rowPreferredHeight: 38

        SettingsGridLabel {text: " "}
        SettingsGridLabel {text: qsTr("Low") + App.loc.emptyString}
        SettingsGridLabel {text: qsTr("Medium") + App.loc.emptyString}
        SettingsGridLabel {text: qsTr("High") + App.loc.emptyString}

        Rectangle {
            Layout.alignment: Qt.AlignTop
            Layout.preferredHeight: grid.rowPreferredHeight
            Layout.preferredWidth: grid.labelMaxWidth
            color: "transparent"
            SettingsGridLabel {
                width: parent.width
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("Download speed") + App.loc.emptyString
                wrapMode: Label.Wrap
            }
        }

        TumNetworkSpeedLimitComboBox {
            Layout.alignment: Qt.AlignTop
            mode: TrafficUsageMode.Low
            setting: DmCoreSettings.MaxDownloadSpeed
        }
        TumNetworkSpeedLimitComboBox {
            Layout.alignment: Qt.AlignTop
            mode: TrafficUsageMode.Medium
            setting: DmCoreSettings.MaxDownloadSpeed
        }
        TumNetworkSpeedLimitComboBox {
            Layout.alignment: Qt.AlignTop
            mode: TrafficUsageMode.High
            setting: DmCoreSettings.MaxDownloadSpeed
        }

        Rectangle {
            Layout.alignment: Qt.AlignTop
            Layout.preferredHeight: grid.rowPreferredHeight
            Layout.preferredWidth: grid.labelMaxWidth
            color: "transparent"
            SettingsGridLabel {
                width: parent.width
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("Upload speed") + App.loc.emptyString
                wrapMode: Label.Wrap
            }
        }

        TumNetworkSpeedLimitComboBox {
            Layout.alignment: Qt.AlignTop
            mode: TrafficUsageMode.Low
            setting: DmCoreSettings.MaxUploadSpeed
        }
        TumNetworkSpeedLimitComboBox {
            Layout.alignment: Qt.AlignTop
            mode: TrafficUsageMode.Medium
            setting: DmCoreSettings.MaxUploadSpeed
        }
        TumNetworkSpeedLimitComboBox {
            Layout.alignment: Qt.AlignTop
            mode: TrafficUsageMode.High
            setting: DmCoreSettings.MaxUploadSpeed
        }

        Rectangle {
            Layout.preferredHeight: grid.rowPreferredHeight
            Layout.preferredWidth: grid.labelMaxWidth
            color: "transparent"
            SettingsGridLabel {
                width: parent.width
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("Maximum number of connections") + App.loc.emptyString
                wrapMode: Label.Wrap
            }
        }

        TumSettingTextField {
            id: tumStg1
            mode: TrafficUsageMode.Low
            setting: DmCoreSettings.MaxConnections
        }
        TumSettingTextField {
            id: tumStg2
            mode: TrafficUsageMode.Medium
            setting: DmCoreSettings.MaxConnections
        }
        TumSettingTextField {
            id: tumStg3
            mode: TrafficUsageMode.High
            setting: DmCoreSettings.MaxConnections
        }

        Rectangle {
            Layout.preferredHeight: grid.rowPreferredHeight
            Layout.preferredWidth: grid.labelMaxWidth
            color: "transparent"
            SettingsGridLabel {
                width: parent.width
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("Maximum number of connections per server") + App.loc.emptyString
                wrapMode: Label.Wrap
            }
        }

        TumSettingTextField {
            id: tumStg7
            mode: TrafficUsageMode.Low
            setting: DmCoreSettings.MaxConnectionsPerServer
        }
        TumSettingTextField {
            id: tumStg8
            mode: TrafficUsageMode.Medium
            setting: DmCoreSettings.MaxConnectionsPerServer
        }
        TumSettingTextField {
            id: tumStg9
            mode: TrafficUsageMode.High
            setting: DmCoreSettings.MaxConnectionsPerServer
        }

        Rectangle {
            Layout.preferredHeight: grid.rowPreferredHeight
            Layout.preferredWidth: grid.labelMaxWidth
            color: "transparent"
            SettingsGridLabel {
                width: parent.width
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("Maximum number of simultaneous downloads") + App.loc.emptyString
                wrapMode: Label.Wrap
            }
        }

        TumSettingTextField {
            id: tumStg4
            mode: TrafficUsageMode.Low
            setting: DmCoreSettings.MaxDownloads
        }
        TumSettingTextField {
            id: tumStg5
            mode: TrafficUsageMode.Medium
            setting: DmCoreSettings.MaxDownloads
        }
        TumSettingTextField {
            id: tumStg6
            mode: TrafficUsageMode.High
            setting: DmCoreSettings.MaxDownloads
        }

        Loader {
            id : maxURatioGroup
            active: appWindow.btSupported
            source: "../../bt/desktop/MaxURatioLabel.qml"
            Layout.alignment: Qt.AlignTop
            Layout.preferredHeight: active ? grid.rowPreferredHeight : 0
            Layout.preferredWidth: grid.labelMaxWidth
        }

        TumMaxURatioComboBox {
            visible: maxURatioGroup.active
            Layout.alignment: Qt.AlignTop
            mode: TrafficUsageMode.Low
            setting: visible ? DmCoreSettings.MaxURatio : -1
        }
        TumMaxURatioComboBox {
            visible: maxURatioGroup.active
            Layout.alignment: Qt.AlignTop
            mode: TrafficUsageMode.Medium
            setting: visible ? DmCoreSettings.MaxURatio : -1
        }
        TumMaxURatioComboBox {
            visible: maxURatioGroup.active
            Layout.alignment: Qt.AlignTop
            mode: TrafficUsageMode.High
            setting: visible ? DmCoreSettings.MaxURatio : -1
        }
    }

    function invalidSettingsMessage()
    {
        if (!tumStg1.isValid() ||
                !tumStg2.isValid() ||
                !tumStg3.isValid() ||
                !tumStg4.isValid() ||
                !tumStg5.isValid() ||
                !tumStg6.isValid() ||
                !tumStg7.isValid() ||
                !tumStg8.isValid() ||
                !tumStg9.isValid())
        {
            return qsTr("Invalid traffic limits settings") + App.loc.emptyString;
        }
        return "";
    }
}
