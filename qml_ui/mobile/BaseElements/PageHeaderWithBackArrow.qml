import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "../../common"

BaseToolBar {
    id: root

    property string pageTitle
    signal popPage()

    signal clickedNtimes()

    RowLayout {
        anchors.fill: parent
        anchors.rightMargin: 60

        ToolbarBackButton {
            onClicked: popPage()
        }

        ToolbarLabel {
            text: pageTitle
            Layout.fillWidth: true

            NClicksTrigger {
                anchors.fill: parent
                onTriggered: root.clickedNtimes()
            }
        }
    }
}
