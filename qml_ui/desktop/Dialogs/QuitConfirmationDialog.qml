import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3
import org.freedownloadmanager.fdm 1.0
import "../BaseElements"

BaseDialog {
    id: root

    property string message: ""

    title: qsTr("Are you sure you want to quit?") + App.loc.emptyString
    onCloseClick: root.close()

    contentItem: BaseDialogItem {

        focus: true
        Keys.onEscapePressed: root.close()
        Keys.onReturnPressed: root.close()

        Column {
            id: col
            spacing: 5*appWindow.zoom

            BaseLabel
            {
                bottomPadding: 10*appWindow.zoom
                text: root.message
            }

            Row
            {
                anchors.right: parent.right
                spacing: 5*appWindow.zoom

                BaseButton {
                    text: qsTr("OK") + App.loc.emptyString
                    blueBtn: true
                    onClicked: {
                        root.close();
                        App.reportQuitConfirmationResult(true);
                    }
                }

                BaseButton {
                    text: qsTr("Cancel") + App.loc.emptyString
                    onClicked: {
                        root.close();
                        App.reportQuitConfirmationResult(false);
                    }
                }
            }
        }
    }

    onOpened: {
        forceActiveFocus();
    }
}
