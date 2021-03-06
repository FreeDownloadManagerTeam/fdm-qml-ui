import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0
//import QtQuick.Controls.Material 2.4
import "../common/Tools"
import "BaseElements"
import "SettingsPage"

Page {
    id: root

    property string pageName: "AuthenticationPage"
    property var request: null
    property bool rememberStatus: false

    header: BaseToolBar {
        RowLayout {
            anchors.fill: parent

            ToolbarBackButton {
                onClicked: downloadTools.rejectAuth();
            }

            ToolbarLabel {
                text: qsTr("Authentication required") + App.loc.emptyString
                Layout.fillWidth: true
            }

            DialogButton {
                text: qsTr("OK") + App.loc.emptyString
                Layout.rightMargin: 10
                textColor: appWindow.theme.toolbarTextColor
                enabled: usernameField.displayText.length > 0
                onClicked: accept()
            }
        }
    }

    Column {
        anchors.fill: parent
        anchors.margins: 20
        anchors.leftMargin: appWindow.showBordersInDownloadsList ? parent.width * 0.1 : 20
        anchors.rightMargin: appWindow.showBordersInDownloadsList ? parent.width * 0.1 : 20
        spacing: 10

        Rectangle {
            width: parent.width
            height: enterColumn.height
            color: "transparent"

            Column {
                id:enterColumn
                spacing: 20
                width: parent.width

                Column {
                    spacing: 10
                    width: parent.width

                    Label
                    {
                        text: downloadTools.authProxyText
                        wrapMode: Text.Wrap
                        width: parent.width
                    }

                    Label
                    {
                        visible: downloadTools.authRealm.length > 0
                        text: qsTr("The site says: \"%1\".").arg(downloadTools.authRealm) + App.loc.emptyString
                        wrapMode: Text.Wrap
                        width: parent.width
                    }
                }

                Column {
                    spacing: 2
                    width: parent.width
                    Label
                    {
                        text: qsTr("Username") + App.loc.emptyString
                        font.pixelSize: 16
                        padding: 3
                    }

                    TextField
                    {
                        id: usernameField
                        anchors {
                            left: parent.left
                            right: parent.right
                        }
                        selectByMouse: true
                        onAccepted: accept()
                        focus: true
                        inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText | Qt.ImhSensitiveData
                    }

                    Label
                    {
                        text: qsTr("Password") + App.loc.emptyString
                        font.pixelSize: 16
                        padding: 3
                    }

                    TextField
                    {
                        id: passField
                        anchors {
                            left: parent.left
                            right: parent.right
                        }
                        selectByMouse: true
                        onAccepted: accept()
                        focus: true
                        inputMethodHints: Qt.ImhHiddenText
                        echoMode: TextInput.Password
                        passwordMaskDelay: 100
                    }

                    SwitchSetting {
                        id: rememberField
                        textMargins: 0
                        textHeighIncrement: 10
                        textFontSize: 16
                        description: qsTr("Remember") + App.loc.emptyString
                        switchChecked: rememberStatus
                        enabled: true
                        onClicked: {
                            rememberStatus = !rememberStatus
                        }
                    }
                }
            }
        }

        Rectangle {
            width: parent.width
            height: infoRow.height
            color: "transparent"

            Row
            {
                id: infoRow
                width: parent.width
                height: 40
                BusyIndicator
                {
                    visible: downloadTools.buildingDownload
                    running: downloadTools.buildingDownload
                    anchors.verticalCenter: parent.verticalCenter
                }

                Label
                {
                    id: status
                    anchors.verticalCenter: parent.verticalCenter
                    text: downloadTools.statusText
                    color: downloadTools.statusWarning ? appWindow.theme.errorMessage : appWindow.theme.successMessage
                }
            }
        }
    }

    function accept() {
        downloadTools.doAuth(usernameField.text, passField.text, rememberField.switchChecked)
        stackView.pop();
    }

    Component.onCompleted: {
        downloadTools.buildAuthenticationDialog(request);
    }

    BuildDownloadTools {
        id: downloadTools
        onReject: {
            stackView.pop();
        }
    }
}
