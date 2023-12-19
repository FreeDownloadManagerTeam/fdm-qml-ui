import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import org.freedownloadmanager.fdm 1.0
import "../../common"
import "../BaseElements"

CenteredDialog
{
    id: root

    readonly property bool isOkToSend: !App.bugReporter.sending &&
                                       title.text && description.text && isEmailOk(email.text)

    title: qsTr("Submit a bug report") + App.loc.emptyString

    contentItem: ColumnLayout
    {
        spacing: 10

        Layout.fillWidth: true
        Layout.minimumWidth: 300

        Layout.leftMargin: 10
        Layout.rightMargin: 10

        RowLayout {
            BaseLabel {
                text: qsTr("Title") + App.loc.emptyString
            }
            BaseLabel {
                text: "*"
                color: "red"
                font.pixelSize: 14
                font.bold: true
                Layout.alignment: Qt.AlignTop
            }
        }

        BaseTextField {
            id: title
            Layout.fillWidth: true
        }

        RowLayout {
            Layout.topMargin: 10
            BaseLabel {
                text: qsTr("Description") + App.loc.emptyString
            }
            BaseLabel {
                text: "*"
                color: "red"
                font.pixelSize: 14
                font.bold: true
                Layout.alignment: Qt.AlignTop
            }
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: 150

            TextArea {
                id: description
                wrapMode: TextArea.WordWrap
            }
        }

        BaseLabel {
            Layout.topMargin: 10
            text: qsTr("Name") + App.loc.emptyString
        }

        BaseTextField {
            id: name
            Layout.fillWidth: true
        }

        BaseLabel {
            Layout.topMargin: 10
            text: qsTr("E-mail") + App.loc.emptyString
        }

        BaseTextField {
            id: email
            Layout.fillWidth: true
            color: isEmailOk(text) ? appWindow.theme.foreground : appWindow.theme.errorMessage
        }

        BaseCheckBox {
            id: sendLogs
            text: qsTr("Attach %1 log files (recommended)").arg(App.shortDisplayName) + App.loc.emptyString
            Layout.topMargin: 10
            checked: true
        }

        BaseLabel {
            Layout.topMargin: 10
            text: App.bugReporter.error
            visible: text
            color: appWindow.theme.errorMessage
        }

        RowLayout {
            Layout.topMargin: 10
            Layout.bottomMargin: 10
            Layout.alignment: Qt.AlignRight

            RowLayout {
                opacity: 0.5
                BaseLabel {
                    text: "*"
                    color: "red"
                    font.pixelSize: 14
                    font.bold: true
                    Layout.alignment: Qt.AlignTop
                }
                BaseLabel {
                    text: qsTr("Required fields") + App.loc.emptyString
                }
            }

            Item {
                implicitHeight: 1
                implicitWidth: 1
                Layout.fillWidth: true
            }

            DialogButton {
                text: (App.bugReporter.sending ? qsTr("Close") : qsTr("Cancel")) + App.loc.emptyString
                onClicked: root.close()
            }

            DialogButton {
                enabled: root.isOkToSend
                text: (App.bugReporter.sending ? qsTr("Submitting") : qsTr("Submit")) + App.loc.emptyString
                onClicked: root.send()
            }
        }
    }

    onOpened: {
        App.bugReporter.clearError()
        title.forceActiveFocus()
    }

    onClosed: clear()

    function send()
    {
        if (!root.isOkToSend)
            return;

        App.bugReporter.send(title.text, description.text, name.text, email.text, sendLogs.checked)
    }

    function clear()
    {
        title.text = "";
        description.text = "";
        sendLogs.checked = true;
    }

    function isEmailOk(str)
    {
        return !str ||
                /\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/.test(str);
    }

    Connections {
        target: App.bugReporter
        onSendingChanged: if (!App.bugReporter.sending && !App.bugReporter.error) root.close()
    }
}
