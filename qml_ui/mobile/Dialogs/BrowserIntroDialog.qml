import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0
import QtQuick.Controls.Material 2.4
import "../../common"
import "../BaseElements"

CenteredDialog
{
    id: root
    width: 320
    height: 320

    modal: true

    contentItem: ColumnLayout {
        width: parent.width
        spacing: 10
        anchors.leftMargin: 20
        anchors.rightMargin: 20

        Label
        {
            text: qsTr("You're about to open a built-in web browser.\n\nIt helps you to add downloads into %1.\n\nSome of them (e.g. Google Drive downloads) can be added using this browser only, because they require additional information that your Android system's browser does not provide to %1 (or there is no universal way for all browsers to do this).").arg(App.shortDisplayName) + App.loc.emptyString
            Layout.fillWidth: parent
            wrapMode: Label.Wrap
            horizontalAlignment: Text.AlignLeft
        }

        DialogButton {
            text: qsTr("Continue") + App.loc.emptyString
            onClicked: root.close()
            Layout.alignment: Qt.AlignHCenter
        }
    }

    onClosed: appWindow.openBrowser()
}
