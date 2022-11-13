import QtQuick 2.11
import QtQuick.Controls 2.3
import org.freedownloadmanager.fdm 1.0
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
                    }
                }

                Row {
                    visible: !useSystemDefinedPort.switchChecked
                    leftPadding: 40
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
                    }
                }

                Column
                {
                    visible: enableTrackerList.switchChecked

                    leftPadding: 20
                    width: root.width - leftPadding

                    spacing: 10

                    BaseLabel
                    {
                        text: qsTr("The use of additional trackers can improve download speed in some cases. Lists of such trackers can be retrieved from different sources, e.g. from <a href='https://github.com/ngosang/trackerslist'>here</a>.") + App.loc.emptyString
                        width: parent.width
                        wrapMode: Text.WordWrap
                        onLinkActivated: Qt.openUrlExternally(link)
                    }

                    BaseStringListArea
                    {
                        id: trackerList
                        width: parent.width
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



