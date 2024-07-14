import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.dmcoresettings 1.0
import org.freedownloadmanager.fdm.appsettings 1.0
import org.freedownloadmanager.fdm.tum 1.0
import "../BaseElements"

Column {
    spacing: 10*appWindow.zoom

    SettingsGroupHeader {
        text: qsTr("Traffic Limits") + App.loc.emptyString
    }

    GridLayout {
        id: grid

        columns: 4
        anchors.left: parent.left

        property int labelMaxWidth: 165*appWindow.zoom
        property int rowMinimumHeight: 38*appWindow.zoom

        SettingsGridLabel {text: " "}
        SettingsGridLabel {text: qsTr("Low") + App.loc.emptyString}
        SettingsGridLabel {text: qsTr("Medium") + App.loc.emptyString}
        SettingsGridLabel {text: qsTr("High") + App.loc.emptyString}

        SettingsGridLabel {
            Layout.minimumHeight: grid.rowMinimumHeight
            Layout.preferredWidth: grid.labelMaxWidth
            Layout.alignment: Qt.AlignVCenter
            text: qsTr("Download speed") + App.loc.emptyString
            wrapMode: Label.Wrap
            verticalAlignment: Text.AlignVCenter
        }

        TumNetworkSpeedLimitComboBox {
            Layout.alignment: Qt.AlignVCenter
            mode: TrafficUsageMode.Low
            setting: DmCoreSettings.MaxDownloadSpeed
        }
        TumNetworkSpeedLimitComboBox {
            Layout.alignment: Qt.AlignVCenter
            mode: TrafficUsageMode.Medium
            setting: DmCoreSettings.MaxDownloadSpeed
        }
        TumNetworkSpeedLimitComboBox {
            Layout.alignment: Qt.AlignVCenter
            mode: TrafficUsageMode.High
            setting: DmCoreSettings.MaxDownloadSpeed
        }

        SettingsGridLabel {
            Layout.minimumHeight: grid.rowMinimumHeight
            Layout.preferredWidth: grid.labelMaxWidth
            Layout.alignment: Qt.AlignVCenter
            text: qsTr("Upload speed") + App.loc.emptyString
            wrapMode: Label.Wrap
            verticalAlignment: Text.AlignVCenter
        }

        TumNetworkSpeedLimitComboBox {
            Layout.alignment: Qt.AlignVCenter
            mode: TrafficUsageMode.Low
            setting: DmCoreSettings.MaxUploadSpeed
        }
        TumNetworkSpeedLimitComboBox {
            Layout.alignment: Qt.AlignVCenter
            mode: TrafficUsageMode.Medium
            setting: DmCoreSettings.MaxUploadSpeed
        }
        TumNetworkSpeedLimitComboBox {
            Layout.alignment: Qt.AlignVCenter
            mode: TrafficUsageMode.High
            setting: DmCoreSettings.MaxUploadSpeed
        }

        SettingsGridLabel {
            Layout.minimumHeight: grid.rowMinimumHeight
            Layout.preferredWidth: grid.labelMaxWidth
            Layout.alignment: Qt.AlignVCenter
            text: qsTr("Maximum number of connections") + App.loc.emptyString
            wrapMode: Label.Wrap
            verticalAlignment: Text.AlignVCenter
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

        SettingsGridLabel {
            Layout.minimumHeight: grid.rowMinimumHeight
            Layout.preferredWidth: grid.labelMaxWidth
            Layout.alignment: Qt.AlignVCenter
            text: qsTr("Maximum number of connections per server") + App.loc.emptyString
            wrapMode: Label.Wrap
            verticalAlignment: Text.AlignVCenter
        }

        TumSettingTextField {
            id: tumStg7
            mode: TrafficUsageMode.Low
            setting: DmCoreSettings.MaxConnectionsPerServer
            maxValue: App.MaxConnectionsPerServerLimit
        }
        TumSettingTextField {
            id: tumStg8
            mode: TrafficUsageMode.Medium
            setting: DmCoreSettings.MaxConnectionsPerServer
            maxValue: App.MaxConnectionsPerServerLimit
        }
        TumSettingTextField {
            id: tumStg9
            mode: TrafficUsageMode.High
            setting: DmCoreSettings.MaxConnectionsPerServer
            maxValue: App.MaxConnectionsPerServerLimit
        }

        SettingsGridLabel {
            Layout.minimumHeight: grid.rowMinimumHeight
            Layout.preferredWidth: grid.labelMaxWidth
            Layout.alignment: Qt.AlignVCenter
            text: qsTr("Maximum number of simultaneous downloads") + App.loc.emptyString
            wrapMode: Label.Wrap
            verticalAlignment: Text.AlignVCenter
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
            Layout.minimumHeight: grid.rowMinimumHeight
            Layout.preferredWidth: grid.labelMaxWidth
            Layout.alignment: Qt.AlignVCenter
            id : maxURatioGroup
            active: appWindow.btSupported
            source: "../../bt/desktop/MaxURatioLabel.qml"
        }

        TumMaxURatioComboBox {
            visible: maxURatioGroup.active
            Layout.alignment: Qt.AlignVCenter
            mode: TrafficUsageMode.Low
        }
        TumMaxURatioComboBox {
            visible: maxURatioGroup.active
            Layout.alignment: Qt.AlignVCenter
            mode: TrafficUsageMode.Medium
        }
        TumMaxURatioComboBox {
            visible: maxURatioGroup.active
            Layout.alignment: Qt.AlignVCenter
            mode: TrafficUsageMode.High
        }
    }

    Row {
        anchors.left: parent.left

        spacing: 7*appWindow.fontZoom

        BaseLabel {
            text: qsTr("Maximum number of additional querying info downloads:") + App.loc.emptyString
            anchors.verticalCenter: parent.verticalCenter
        }

        BaseComboBox {
            anchors.verticalCenter: parent.verticalCenter
            settingsStyle: true
            model: [
                {text: "0", value: 0},
                {text: "1", value: 1},
                {text: "2", value: 2},
                {text: "3", value: 3},
                {text: "4", value: 4},
                {text: "5", value: 5},
                {text: "6", value: 6},
                {text: "7", value: 7}
            ]
            currentIndex: {
                let v = parseInt(App.settings.dmcore.value(DmCoreSettings.MaxAdditionalQueryInfoDownloads));
                if (v < 0 || v > 7)
                    v = 3;
                return v;
            }
            onActivated: (index) => App.settings.dmcore.setValue(DmCoreSettings.MaxAdditionalQueryInfoDownloads, model[index].value)
        }
    }

    SettingsCheckBox {
        text: qsTr("Enable additional downloads to optimize speed") + App.loc.emptyString
        checked: parseInt(App.settings.dmcore.value(DmCoreSettings.MaxAdditionalSmallDownloads)) > 0 ||
                 parseInt(App.settings.dmcore.value(DmCoreSettings.MaxAdditionalDownloadsIfTotalSpeedIsTooSlow)) > 0
        anchors.left: parent.left
        anchors.leftMargin: 0*appWindow.zoom
        xOffset: 0
        onClicked: {
            App.settings.dmcore.setValue(
                        DmCoreSettings.MaxAdditionalSmallDownloads,
                        checked ? "1" : "0");
            App.settings.dmcore.setValue(
                        DmCoreSettings.MaxAdditionalDownloadsIfTotalSpeedIsTooSlow,
                        checked ? "1" : "0");
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
