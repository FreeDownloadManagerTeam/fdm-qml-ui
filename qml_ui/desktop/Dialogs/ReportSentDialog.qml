import QtQuick 2.0
import QtQuick.Layouts 1.11
import org.freedownloadmanager.fdm 1.0
import "../BaseElements"

BaseDialog {
    id: root

    property string errorMessage

    title: qsTr("Report problem") + App.loc.emptyString
    onCloseClick: root.close()

    contentItem: BaseDialogItem {
        focus: true
        Keys.onEscapePressed: root.close()
        Keys.onReturnPressed: root.close()

        ColumnLayout {
            width: parent.width
            spacing: 15*appWindow.zoom

            BaseLabel {
                Layout.fillWidth: true
                Layout.maximumWidth: 540*appWindow.zoom
                text: (errorMessage.length > 0 ? qsTr("Sorry, the report hasn't been sent, an error occurred: %1").arg(errorMessage) : qsTr("The report has been sent. Thank you for your cooperation!")) + App.loc.emptyString
                Layout.bottomMargin: 7*appWindow.zoom
                wrapMode: Text.WordWrap
            }

            BaseButton {
                text: qsTr("OK") + App.loc.emptyString
                blueBtn: true
                onClicked: root.close()
                Layout.alignment: Qt.AlignRight
            }
        }
    }

    onOpened: forceActiveFocus()
    onClosed: appWindow.appWindowStateChanged()
}
