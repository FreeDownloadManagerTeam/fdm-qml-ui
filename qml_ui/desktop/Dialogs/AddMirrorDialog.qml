import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "../BaseElements"
import org.freedownloadmanager.fdm 1.0

BaseDialog {
    id: root

    property int downloadId

    title: qsTr("Add mirror") + App.loc.emptyString

    onCloseClick: root.close()

    contentItem: BaseDialogItem {
        Keys.onEscapePressed: root.close()

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 7*appWindow.zoom

            BaseLabel {
                text: qsTr("Enter mirror URL") + App.loc.emptyString
            }

            BaseTextField
            {
                id: newUrl
                focus: true
                Layout.preferredWidth: 540*appWindow.zoom
                onAccepted: root.doOK()
                Keys.onEscapePressed: root.close()
                enable_QTBUG_110471_workaround_2: true
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
