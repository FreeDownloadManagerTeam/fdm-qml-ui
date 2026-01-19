import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import "../../common"
import "../BaseElements"

CenteredDialog
{
    id: root

    focus: true

    readonly property string remoteId: idField.text.trim()
    readonly property int maxWidth: Math.round(appWindow.width * 0.9) - 40

    modal: true

    title: qsTr("Connect to remote %1").arg(App.shortDisplayName) + App.loc.emptyString

    width: maxWidth + 40

    contentItem: ColumnLayout {

        spacing: 10

        BaseLabel {
            text: qsTr("Here you can connect to %1 running on your Windows/macOS/Linux PC").arg(App.shortDisplayName) + App.loc.emptyString
            Layout.maximumWidth: root.maxWidth
            //Layout.preferredHeight: 40 // QTBUG-66826 workaround
            wrapMode: Text.WordWrap
        }

        BaseLabel {
            text: qsTr("Please enter %1, or <a href='#'>scan QR code</a>").arg("ID") + App.loc.emptyString
            Layout.preferredWidth: root.maxWidth
            //Layout.preferredHeight: 40 // QTBUG-66826 workaround
            wrapMode: Text.WordWrap
            onLinkActivated: App.scanQrCodeWithAppUrlCall()
        }

        BaseLabel {
            text: qsTr("Both %1 and QR code are located inside of Preferences page of %2 you're going to connect to.").arg("ID").arg(App.shortDisplayName) + App.loc.emptyString
            Layout.preferredWidth: root.maxWidth
            //Layout.preferredHeight: 40 // QTBUG-66826 workaround
            wrapMode: Text.WordWrap
        }

        RowLayout {
            spacing: 10

            Layout.maximumWidth: root.maxWidth

            Label {
                text: "ID:"
                horizontalAlignment: Text.AlignLeft
            }

            BaseTextField {
                id: idField
                text: uiSettingsTools.settings.lastRemoteAppId
                focus: true
                Layout.fillWidth: true
                enable_QTBUG_110471_workaround_2: true
                selectAllAtInit: true
                onAccepted: root.accept()
                Keys.onEscapePressed: root.close()
                inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhSensitiveData
                onTextChanged: {
                    var s = text.toUpperCase();
                    if (text != s)
                        text = s;
                }
            }
        }

        BaseCheckBox {
            id: alwaysConnectOnAppStart
            text: qsTr("Automatically connect at %1 startup").arg(App.shortDisplayName) + App.loc.emptyString
            Layout.preferredWidth: root.maxWidth
            //Layout.preferredHeight: 40 // QTBUG-66826 workaround
            wrapMode: Text.WordWrap
        }

        RowLayout {
            Layout.topMargin: 10
            Layout.bottomMargin: 10
            Layout.alignment: Qt.AlignRight

            spacing: 5

            DialogButton {
                text: qsTr("Cancel") + App.loc.emptyString
                onClicked: root.close()
            }

            DialogButton {
                enabled: root.remoteId !== '' && root.remoteId !== App.rc.id
                text: qsTr("OK") + App.loc.emptyString
                onClicked: root.accept()
            }
        }
    }

    onAboutToShow: {
        if (!idField.text)
            setRemoteId(uiSettingsTools.settings.lastRemoteAppId);
    }

    onOpened: {
        idField.selectAll();
        idField.forceActiveFocus();
    }

    onAccepted: {
        uiSettingsTools.settings.lastRemoteAppId = remoteId;
        App.rc.client.connectToRemoteApp(remoteId, alwaysConnectOnAppStart.checked);
    }

    function setRemoteId(remoteId)
    {
        idField.text = remoteId.toUpperCase();
    }
}
