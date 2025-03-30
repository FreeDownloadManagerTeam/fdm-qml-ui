import QtQuick
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import "../BaseElements"

BaseDialog
{
    id: root

    enum Button {
        Ok      = 1,
        Cancel  = 2
    }

    property int buttons: AppMessageDialog.Ok

    property alias text: textLabel.text
    property alias textFormat: textLabel.textFormat

    modal: true

    parent: appWindow.contentItem

    contentItem: BaseDialogItem {

        Keys.onEscapePressed: root.reject()
        Keys.onEnterPressed: root.accept()
        Keys.onReturnPressed: root.accept()

        BaseLabel {
            id: textLabel
            Layout.minimumWidth: 200*appWindow.zoom
        }

        RowLayout {
            Layout.alignment: Qt.AlignRight
            focus: true

            BaseButton {
                visible: root.buttons & AppMessageDialog.Ok
                text: qsTr("OK") + App.loc.emptyString
                blueBtn: true
                onClicked: root.accept()
            }

            BaseButton {
                visible: root.buttons & AppMessageDialog.Cancel
                text: qsTr("Cancel") + App.loc.emptyString
                onClicked: root.reject()
            }
        }
    }

    onOpened: ++appWindow.appMessageDialogsOpened
    onClosed: --appWindow.appMessageDialogsOpened

    onCloseClick: root.reject()
}
