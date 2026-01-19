import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import Qt.labs.settings
import "../BaseElements"
import "../../common/Tools"

BaseDialog {
    id: root

    title: qsTr("Virus check") + App.loc.emptyString

    onCloseClick: root.close()

    contentItem: BaseDialogItem {       
        focus: true
        Keys.onEscapePressed: root.close()
        Keys.onReturnPressed: root.deleteFilesClick()

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 3*appWindow.zoom

            BaseLabel {
                Layout.fillWidth: true
                text: qsTr("There is no antivirus specified in the settings.") + App.loc.emptyString
                Layout.bottomMargin: 7*appWindow.zoom
            }

            RowLayout {
                Layout.topMargin: 10*appWindow.zoom
                Layout.alignment: Qt.AlignRight

                spacing: 5*appWindow.zoom

                BaseButton {
                    text: qsTr("Go to settings") + App.loc.emptyString
                    blueBtn: true
                    alternateBtnPressed: cnclBtn.isPressed
                    onClicked: root.goSettingsClick()
                }

                BaseButton {
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
