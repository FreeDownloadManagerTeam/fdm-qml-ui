import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import org.freedownloadmanager.fdm
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
