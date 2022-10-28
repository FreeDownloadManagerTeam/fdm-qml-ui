import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import "../BaseElements"
import "../../common/Tools"
import org.freedownloadmanager.fdm 1.0

BaseDialog
{
    id: root

    RenameDownloadFileTools {
        id: tools
        newNameField: nameField
        onFinished: root.close()
    }

    function initialize(downloadId, fileIndex)
    {
        tools.initialize(downloadId, fileIndex);
    }

    onOpened: root.forceActiveFocus()

    width: 542*appWindow.zoom

    contentItem: BaseDialogItem {
        titleText: qsTr("Rename file") + App.loc.emptyString
        Keys.onEscapePressed: root.close()
        onCloseClick: root.close()

        ColumnLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 10*appWindow.zoom
            Layout.rightMargin: 10*appWindow.zoom
            spacing: 7*appWindow.zoom

            BaseLabel {
                text: qsTr("Enter new name") + ':' + App.loc.emptyString
            }

            BaseTextField
            {
                id: nameField
                enabled: !tools.renaming
                focus: true
                Layout.fillWidth: true
                Keys.onEscapePressed: root.close()
            }

            BaseLabel
            {
                visible: tools.alreadyExistsError
                text: qsTr("A file with that name already exists.") + App.loc.emptyString
                color: appWindow.theme.errorMessage
            }

            BaseLabel
            {
                visible: tools.error
                text: tools.error
                color: appWindow.theme.errorMessage
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
                    enabled: !tools.renaming && (tools.canBeRenamed || !tools.hasChanges)
                    onClicked: tools.doOK()
                    Layout.alignment: Qt.AlignRight
                }
            }
        }
    }
}
