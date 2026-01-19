import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm

import "../../common/Tools"
import "../BaseElements"
import "../../common"

BaseDialog {
    id: root

    readonly property int firstColWidth: 20*appWindow.zoom + 60*appWindow.fontZoom

    title: qsTr("Authentication required") + App.loc.emptyString

    contentItem: BaseDialogItem {        

        Keys.onEscapePressed: {
            downloadTools.rejectAuth();
            root.close();
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 10*appWindow.zoom

            ColumnLayout {
                Layout.fillWidth: true
                Layout.leftMargin: qtbug.leftMargin(root.firstColWidth, 0)
                Layout.rightMargin: qtbug.rightMargin(root.firstColWidth, 0)

                BaseLabel {
                    Layout.fillWidth: true
                    text: downloadTools.authProxyText
                    wrapMode: Text.Wrap
                    Layout.minimumHeight: 10*appWindow.zoom
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
                    Layout.preferredWidth: root.firstColWidth
                    text: qsTr("Username:") + App.loc.emptyString
                }

                BaseTextField {
                    id: usernameField
                    focus: true
                    Layout.preferredWidth: 400*appWindow.zoom
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
                    Layout.preferredWidth: root.firstColWidth
                    text: qsTr("Password:") + App.loc.emptyString
                }

                BaseTextField {
                    id: passField
                    focus: true
                    inputMethodHints: Qt.ImhHiddenText
                    echoMode: TextInput.Password
                    passwordMaskDelay: 0
                    Layout.preferredWidth: 400*appWindow.zoom
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
                Layout.leftMargin: qtbug.leftMargin(root.firstColWidth, 0)
                Layout.rightMargin: qtbug.rightMargin(root.firstColWidth, 0)
            }

            RowLayout {
                Layout.topMargin: 10*appWindow.zoom
                Layout.alignment: Qt.AlignRight

                spacing: 5*appWindow.zoom

                BaseButton {
                    id: cnclBtn
                    text: qsTr("Cancel") + App.loc.emptyString
                    onClicked: {
                        downloadTools.rejectAuth();
                        root.close();
                    }
                }

                BaseButton {
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

    onCloseClick: {
        downloadTools.rejectAuth();
        root.close();
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
