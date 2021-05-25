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

            Column {
                id: contentColumn
                anchors.left: parent.left
                anchors.right: parent.right
                topPadding: 20
                bottomPadding: 20

                anchors.leftMargin: appWindow.showBordersInDownloadsList ? settingsWraper.width * 0.1 : 0
                anchors.rightMargin: appWindow.showBordersInDownloadsList ? settingsWraper.width * 0.1 : 0

//-- contentColumn content - BEGIN -------------------------------------------------------------------
                Column
                {
                    id: proxysettings
                    property int proxyMode: parseInt(App.settings.dmcore.value(DmCoreSettings.NetworkProxyMode)) || 0

                    spacing: 10

                    Column
                    {
                        leftPadding: 20
                        rightPadding: 20

                        SettingsRadioButton
                        {
                            id: systemProxy
                            text: qsTr("System proxy") + App.loc.emptyString
                            checked: proxysettings.proxyMode === DmCoreSettings.SystemProxy
                            onClicked: proxysettings.tryApplyProxySettings()
                        }

                        SettingsRadioButton
                        {
                            id: noProxy
                            text: qsTr("No proxy") + App.loc.emptyString
                            checked: proxysettings.proxyMode === DmCoreSettings.NoProxy
                            onClicked: proxysettings.tryApplyProxySettings()
                        }

                        SettingsRadioButton
                        {
                            id: manualProxy
                            text: qsTr("Configure manually:") + App.loc.emptyString
                            checked: proxysettings.proxyMode === DmCoreSettings.ManualProxy
                            onClicked: proxysettings.tryApplyProxySettings()
                        }

                        Column
                        {
                            enabled: manualProxy.checked

                            opacity: manualProxy.checked ? 1 : 0.5

                            Label
                            {
                                font.bold: true
                                font.pixelSize: 13
                                text: qsTr("HTTP") + App.loc.emptyString
                                bottomPadding: 10
                                topPadding: 30
                                color: appWindow.theme.foreground
                            }

                            Column
                            {

                                TextField
                                {
                                    id: httpHost
                                    text: App.settings.dmcore.value(DmCoreSettings.Http_ProxyHost)
                                    width: 200
                                    onDisplayTextChanged: tryApplyProxySettingsTimer.restart()
                                    placeholderText: qsTr("Address") + App.loc.emptyString
                                    placeholderTextColor: appWindow.theme.settingsPlaceholder
                                    inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText | Qt.ImhSensitiveData
                                }
                                TextField
                                {
                                    id: httpPort
                                    text: App.settings.dmcore.value(DmCoreSettings.Http_ProxyPort)
                                    width: 200
                                    inputMethodHints: Qt.ImhDigitsOnly | Qt.ImhNoPredictiveText | Qt.ImhSensitiveData
                                    onDisplayTextChanged: tryApplyProxySettingsTimer.restart()
                                    placeholderText: qsTr("Port") + App.loc.emptyString
                                    placeholderTextColor: appWindow.theme.settingsPlaceholder

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
                            }

                            Column
                            {
                                TextField
                                {
                                    id: httpsHost
                                    text: App.settings.dmcore.value(DmCoreSettings.Https_ProxyHost)
                                    width: 200
                                    onDisplayTextChanged: tryApplyProxySettingsTimer.restart()
                                    placeholderText: qsTr("Address") + App.loc.emptyString
                                    placeholderTextColor: appWindow.theme.settingsPlaceholder
                                    inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText | Qt.ImhSensitiveData
                                }
                                TextField
                                {
                                    id: httpsPort
                                    text: App.settings.dmcore.value(DmCoreSettings.Https_ProxyPort)
                                    width: 200
                                    inputMethodHints: Qt.ImhDigitsOnly | Qt.ImhNoPredictiveText | Qt.ImhSensitiveData
                                    onDisplayTextChanged: tryApplyProxySettingsTimer.restart()
                                    placeholderText: qsTr("Port") + App.loc.emptyString
                                    placeholderTextColor: appWindow.theme.settingsPlaceholder
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
                            }
                            Column
                            {
                                TextField
                                {
                                    id: ftpHost
                                    text: App.settings.dmcore.value(DmCoreSettings.Ftp_ProxyHost)
                                    width: 200
                                    onDisplayTextChanged: tryApplyProxySettingsTimer.restart()
                                    placeholderText: qsTr("Address") + App.loc.emptyString
                                    placeholderTextColor: appWindow.theme.settingsPlaceholder
                                    inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText | Qt.ImhSensitiveData
                                }
                                TextField
                                {
                                    id: ftpPort
                                    text: App.settings.dmcore.value(DmCoreSettings.Ftp_ProxyPort)
                                    width: 200
                                    inputMethodHints: Qt.ImhDigitsOnly | Qt.ImhNoPredictiveText | Qt.ImhSensitiveData
                                    onDisplayTextChanged: tryApplyProxySettingsTimer.restart()
                                    placeholderText: qsTr("Port") + App.loc.emptyString
                                    placeholderTextColor: appWindow.theme.settingsPlaceholder
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
                            }
                            Column
                            {
                                TextField
                                {
                                    id: socks5Host
                                    text: App.settings.dmcore.value(DmCoreSettings.Socks5_ProxyHost)
                                    width: 200
                                    onDisplayTextChanged: tryApplyProxySettingsTimer.restart()
                                    placeholderText: qsTr("Address") + App.loc.emptyString
                                    placeholderTextColor: appWindow.theme.settingsPlaceholder
                                    inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText | Qt.ImhSensitiveData
                                }
                                TextField
                                {
                                    id: socks5Port
                                    text: App.settings.dmcore.value(DmCoreSettings.Socks5_ProxyPort)
                                    width: 200
                                    inputMethodHints: Qt.ImhDigitsOnly | Qt.ImhNoPredictiveText | Qt.ImhSensitiveData
                                    onDisplayTextChanged: tryApplyProxySettingsTimer.restart()
                                    placeholderText: qsTr("Port") + App.loc.emptyString
                                    placeholderTextColor: appWindow.theme.settingsPlaceholder
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
                            App.settings.dmcore.setValue(DmCoreSettings.NetworkProxyMode,
                                                         DmCoreSettings.SystemProxy);

                        }
                        else if (noProxy.checked)
                        {
                            App.settings.dmcore.setValue(DmCoreSettings.NetworkProxyMode,
                                                         DmCoreSettings.NoProxy);
                        }
                        else if (manualProxy.checked)
                        {
                            App.settings.dmcore.setManualProxy(
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

