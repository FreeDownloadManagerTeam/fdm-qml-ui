import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.4
import org.freedownloadmanager.fdm 1.0
import "../../common"
import "../BaseElements"

CenteredDialog
{
    id: root
    width: 320

    modal: true
    padding: 5

    contentItem: Item {
        anchors.fill: parent

        Label {
            text: qsTr("No supported file managers found.") + App.loc.emptyString
            wrapMode: Text.Wrap
            anchors.centerIn: parent
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
        }
    }
}
