import QtQuick 2.11
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.dmcoresettings 1.0
import org.freedownloadmanager.fdm.appsettings 1.0
import "../BaseElements/"

Page {
    id: root


    //property string lastInvalidSettingsMessage: ""

    header: PageHeaderWithBackArrow {
        pageTitle: qsTr("Proxy settings") + App.loc.emptyString
        //onPopPage: root.StackView.view.pop()
        onPopPage:  {
            invalidSettingsMessageDialog.lastInvalidSettingsMessage = proxysettings.invalidSettingsMessage();
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
            contentHeight: contentColumn.height

            clip: true

            Item {
                id: contentColumn

                readonly property int myPadding: 20

                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: myPadding + (appWindow.showBordersInDownloadsList ? settingsWraper.width * 0.1 : 0)
                    rightMargin: myPadding + (appWindow.showBordersInDownloadsList ? settingsWraper.width * 0.1 : 0)
                }

                implicitWidth: proxysettings.implicitWidth
                implicitHeight: proxysettings.implicitHeight

//-- contentColumn content - BEGIN -------------------------------------------------------------------
                Column
                {
                    id: proxysettings
                    property int proxyMode: parseInt(App.settings.app.value(AppSettings.NetworkProxyMode)) || 0

                    width: parent.width

                    spacing: 10

                    Item {
                        width: 1
                        height: Math.max(contentColumn.myPadding - parent.spacing, 0)
                    }

                    Column
                    {
                        anchors.left: parent.left

                        SettingsRadioButton
                        {
                            id: systemProxy
                            anchors.left: parent.left
                            text: qsTr("System proxy") + App.loc.emptyString
                            checked: proxysettings.proxyMode === AppSettings.SystemProxy
                            onClicked: proxysettings.tryApplyProxySettings()
                        }

                        SettingsRadioButton
                        {
                            id: noProxy
                            anchors.left: parent.left
                            text: qsTr("No proxy") + App.loc.emptyString
                            checked: proxysettings.proxyMode === AppSettings.NoProxy
                            onClicked: proxysettings.tryApplyProxySettings()
                        }

                        SettingsRadioButton
                        {
                            id: manualProxy
                            anchors.left: parent.left
                            text: qsTr("Configure manually:") + App.loc.emptyString
                            checked: proxysettings.proxyMode === AppSettings.ManualProxy
                            onClicked: proxysettings.tryApplyProxySettings()
                        }

                        Column
                        {
                            enabled: manualProxy.checked

                            opacity: manualProxy.checked ? 1 : 0.5

                            anchors.left: parent.left

                            Label
                            {
                                anchors.left: parent.left
                                font.bold: true
                                font.pixelSize: 13
                                text: qsTr("HTTP") + App.loc.emptyString
                                bottomPadding: 10
                                topPadding: 30
                                color: appWindow.theme.foreground
                                horizontalAlignment: Text.AlignLeft
                            }

                            Column
                            {
                                anchors.left: parent.left
                                spacing: 10

                                BaseTextField
                                {
                                    id: httpHost
                                    text: App.settings.app.value(AppSettings.Http_ProxyHost)
                                    width: 200
                                    onDisplayTextChanged: tryApplyProxySettingsTimer.restart()
                                    placeholderText: qsTr("Address") + App.loc.emptyString
                                    placeholderTextColor: appWindow.theme.settingsPlaceholder
                                    inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText | Qt.ImhSensitiveData
                                    anchors.left: parent.left
                                    horizontalAlignment: Text.AlignLeft
                                }
                                BaseTextField
                                {
                                    id: httpPort
                                    text: App.settings.app.value(AppSettings.Http_ProxyPort)
                                    width: 200
                                    inputMethodHints: Qt.ImhDigitsOnly | Qt.ImhNoPredictiveText | Qt.ImhSensitiveData
                                    onDisplayTextChanged: tryApplyProxySettingsTimer.restart()
                                    placeholderText: qsTr("Port") + App.loc.emptyString
                                    placeholderTextColor: appWindow.theme.settingsPlaceholder
                                    anchors.left: parent.left
                                    horizontalAlignment: Text.AlignLeft

                                }
                            }

                            Label
                            {
                                font.bold: true
                                font.pixelSize: 13
                                text: qsTr("HTTPS") + App.loc.emptyString
                                bottomPadding: 10
                                topPadding: 20
                                color: appWindow.theme.foreground
                                anchors.left: parent.left
                                horizontalAlignment: Text.AlignLeft
                            }

                            Column
                            {
                                anchors.left: parent.left
                                spacing: 10

                                BaseTextField
                                {
                                    id: httpsHost
                                    text: App.settings.app.value(AppSettings.Https_ProxyHost)
                                    width: 200
                                    onDisplayTextChanged: tryApplyProxySettingsTimer.restart()
                                    placeholderText: qsTr("Address") + App.loc.emptyString
                                    placeholderTextColor: appWindow.theme.settingsPlaceholder
                                    inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText | Qt.ImhSensitiveData
                                    anchors.left: parent.left
                                    horizontalAlignment: Text.AlignLeft
                                }
                                BaseTextField
                                {
                                    id: httpsPort
                                    text: App.settings.app.value(AppSettings.Https_ProxyPort)
                                    width: 200
                                    inputMethodHints: Qt.ImhDigitsOnly | Qt.ImhNoPredictiveText | Qt.ImhSensitiveData
                                    onDisplayTextChanged: tryApplyProxySettingsTimer.restart()
                                    placeholderText: qsTr("Port") + App.loc.emptyString
                                    placeholderTextColor: appWindow.theme.settingsPlaceholder
                                    anchors.left: parent.left
                                    horizontalAlignment: Text.AlignLeft
                                }
                            }
                            Label
                            {
                                font.bold: true
                                font.pixelSize: 13
                                text: qsTr("FTP") + App.loc.emptyString
                                bottomPadding: 10
                                topPadding: 20
                                color: appWindow.theme.foreground
                                anchors.left: parent.left
                                horizontalAlignment: Text.AlignLeft
                            }
                            Column
                            {
                                anchors.left: parent.left
                                spacing: 10

                                BaseTextField
                                {
                                    id: ftpHost
                                    text: App.settings.app.value(AppSettings.Ftp_ProxyHost)
                                    width: 200
                                    onDisplayTextChanged: tryApplyProxySettingsTimer.restart()
                                    placeholderText: qsTr("Address") + App.loc.emptyString
                                    placeholderTextColor: appWindow.theme.settingsPlaceholder
                                    inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText | Qt.ImhSensitiveData
                                    anchors.left: parent.left
                                    horizontalAlignment: Text.AlignLeft
                                }
                                BaseTextField
                                {
                                    id: ftpPort
                                    text: App.settings.app.value(AppSettings.Ftp_ProxyPort)
                                    width: 200
                                    inputMethodHints: Qt.ImhDigitsOnly | Qt.ImhNoPredictiveText | Qt.ImhSensitiveData
                                    onDisplayTextChanged: tryApplyProxySettingsTimer.restart()
                                    placeholderText: qsTr("Port") + App.loc.emptyString
                                    placeholderTextColor: appWindow.theme.settingsPlaceholder
                                    anchors.left: parent.left
                                    horizontalAlignment: Text.AlignLeft
                                }
                            }
                            Label
                            {
                                font.bold: true
                                font.pixelSize: 13
                                text: qsTr("SOCKS5") + App.loc.emptyString
                                bottomPadding: 10
                                topPadding: 20
                                color: appWindow.theme.foreground
                                anchors.left: parent.left
                                horizontalAlignment: Text.AlignLeft
                            }
                            Column
                            {
                                anchors.left: parent.left
                                spacing: 10

                                BaseTextField
                                {
                                    id: socks5Host
                                    text: App.settings.app.value(AppSettings.Socks5_ProxyHost)
                                    width: 200
                                    onDisplayTextChanged: tryApplyProxySettingsTimer.restart()
                                    placeholderText: qsTr("Address") + App.loc.emptyString
                                    placeholderTextColor: appWindow.theme.settingsPlaceholder
                                    inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText | Qt.ImhSensitiveData
                                    anchors.left: parent.left
                                    horizontalAlignment: Text.AlignLeft
                                }
                                BaseTextField
                                {
                                    id: socks5Port
                                    text: App.settings.app.value(AppSettings.Socks5_ProxyPort)
                                    width: 200
                                    inputMethodHints: Qt.ImhDigitsOnly | Qt.ImhNoPredictiveText | Qt.ImhSensitiveData
                                    onDisplayTextChanged: tryApplyProxySettingsTimer.restart()
                                    placeholderText: qsTr("Port") + App.loc.emptyString
                                    placeholderTextColor: appWindow.theme.settingsPlaceholder
                                    anchors.left: parent.left
                                    horizontalAlignment: Text.AlignLeft
                                }
                            }
                        }

                        Timer
                        {
                            id: tryApplyProxySettingsTimer
                            interval: 500
                            repeat: false
                            onTriggered: proxysettings.tryApplyProxySettings()
                        }
                    }

                    Item {
                        width: 1
                        height: contentColumn.myPadding
                    }

                    function protocolProxySettingsValid(
                        host, port)
                    {
                        return host.text === "" ||
                            (/^\d+$/.test(port.text) &&
                                parseInt(port.text) > 0 && parseInt(port.text) <= 65535);
                    }

                    function proxySettingsValid()
                    {
                        return systemProxy.checked ||
                                noProxy.checked ||
                                (manualProxy.checked &&
                                 protocolProxySettingsValid(httpHost, httpPort) &&
                                 protocolProxySettingsValid(httpsHost, httpsPort) &&
                                 protocolProxySettingsValid(ftpHost, ftpPort) &&
                                 protocolProxySettingsValid(socks5Host, socks5Port) &&
                                 (httpHost.text !== "" || httpsHost.text !== "" || ftpHost.text !== "" || socks5Host.text !== ""));
                    }

                    function invalidSettingsMessage()
                    {
                        if (!proxySettingsValid())
                            return qsTr("Invalid proxy settings") + App.loc.emptyString;
                        return "";
                    }

                    function tryApplyProxySettings()
                    {
                        if (!proxySettingsValid())
                            return;

                        if (systemProxy.checked)
                        {
                            App.settings.app.setValue(AppSettings.NetworkProxyMode,
                                                      AppSettings.SystemProxy);

                        }
                        else if (noProxy.checked)
                        {
                            App.settings.app.setValue(AppSettings.NetworkProxyMode,
                                                      AppSettings.NoProxy);
                        }
                        else if (manualProxy.checked)
                        {
                            App.settings.app.setManualProxy(
                                        httpHost.text, httpHost.text ? httpPort.text : "", "", "",
                                        httpsHost.text, httpsHost.text ? httpsPort.text : "", "", "",
                                        ftpHost.text, ftpHost.text ? ftpPort.text : "", "", "",
                                        socks5Host.text, socks5Host.text ? socks5Port.text : "", "", "");
                        }
                    }
                }
//-- contentColumn content - END ---------------------------------------------------------------------
            }

        }
    }
}

