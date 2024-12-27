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

            GridLayout {
                Layout.fillWidth: true
                columns: 2
                columnSpacing: 10*appWindow.zoom

                Item {visible: remoteName; Layout.preferredHeight: 1; Layout.fillWidth: true}
                BaseLabel {
                    visible: remoteName
                    Layout.fillWidth: true
                    text: qsTr("%1 requires authentication").arg(remoteName) + App.loc.emptyString
                    wrapMode: Text.Wrap
                    Layout.minimumHeight: 10*appWindow.zoom
                }

                Item {visible: realm; Layout.preferredHeight: 1; Layout.fillWidth: true}
                BaseLabel {
                    visible: realm
                    Layout.fillWidth: true
                    text: qsTr("The site says: \"%1\".").arg(realm) + App.loc.emptyString
                    wrapMode: Text.Wrap
                }

                BaseLabel {
                    visible: !passwordOnly
                    text: qsTr("Username:") + App.loc.emptyString
                }

                BaseTextField {
                    visible: !passwordOnly
                    id: usernameField
                    focus: !passwordOnly
                    Layout.preferredWidth: 400*appWindow.zoom
                    Layout.fillWidth: true
                    onAccepted: root.accept()
                    Keys.onEscapePressed: root.reject()
                }

                BaseLabel {
                    text: qsTr("Password:") + App.loc.emptyString
                }

                BaseTextField {
                    id: passField
                    focus: passwordOnly
                    inputMethodHints: Qt.ImhHiddenText
                    echoMode: TextInput.Password
                    passwordMaskDelay: 0
                    Layout.preferredWidth: 400*appWindow.zoom
                    Layout.fillWidth: true
                    onAccepted: root.accept()
                    Keys.onEscapePressed: root.reject()
                }

                Item {Layout.preferredHeight: 1; Layout.fillWidth: true}
                BaseCheckBox {
                    id: rememberField
                    text: qsTr("remember") + App.loc.emptyString
                    xOffset: 0
                }
            }

            RowLayout {
                Layout.topMargin: 10*appWindow.zoom
                Layout.bottomMargin: 10*appWindow.zoom
                Layout.alignment: Qt.AlignRight

                spacing: 5*appWindow.zoom

                BaseButton {
                    id: cnclBtn
                    text: qsTr("Cancel") + App.loc.emptyString
                    onClicked: root.reject()
                }

                BaseButton {
                    text: qsTr("OK") + App.loc.emptyString
                    blueBtn: true
                    alternateBtnPressed: cnclBtn.isPressed
                    onClicked: root.accept()
                }
            }
        }
    }
}
