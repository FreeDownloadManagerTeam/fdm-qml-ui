import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.11
import org.freedownloadmanager.fdm 1.0
import Qt.labs.settings 1.0
import "../BaseElements"
import "../../common/Tools"

BaseDialog {
    id: root

    width: 542

    contentItem: BaseDialogItem {
        titleText: qsTr("Virus check") + App.loc.emptyString
        focus: true
        Keys.onEscapePressed: root.close()
        Keys.onReturnPressed: root.deleteFilesClick()
        onCloseClick: root.close()

        ColumnLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 10
            Layout.rightMargin: 10
            spacing: 3

            BaseLabel {
                Layout.fillWidth: true
                text: qsTr("There is no antivirus specified in the settings.") + App.loc.emptyString
                Layout.bottomMargin: 7
            }

            RowLayout {
                Layout.topMargin: 10
                Layout.bottomMargin: 10
                Layout.alignment: Qt.AlignRight

                spacing: 5

                CustomButton {
                    text: qsTr("Go to settings") + App.loc.emptyString
                    blueBtn: true
                    alternateBtnPressed: cnclBtn.isPressed
                    onClicked: root.goSettingsClick()
                }

                CustomButton {
                    id: cnclBtn
                    text: qsTr("Cancel") + App.loc.emptyString
                    onClicked: root.close()
                }
            }
        }
    }

    onOpened: {
        forceActiveFocus();
    }

    function goSettingsClick()
    {
        root.close();
        appWindow.openSettings(true);
    }
}
