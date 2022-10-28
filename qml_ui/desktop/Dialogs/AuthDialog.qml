import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0
import "../BaseElements"

BaseDialog {
    id: root

    property string remoteName
    property string realm
    property bool passwordOnly: false
    property alias user: usernameField.text
    property alias password: passField.text
    property alias save: rememberField.checked

    width: 542*appWindow.zoom

    contentItem: BaseDialogItem {
        titleText: qsTr("Authentication required") + App.loc.emptyString

        onCloseClick: {
            root.reject();
        }

        Keys.onEscapePressed: {
            root.reject();
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 10*appWindow.zoom
            Layout.rightMargin: 10*appWindow.zoom
            spacing: 10*appWindow.zoom

            ColumnLayout {
                Layout.fillWidth: true
                Layout.leftMargin: 80*appWindow.zoom

                BaseLabel {
                    visible: remoteName
                    Layout.fillWidth: true
                    text: qsTr("%1 requires authentication").arg(remoteName) + App.loc.emptyString
                    wrapMode: Text.Wrap
                    Layout.minimumHeight: 10*appWindow.zoom
                }
                BaseLabel {
                    visible: realm
                    Layout.fillWidth: true
                    text: qsTr("The site says: \"%1\".").arg(realm) + App.loc.emptyString
                    wrapMode: Text.Wrap
                }
            }

            RowLayout {
                visible: !passwordOnly

                Layout.fillWidth: true

                BaseLabel {
                    Layout.preferredWidth: 80*appWindow.zoom
                    text: qsTr("Username:") + App.loc.emptyString
                }

                BaseTextField {
                    id: usernameField
                    focus: !passwordOnly
                    Layout.preferredWidth: 400*appWindow.zoom
                    onAccepted: root.accept()
                    Keys.onEscapePressed: root.reject()
                }
            }

            RowLayout {
                Layout.fillWidth: true

                BaseLabel {
                    Layout.preferredWidth: 80*appWindow.zoom
                    text: qsTr("Password:") + App.loc.emptyString
                }

                BaseTextField {
                    id: passField
                    focus: passwordOnly
                    inputMethodHints: Qt.ImhHiddenText
                    echoMode: TextInput.Password
                    passwordMaskDelay: 0
                    Layout.preferredWidth: 400*appWindow.zoom
                    onAccepted: root.accept()
                    Keys.onEscapePressed: root.reject()
                }
            }

            BaseCheckBox {
                id: rememberField
                text: qsTr("remember") + App.loc.emptyString
                Layout.leftMargin: 80*appWindow.zoom
            }

            RowLayout {
                Layout.topMargin: 10*appWindow.zoom
                Layout.bottomMargin: 10*appWindow.zoom
                Layout.alignment: Qt.AlignRight

                spacing: 5*appWindow.zoom

                CustomButton {
                    id: cnclBtn
                    text: qsTr("Cancel") + App.loc.emptyString
                    onClicked: root.reject()
                }

                CustomButton {
                    text: qsTr("OK") + App.loc.emptyString
                    blueBtn: true
                    alternateBtnPressed: cnclBtn.isPressed
                    onClicked: root.accept()
                }
            }
        }
    }
}
