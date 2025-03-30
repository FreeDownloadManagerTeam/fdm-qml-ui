import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0
import "../BaseElements"
import "../../qt5compat"

BaseDialog {
    id: root

    readonly property string remoteId: idField.text.trim()
    readonly property bool isRemoteIdValid: remoteId !== '' && remoteId !== App.rc.id

    title: qsTr("Connect to remote %1").arg(App.shortDisplayName) + ' ' + qsTr("(beta)") + App.loc.emptyString
    onCloseClick: root.close()

    contentItem: BaseDialogItem {
        Keys.onEscapePressed: root.close()

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 10*appWindow.zoom

            DialogWrappedLabel {
                text: qsTr("Here you can connect to %1 running on another device.").arg(App.shortDisplayName) + App.loc.emptyString
                Layout.fillWidth: true
            }

            RowLayout {
                spacing: 10*appWindow.zoom

                Layout.fillWidth: true

                BaseLabel {
                    text: "ID:"
                }

                BaseTextField {
                    id: idField
                    text: uiSettingsTools.settings.lastRemoteAppId
                    focus: true
                    Layout.preferredWidth: 540*appWindow.zoom
                    onAccepted: {
                        if (root.isRemoteIdValid)
                            root.accept();
                    }
                    Keys.onEscapePressed: root.close()
                    onTextChanged: {
                        var s = text.toUpperCase();
                        if (text != s)
                            text = s;
                    }
                    enable_QTBUG_110471_workaround_2: true
                    selectAllAtInit: true
                }
            }

            BaseCheckBox {
                id: alwaysConnectOnAppStart
                text: qsTr("Automatically connect at startup") + App.loc.emptyString
                xOffset: 0
            }

            RowLayout {
                Layout.topMargin: 10*appWindow.zoom
                Layout.alignment: Qt.AlignRight
                Layout.fillWidth: true

                spacing: 5*appWindow.zoom

                BaseButton {
                    id: cnclBtn
                    text: qsTr("Cancel") + App.loc.emptyString
                    onClicked: root.close();
                    Layout.alignment: Qt.AlignRight
                }

                BaseButton {
                    text: qsTr("OK") + App.loc.emptyString
                    blueBtn: true
                    alternateBtnPressed: cnclBtn.isPressed
                    enabled: root.isRemoteIdValid
                    onClicked: root.accept()
                    Layout.alignment: Qt.AlignRight
                }
            }
        }
    }

    onClosed: appWindow.appWindowStateChanged()
    onOpened: root.forceActiveFocus()

    onAboutToShow: {
        if (!idField.text)
            setRemoteId(uiSettingsTools.settings.lastRemoteAppId);
        idField.selectAll();
        idField.forceActiveFocus();
    }

    onAccepted: {
        uiSettingsTools.settings.lastRemoteAppId = remoteId;
        App.rc.client.connectToRemoteApp(remoteId, alwaysConnectOnAppStart.checked);
    }

    function setRemoteId(remoteId)
    {
        idField.text = remoteId;
        idField.selectAll();
    }
}
