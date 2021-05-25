import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "../BaseElements"
import org.freedownloadmanager.fdm 1.0

BaseDialog {
    id: root

    width: 542

    property int downloadId

    contentItem: BaseDialogItem {
        titleText: qsTr("Add mirror") + App.loc.emptyString
        Keys.onEscapePressed: root.close()
        onCloseClick: root.close()

        ColumnLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 10
            Layout.rightMargin: 10
            spacing: 7

            BaseLabel {
                text: qsTr("Enter mirror URL") + App.loc.emptyString
            }

            BaseTextField
            {
                id: newUrl
                focus: true
                Layout.fillWidth: true
                onAccepted: root.doOK()
                Keys.onEscapePressed: root.close()
            }

            RowLayout {
                Layout.topMargin: 10
                Layout.bottomMargin: 10
                Layout.alignment: Qt.AlignRight
                Layout.fillWidth: true

                spacing: 5

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
                    enabled: newUrl.text.trim() != ''
                    onClicked: root.doOK()
                    Layout.alignment: Qt.AlignRight
                }
            }
        }
    }

    onClosed: {appWindow.appWindowStateChanged();}

    function showDialog(id)
    {
        downloadId = id;
        newUrl.text = "";
        root.open();
        root.forceActiveFocus();
    }

    function doOK()
    {
        var user_input = newUrl.text.trim();
        var urlTools = App.tools.url(user_input)
        if (urlTools.correctUserInput()) {
            user_input = urlTools.url
        }

        App.downloads.infos.info(downloadId).addMirrorUrl(user_input);

        root.close();
    }
}
