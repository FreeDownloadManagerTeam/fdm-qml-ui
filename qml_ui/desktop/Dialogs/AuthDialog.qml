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

    width: 542

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
            Layout.leftMargin: 10
            Layout.rightMargin: 10
            spacing: 10

            ColumnLayout {
                Layout.fillWidth: true
                Layout.leftMargin: 80

                BaseLabel {
                    visible: remoteName
                    Layout.fillWidth: true
                    text: qsTr("%1 requires authentication").arg(remoteName) + App.loc.emptyString
                    wrapMode: Text.Wrap
                    Layout.minimumHeight: 10
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
                    Layout.preferredWidth: 80
                    text: qsTr("Username:") + App.loc.emptyString
                }

                BaseTextField {
                    id: usernameField
                    focus: !passwordOnly
                    Layout.preferredWidth: 400
                    onAccepted: root.accept()
                    Keys.onEscapePressed: root.reject()
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
                    focus: passwordOnly
                    inputMethodHints: Qt.ImhHiddenText
                    echoMode: TextInput.Password
                    passwordMaskDelay: 100
                    Layout.preferredWidth: 400
                    onAccepted: root.accept()
                    Keys.onEscapePressed: root.reject()
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
