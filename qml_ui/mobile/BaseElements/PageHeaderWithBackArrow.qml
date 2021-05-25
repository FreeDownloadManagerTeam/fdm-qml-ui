import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

BaseToolBar {
    property string pageTitle
    signal popPage()

    RowLayout {
        anchors.fill: parent
        anchors.rightMargin: 60

        ToolbarBackButton {
            onClicked: popPage()
        }

        ToolbarLabel {
            text: pageTitle
            Layout.fillWidth: true
        }
    }
}
