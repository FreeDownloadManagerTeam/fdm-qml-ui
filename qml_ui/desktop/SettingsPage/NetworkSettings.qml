import QtQuick 2.11
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.appsettings 1.0
import org.freedownloadmanager.fdm.dmcoresettings 1.0
import "../../qt5compat"
import "../BaseElements"

Column {
    property int proxyMode: parseInt(App.settings.app.value(AppSettings.NetworkProxyMode)) || 0

    spacing: 0

    SettingsGroupHeader {
        text: qsTr("Network") + App.loc.emptyString
    }

    SettingsGroupColumn {

        anchors.left: parent.left

        SettingsSubgroupHeader {
            anchors.left: parent.left
            text: qsTr("Proxy") + App.loc.emptyString
        }

        SettingsRadioButton {
            id: systemProxy
            text: qsTr("System proxy") + App.loc.emptyString
            checked: proxyMode === AppSettings.SystemProxy
            onClicked: tryApplyProxySettings()
        }

        SettingsRadioButton {
            id: noProxy
            text: qsTr("No proxy") + App.loc.emptyString
            checked: proxyMode === AppSettings.NoProxy
            onClicked: tryApplyProxySettings()
        }

        SettingsRadioButton {
            id: manualProxy
            text: qsTr("Configure manually") + App.loc.emptyString
            checked: proxyMode === AppSettings.ManualProxy
            onClicked: tryApplyProxySettings()
        }

        Rectangle { color: "transparent"; height: 1*appWindow.zoom; width: 1*appWindow.zoom}

        GridLayout {
            visible: manualProxy.checked

            columns: 4
            enabled: manualProxy.checked
            anchors.left: parent.left
            anchors.leftMargin: 40*appWindow.zoom

            Label {text: " "}
            SettingsGridLabel { text: qsTr("Address") + App.loc.emptyString }
            SettingsGridLabel {}
            SettingsGridLabel { text: qsTr("Port") + App.loc.emptyString }

            SettingsGridLabel { text: qsTr("HTTP:") + App.loc.emptyString }
            SettingsTextField {
                id: httpHost
                text: App.settings.app.value(AppSettings.Http_ProxyHost)
                implicitWidth: 145*appWindow.zoom
                onTextChanged: tryApplyProxySettingsTimer.restart()
            }
            SettingsGridLabel { text: qsTr(":") + App.loc.emptyString }
            SettingsTextField {
                id: httpPort
                text: App.settings.app.value(AppSettings.Http_ProxyPort)
                implicitWidth: 55*appWindow.zoom
                inputMethodHints: Qt.ImhDigitsOnly
                validator: QtRegExpValidator { regExp: /\d+/ }
                onTextChanged: tryApplyProxySettingsTimer.restart()
            }

            SettingsGridLabel { text: qsTr("HTTPS:") + App.loc.emptyString }
            SettingsTextField {
                id: httpsHost
                text: App.settings.app.value(AppSettings.Https_ProxyHost)
                implicitWidth: 145*appWindow.zoom
                onTextChanged: tryApplyProxySettingsTimer.restart()
            }
            SettingsGridLabel { text: qsTr(":") + App.loc.emptyString }
            SettingsTextField {
                id: httpsPort
                text: App.settings.app.value(AppSettings.Https_ProxyPort)
                implicitWidth: 55*appWindow.zoom
                inputMethodHints: Qt.ImhDigitsOnly
                validator: QtRegExpValidator { regExp: /\d+/ }
                onTextChanged: tryApplyProxySettingsTimer.restart()
            }

            SettingsGridLabel { text: qsTr("FTP:") + App.loc.emptyString }
            SettingsTextField {
                id: ftpHost
                text: App.settings.app.value(AppSettings.Ftp_ProxyHost)
                implicitWidth: 145*appWindow.zoom
                onTextChanged: tryApplyProxySettingsTimer.restart()
            }
            SettingsGridLabel {text: qsTr(":") + App.loc.emptyString}
            SettingsTextField {
                id: ftpPort
                text: App.settings.app.value(AppSettings.Ftp_ProxyPort)
                implicitWidth: 55*appWindow.zoom
                inputMethodHints: Qt.ImhDigitsOnly
                validator: QtRegExpValidator { regExp: /\d+/ }
                onTextChanged: tryApplyProxySettingsTimer.restart()
            }

            SettingsGridLabel { text: qsTr("SOCKS5:") + App.loc.emptyString }
            SettingsTextField {
                id: socks5Host
                text: App.settings.app.value(AppSettings.Socks5_ProxyHost)
                implicitWidth: 145*appWindow.zoom
                onTextChanged: tryApplyProxySettingsTimer.restart()
            }
            SettingsGridLabel {text: qsTr(":") + App.loc.emptyString}
            SettingsTextField {
                id: socks5Port
                text: App.settings.app.value(AppSettings.Socks5_ProxyPort)
                implicitWidth: 55*appWindow.zoom
                inputMethodHints: Qt.ImhDigitsOnly
                validator: QtRegExpValidator { regExp: /\d+/ }
                onTextChanged: tryApplyProxySettingsTimer.restart()
            }
        }

        Timer
        {
            id: tryApplyProxySettingsTimer
            interval: 500
            repeat: false
            onTriggered: tryApplyProxySettings()
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
