import QtQuick 2.0
import QtQuick.Layouts 1.11
import org.freedownloadmanager.fdm 1.0
import "../BaseElements"

BaseDialog {
    id: root

    width: 542

    property string errorMessage

    contentItem: BaseDialogItem {
        titleText: qsTr("Report problem") + App.loc.emptyString
        focus: true
        Keys.onEscapePressed: root.abortMoving()
        Keys.onReturnPressed: root.retryMoving()
        onCloseClick: root.abortMoving()

        ColumnLayout {
            width: parent.width
            Layout.leftMargin: 10
            Layout.rightMargin: 10
            spacing: 15

            BaseLabel {
                Layout.fillWidth: true
                text: (errorMessage.length > 0 ? qsTr("Sorry, the report hasn't been sent, an error occurred: %1").arg(errorMessage) : qsTr("The report has been sent. Thank you for your cooperation!")) + App.loc.emptyString
                Layout.bottomMargin: 7
                wrapMode: Text.WordWrap
            }

            CustomButton {
                text: qsTr("OK") + App.loc.emptyString
                blueBtn: true
                onClicked: root.close()
                Layout.bottomMargin: 10
                Layout.alignment: Qt.AlignRight
            }
        }
    }

    onOpened: forceActiveFocus()
    onClosed: appWindow.appWindowStateChanged()
}
