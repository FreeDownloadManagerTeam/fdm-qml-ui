import QtQuick 2.10
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.11
import org.freedownloadmanager.fdm 1.0
import "../BaseElements"

Dialog {
    id: root

    property string remoteName
    property string realm
    property bool passwordOnly: false
    property alias user: usernameField.text
    property alias password: passField.text
    property alias save: rememberField.checked

    parent: appWindow.overlay

    x: Math.round((appWindow.width - width) / 2)
    y: Math.round((appWindow.height - height) / 2)

    title: qsTr("Authentication required") + App.loc.emptyString

    contentItem: ColumnLayout {

        ColumnLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 10
            Layout.rightMargin: 10
            spacing: 10

            ColumnLayout {
                visible:false
                Layout.fillWidth: true
                Layout.leftMargin: 80

                Label {
                    visible: remoteName
                    Layout.fillWidth: true
                    text: qsTr("%1 requires authentication").arg(remoteName) + App.loc.emptyString
                    wrapMode: Text.Wrap
                    Layout.minimumHeight: 10
                }
                Label {
                    visible: realm
                    Layout.fillWidth: true
                    text: qsTr("The site says: \"%1\".").arg(realm) + App.loc.emptyString
                    wrapMode: Text.Wrap
                }
            }

            RowLayout {
                visible: !passwordOnly

                Layout.fillWidth: true

                Label {
                    Layout.preferredWidth: 80
                    text: qsTr("Username:") + App.loc.emptyString
                }

                TextField {
                    id: usernameField
                    focus: !passwordOnly
                    Layout.preferredWidth: 400
                    onAccepted: root.accept()
                    Keys.onEscapePressed: root.reject()
                    inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText | Qt.ImhSensitiveData
                }
            }

            RowLayout {
                Layout.fillWidth: true

                Label {
                    Layout.preferredWidth: 80
                    text: qsTr("Password:") + App.loc.emptyString
                }

                TextField {
                    id: passField
                    focus: passwordOnly
                    inputMethodHints: Qt.ImhHiddenText | Qt.ImhNoPredictiveText | Qt.ImhSensitiveData
                    echoMode: TextInput.Password
                    passwordMaskDelay: 100
                    Layout.fillWidth: true
                    onAccepted: root.accept()
                    Keys.onEscapePressed: root.reject()
                }
            }

            BaseCheckBox {
                id: rememberField
                text: qsTr("remember") + App.loc.emptyString
            }

            RowLayout {
                Layout.topMargin: 10
                Layout.bottomMargin: 10
                Layout.alignment: Qt.AlignHCenter

                spacing: 5

                DialogButton {
                    id: cnclBtn
                    text: qsTr("Cancel") + App.loc.emptyString
                    onClicked: root.reject()
                }

                DialogButton {
                    text: qsTr("OK") + App.loc.emptyString
                    onClicked: root.accept()
                }
            }
        }
    }
}
