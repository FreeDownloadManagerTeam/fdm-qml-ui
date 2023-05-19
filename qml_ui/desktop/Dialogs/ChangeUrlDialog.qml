import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "../BaseElements"
import org.freedownloadmanager.fdm 1.0

BaseDialog {
    id: root

    width: 542*appWindow.zoom

    property var downloadModel
    property string destinationPath

    contentItem: BaseDialogItem {
        titleText: qsTr("Change download URL") + App.loc.emptyString
        Keys.onEscapePressed: root.close()
        onCloseClick: root.close()

        ColumnLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 10*appWindow.zoom
            Layout.rightMargin: 10*appWindow.zoom
            spacing: 7*appWindow.zoom

            BaseLabel {
                text: qsTr("Enter new URL") + App.loc.emptyString
            }

            BaseTextField
            {
                id: newUrl
                focus: true
                Layout.fillWidth: true
                onAccepted: root.doOK()
                Keys.onEscapePressed: root.close()
                enable_QTBUG_110471_workaround_2: true
            }

            BaseLabel
            {
                visible: destinationPath
                text: qsTr("File location: %1").arg(destinationPath)
                width: parent.width
                elide: Text.ElideMiddle
            }

            Rectangle {
                width: parent.width
                height: 30*appWindow.zoom

                BaseLabel
                {
                    visible: newUrl.text.trim() == ''
                    text: qsTr("Invalid URL") + App.loc.emptyString
                    color: appWindow.theme.errorMessage
                }
            }

            RowLayout {
                Layout.topMargin: 10*appWindow.zoom
                Layout.bottomMargin: 10*appWindow.zoom
                Layout.alignment: Qt.AlignRight
                Layout.fillWidth: true

                spacing: 5*appWindow.zoom

                BaseCheckBox {
                    id: startDownload
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignLeft
                    checkBoxStyle: "black"
                    text: qsTr("Start download") + App.loc.emptyString
                    checked: true
                    opacity: enabled ? 1 : 0.5
                }

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
        downloadModel = App.downloads.infos.info(id);
        newUrl.text = downloadModel.resourceUrl;
        newUrl.select(newUrl.text.length, 0);
        destinationPath = downloadModel.destinationPath
        startDownload.enabled = !downloadModel.running && !downloadModel.finished;
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
        App.downloads.infos.info(downloadModel.id).resourceUrl = user_input;
        if (startDownload.checked && !downloadModel.running && !downloadModel.finished) {
            App.downloads.mgr.startDownload(downloadModel.id, true);
        }
        root.close();
    }
}
