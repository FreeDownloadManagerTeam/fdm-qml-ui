import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3
import org.freedownloadmanager.fdm 1.0
import "../BaseElements"

BaseDialog {
    id: root

    property string message: ""

    contentItem: BaseDialogItem {
        titleText: qsTr("Are you sure you want to quit?") + App.loc.emptyString

        width: col.width + 20

        focus: true
        Keys.onEscapePressed: root.close()
        Keys.onReturnPressed: root.close()
        onCloseClick: root.close()

        Column {
            id: col
            Layout.leftMargin: 10
            Layout.rightMargin: 10
            Layout.bottomMargin: 10
            spacing: 5

            Label
            {
                bottomPadding: 10
                text: root.message
            }

            Row
            {
                anchors.right: parent.right
                spacing: 5

                CustomButton {
                    text: qsTr("OK") + App.loc.emptyString
                    blueBtn: true
                    onClicked: {
                        root.close();
                        App.reportQuitConfirmationResult(true);
                    }
                }

                CustomButton {
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
