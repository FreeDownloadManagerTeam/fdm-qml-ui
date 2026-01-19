import QtQuick
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import "../BaseElements"

BaseDialog
{
    id: root

    readonly property bool isOkToSend: !App.bugReporter.sending &&
                                       title.text.trim() && description.text.trim() && isEmailOk(email.text.trim())

    title: qsTr("Submit a bug report") + App.loc.emptyString

    onCloseClick: root.close()

    contentItem: BaseDialogItem
    {
        Keys.onEscapePressed: root.close()
        Keys.onReturnPressed: root.send()

        ColumnLayout
        {
            Layout.fillWidth: true
            Layout.minimumWidth: 300*appWindow.fontZoom

            spacing: 3*appWindow.zoom

            RowLayout {
                BaseLabel {
                    dialogLabel: true
                    text: qsTr("Title") + App.loc.emptyString
                }
                BaseLabel {
                    text: "*"
                    color: appWindow.uiver == 1 ?  "red" : appWindow.theme_v2.danger
                    font.bold: true
                    Layout.alignment: Qt.AlignTop
                }
            }

            BaseTextField {
                id: title
                Layout.fillWidth: true
            }

            RowLayout {
                Layout.topMargin: 10*appWindow.zoom
                BaseLabel {
                    dialogLabel: true
                    text: qsTr("Description") + App.loc.emptyString
                }
                BaseLabel {
                    text: "*"
                    color: appWindow.uiver == 1 ?  "red" : appWindow.theme_v2.danger
                    font.bold: true
                    Layout.alignment: Qt.AlignTop
                }
            }

            BaseTextArea {
                id: description
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredHeight: 150
                tabChangesFocus: true
                onEscapePressed: root.close()
            }

            RowLayout
            {
                spacing: 10*appWindow.zoom

                ColumnLayout
                {
                    spacing: 3*appWindow.zoom

                    BaseLabel {
                        dialogLabel: true
                        Layout.topMargin: 10*appWindow.zoom
                        text: qsTr("Name") + App.loc.emptyString
                    }

                    BaseTextField {
                        id: name
                        Layout.fillWidth: true
                    }
                }

                ColumnLayout
                {
                    spacing: 3*appWindow.zoom

                    RowLayout {
                        Layout.topMargin: 10*appWindow.zoom
                        BaseLabel {
                            dialogLabel: true
                            text: qsTr("E-mail") + App.loc.emptyString
                        }
                        BaseLabel {
                            text: "*"
                            color: appWindow.uiver == 1 ?  "red" : appWindow.theme_v2.danger
                            font.bold: true
                            Layout.alignment: Qt.AlignTop
                        }
                    }

                    BaseTextField {
                        id: email
                        Layout.fillWidth: true
                        color: isEmailOk(text) ? appWindow.theme.foreground : appWindow.theme.errorMessage
                    }
                }
            }

            BaseCheckBox {
                id: sendLogs
                text: qsTr("Attach %1 log files (recommended)").arg(App.shortDisplayName) + App.loc.emptyString
                Layout.topMargin: 10*appWindow.zoom
                xOffset: 0
                checked: true
            }

            BaseLabel {
                Layout.topMargin: 10*appWindow.zoom
                text: App.bugReporter.error
                visible: text
                color: appWindow.theme.errorMessage
            }

            RowLayout {
                Layout.topMargin: 10*appWindow.zoom
                Layout.alignment: Qt.AlignRight

                RowLayout {
                    opacity: 0.5
                    BaseLabel {
                        text: "*"
                        color: appWindow.uiver == 1 ?  "red" : appWindow.theme_v2.danger
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

                BaseButton {
                    id: cnclBtn
                    Layout.preferredHeight: height
                    useUppercase: appWindow.uiver !== 1
                    text: (App.bugReporter.sending ? qsTr("Close") : qsTr("Cancel")) + App.loc.emptyString
                    onClicked: root.close()
                }

                BaseButton {
                    id: okbtn
                    enabled: root.isOkToSend
                    Layout.preferredHeight: height
                    text: (App.bugReporter.sending ? qsTr("Submitting") : qsTr("Submit")) + App.loc.emptyString
                    blueBtn: true
                    alternateBtnPressed: cnclBtn.isPressed
                    onClicked: root.send()
                }
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

        App.bugReporter.send(title.text.trim(), description.text.trim(), name.text.trim(), email.text.trim(), sendLogs.checked)
    }

    function clear()
    {
        title.text = "";
        description.text = "";
        sendLogs.checked = true;
    }

    function isEmailOk(str)
    {
        return /\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/.test(str);
    }

    Connections {
        target: App.bugReporter
        onSendingChanged: if (!App.bugReporter.sending && !App.bugReporter.error) root.close()
    }
}
