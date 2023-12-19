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

    width: 542*appWindow.zoom

    contentItem: BaseDialogItem {
        titleText: qsTr("Connect to remote %1").arg(App.shortDisplayName) + ' ' + qsTr("(beta)") + App.loc.emptyString
        Keys.onEscapePressed: root.close()
        onCloseClick: root.close()

        ColumnLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 10*appWindow.zoom
            Layout.rightMargin: 10*appWindow.zoom
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
                    Layout.fillWidth: true
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
                Layout.bottomMargin: 10*appWindow.zoom
                Layout.alignment: Qt.AlignRight
                Layout.fillWidth: true

                spacing: 5*appWindow.zoom

                CustomButton {
                    id: cnclBtn
                    text: qsTr("Cancel") + App.loc.emptyString
                    onClicked: root.close();
                    Layout.alignment: Qt.AlignRight
                }

                CustomButton {
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
