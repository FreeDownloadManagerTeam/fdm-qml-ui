import QtQuick 2.11
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.12
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.abstractdownloadsui 1.0
import org.freedownloadmanager.fdm.appsettings 1.0
import org.freedownloadmanager.fdm.appfeatures 1.0
import org.freedownloadmanager.fdm.dmcoresettings 1.0
import "."
import "../../mobile/BaseElements"
import "../../mobile/SettingsPage"
import "../../qt5compat"

Page {
    id: root

    header: PageHeaderWithBackArrow {
        pageTitle: appWindow.btS.settingsTitle
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

            contentHeight: contentColumn.height

            Column {
                id: contentColumn
                anchors.left: parent.left
                anchors.right: parent.right
                topPadding: 7

//-- contentColumn content - BEGIN -------------------------------------------------------------------

                RowLayout {
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    spacing: 10
                    width: parent.width - 20 - 10

                    BaseLabel {
                        text: qsTr("Encryption:") + App.loc.emptyString
                        Layout.alignment: Qt.AlignVCenter
                        font.pixelSize: 16
                    }

                    Item {implicitWidth: 1; implicitHeight: 1; Layout.fillWidth: true}

                    BaseComboBox {
                        Layout.alignment: Qt.AlignVCenter
                        Layout.fillWidth: true
                        Layout.preferredWidth: implicitWidth
                        Layout.maximumWidth: implicitWidth
                        model: [
                            {text: qsTr("No encryption allowed") + App.loc.emptyString, value: AbstractDownloadsUi.NoEncryptionAllowed},
                            {text: qsTr("Prefer encryption") + App.loc.emptyString, value: AbstractDownloadsUi.PreferEncryption},
                            {text: qsTr("Require encryption") + App.loc.emptyString, value: AbstractDownloadsUi.RequireEncryption},
                        ]
                        currentIndex: {
                            let v = parseInt(App.settings.dmcore.value(DmCoreSettings.BtEncryptionPolicy));
                            for (let i = 0; i < model.length; ++i) {
                                if (model[i].value === v)
                                    return i;
                            }
                            return 0;
                        }
                        onActivated: (index) => App.settings.dmcore.setValue(DmCoreSettings.BtEncryptionPolicy, model[index].value.toString())
                    }

                    Item {implicitWidth: 20; implicitHeight: 1}
                }

                Item {implicitHeight: 10; implicitWidth: 1}

                SettingsSeparator{}

                SwitchSetting {
                    description: App.my_BT_qsTranslate("Settings", "Enable DHT to find more peers") + App.loc.emptyString
                    switchChecked: App.settings.toBool(App.settings.dmcore.value(DmCoreSettings.BtEnableDht))
                    onClicked: {
                        switchChecked = !switchChecked;
                        App.settings.dmcore.setValue(DmCoreSettings.BtEnableDht,
                                                     App.settings.fromBool(switchChecked));
                    }
                }

                SettingsSeparator{}

                SwitchSetting {
                    description: App.my_BT_qsTranslate("Settings", "Enable PeX to find more peers") + App.loc.emptyString
                    switchChecked: App.settings.toBool(App.settings.dmcore.value(DmCoreSettings.BtEnablePex))
                    onClicked: {
                        switchChecked = !switchChecked;
                        App.settings.dmcore.setValue(DmCoreSettings.BtEnablePex,
                                                     App.settings.fromBool(switchChecked));
                        pexRestartRequired.visible = true;
                    }
                }

                RestartRequiredLabel {
                    id: pexRestartRequired
                    visible: false
                    leftPadding: qtbug.leftPadding(20, 0)
                    rightPadding: qtbug.rightPadding(20, 0)
                }

                Item {
                    implicitWidth: 1
                    implicitHeight: 10
                    visible: pexRestartRequired.visible
                }

                SettingsSeparator{}

                SwitchSetting {
                    description: App.my_BT_qsTranslate("Settings", "Enable Local Peer Discovery to find more peers") + App.loc.emptyString
                    switchChecked: App.settings.toBool(App.settings.dmcore.value(DmCoreSettings.BtEnableLsd))
                    onClicked: {
                        switchChecked = !switchChecked;
                        App.settings.dmcore.setValue(DmCoreSettings.BtEnableLsd,
                                                     App.settings.fromBool(switchChecked));
                    }
                }

                SettingsSeparator{}

                SwitchSetting {
                    description: App.my_BT_qsTranslate("Settings", "Enable uTP") + App.loc.emptyString
                    switchChecked: App.settings.toBool(App.settings.dmcore.value(DmCoreSettings.BtEnableUtp))
                    onClicked: {
                        switchChecked = !switchChecked;
                        App.settings.dmcore.setValue(DmCoreSettings.BtEnableUtp,
                                                     App.settings.fromBool(switchChecked));
                    }
                }

                SettingsSeparator{}

                SwitchSetting {
                    id: useSystemDefinedPort
                    description: App.my_BT_qsTranslate("Settings", "Use system defined port for incoming connections") + App.loc.emptyString
                    switchChecked: (parseInt(App.settings.dmcore.value(DmCoreSettings.BtSessionPort)) || 0) <= 0
                    onClicked: {
                        switchChecked = !switchChecked;
                        applySettings();
                        if (!switchChecked)
                        {
                            customPortText.forceActiveFocus();
                            customPortText.selectAll();
                        }
                        else
                        {
                            useSystemDefinedPort.forceActiveFocus();
                        }
                    }
                }

                BaseLabel {
                    visible: useSystemDefinedPort.switchChecked && btTools.item.sessionPort > 0
                    text: qsTr("Current port: %1").arg(btTools.item.sessionPort) + App.loc.emptyString
                    leftPadding: qtbug.leftPadding(40, 0)
                    rightPadding: qtbug.rightPadding(40, 0)
                    bottomPadding: 10
                }

                Row {
                    visible: !useSystemDefinedPort.switchChecked
                    leftPadding: qtbug.leftPadding(40, 0)
                    rightPadding: qtbug.rightPadding(40, 0)
                    spacing: 20

                    Label {
                        text: qsTr("Custom port:") + App.loc.emptyString
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    TextField {
                        id: customPortText
                        implicitWidth: 60
                        inputMethodHints: Qt.ImhDigitsOnly
                        validator: QtRegExpValidator { regExp: /\d+/ }
                        text: App.settings.dmcore.value(DmCoreSettings.BtSessionPort)
                        onTextChanged: applySettings()
                    }
                }

                SwitchSetting {
                    description: App.my_BT_qsTranslate("Settings", "Use UPnP / NAT-PMP port forwarding") + App.loc.emptyString
                    switchChecked: App.settings.toBool(App.settings.dmcore.value(DmCoreSettings.BtEnablePortForwarding))
                    onClicked: {
                        switchChecked = !switchChecked;
                        App.settings.dmcore.setValue(DmCoreSettings.BtEnablePortForwarding,
                                                     App.settings.fromBool(switchChecked));
                    }
                }

                SettingsSeparator{}

                SwitchSetting {
                    id: enableTrackerList
                    description: App.my_BT_qsTranslate("Settings", "Enable list of predefined trackers") + App.loc.emptyString
                    switchChecked: parseInt(App.settings.dmcore.value(DmCoreSettings.BtEnableTrackerList))
                    onClicked: {
                        switchChecked = !switchChecked;
                        App.settings.dmcore.setValue(
                                    DmCoreSettings.BtEnableTrackerList,
                                    App.settings.fromBool(switchChecked));
                        if (!switchChecked)
                            trackerList.forceActiveFocus();
                        else
                            enableTrackerList.forceActiveFocus();
                    }
                }

                Column
                {
                    visible: enableTrackerList.switchChecked

                    width: root.width

                    spacing: 10

                    BaseLabel
                    {
                        anchors.left: parent.left
                        anchors.leftMargin: 20
                        text: qsTr("The use of additional trackers can improve download speed in some cases. Lists of such trackers can be retrieved from different sources, e.g. from <a href='https://github.com/ngosang/trackerslist'>here</a>.") + App.loc.emptyString
                        width: parent.width - 2*20
                        wrapMode: Text.WordWrap
                        onLinkActivated: Qt.openUrlExternally(link)
                    }

                    BaseStringListArea
                    {
                        id: trackerList
                        anchors.left: parent.left
                        anchors.leftMargin: 20
                        width: parent.width - 2*20
                        height: 200
                        isValidItem: function(str) {
                            return str.startsWith("http://") ||
                                    str.startsWith("https://") ||
                                    str.startsWith("udp://") ||
                                    str.startsWith("ws://") ||
                                    str.startsWith("wss://");
                        }
                        Component.onCompleted: {
                            setString(App.settings.dmcore.value(DmCoreSettings.BtTrackerList));
                        }
                        Component.onDestruction: {
                            App.settings.dmcore.setValue(
                                        DmCoreSettings.BtTrackerList,
                                        getString());
                        }
                    }
                }

                SettingsSeparator{}

                Item {
                    width: 1
                    height: 20
                }

//-- contentColumn content - END ---------------------------------------------------------------------
            }

        }
    }

    function applySettings()
    {
        var port = 0;

        if (!useSystemDefinedPort.switchChecked && customPortText.text)
            port = parseInt(customPortText.text) || 0;

        if (port >= 0 && port <= 65535)
        {
            App.settings.dmcore.setValue(
                        DmCoreSettings.BtSessionPort,
                        port);
        }
    }
}



