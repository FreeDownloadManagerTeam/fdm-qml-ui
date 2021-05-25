import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0

import "../../common/Tools"
import "../BaseElements"
import "../../common"

BaseDialog {
    id: root

    width: 542

    contentItem: BaseDialogItem {
        titleText: qsTr("Authentication required") + App.loc.emptyString

        onCloseClick: {
            downloadTools.rejectAuth();
            root.close();
        }

        Keys.onEscapePressed: {
            downloadTools.rejectAuth();
            root.close();
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 10
            Layout.rightMargin: 10
            spacing: 10

            ColumnLayout {
                Layout.fillWidth: true
                Layout.leftMargin: 80

                BaseLabel {
                    Layout.fillWidth: true
                    text: downloadTools.authProxyText
                    wrapMode: Text.Wrap
                    Layout.minimumHeight: 10
                }
                BaseLabel {
                    visible: downloadTools.authRealm.length > 0
                    Layout.fillWidth: true
                    text: qsTr("The site says: \"%1\".").arg(downloadTools.authRealm) + App.loc.emptyString
                    wrapMode: Text.Wrap
                }
            }

            RowLayout {
                Layout.fillWidth: true

                BaseLabel {
                    Layout.preferredWidth: 80
                    text: qsTr("Username:") + App.loc.emptyString
                }

                BaseTextField {
                    id: usernameField
                    focus: true
                    Layout.preferredWidth: 400
                    onAccepted: {
                        downloadTools.doAuth(usernameField.text, passField.text, rememberField.checked)
                        root.close();
                    }
                    Keys.onEscapePressed: {
                        downloadTools.rejectAuth();
                        root.close();
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true

                BaseLabel {
                    Layout.preferredWidth: 80
                    text: qsTr("Password:") + App.loc.emptyString
                }

                BaseTextField {
                    id: passField
                    focus: true
                    inputMethodHints: Qt.ImhHiddenText
                    echoMode: TextInput.Password
                    passwordMaskDelay: 100
                    Layout.preferredWidth: 400
                    onAccepted: {
                        downloadTools.doAuth(usernameField.text, passField.text, rememberField.checked)
                        root.close();
                    }
                    Keys.onEscapePressed: {
                        downloadTools.rejectAuth();
                        root.close();
                    }
                }
            }

            BaseCheckBox {
                id: rememberField
                text: qsTr("remember") + App.loc.emptyString
                Layout.leftMargin: 80
            }

            RowLayout {
                Layout.topMargin: 10
                Layout.bottomMargin: 10
                Layout.alignment: Qt.AlignRight

                spacing: 5

                CustomButton {
                    id: cnclBtn
                    text: qsTr("Cancel") + App.loc.emptyString
                    onClicked: {
                        downloadTools.rejectAuth();
                        root.close();
                    }
                }

                CustomButton {
                    text: qsTr("OK") + App.loc.emptyString
                    blueBtn: true
                    alternateBtnPressed: cnclBtn.isPressed
                    onClicked: {
                        downloadTools.doAuth(usernameField.text, passField.text, rememberField.checked)
                        root.close();
                    }
                }
            }
        }
    }

    BuildDownloadTools {
        id: downloadTools
    }

    onClosed: {appWindow.appWindowStateChanged();}

    function newAuthenticationRequest(request)
    {
        usernameField.text = "";
        passField.text = "";
        rememberField.checked = false;
        downloadTools.buildAuthenticationDialog(request);
        root.open();
        forceActiveFocus();
    }
}
