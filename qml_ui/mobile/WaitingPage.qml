import QtQuick 2.0
import QtQuick.Controls 2.3
import org.freedownloadmanager.fdm 1.0
import "BaseElements"

Page {

    property string pageName: "WaitingPage"

    header: Column {
        height: 108
        width: parent.width

        BaseToolBar {}
        ToolBarShadow {}
        ExtraToolBar {}
    }

//    Rectangle {
//        anchors.fill: parent
//        anchors.margins: 20
//        DialogButton {
//            text: qsTr("Refresh") + App.loc.emptyString
//            onClicked: uiReadyTools.checkUiState()
//            width: parent.width
//            anchors.horizontalCenter: parent.horizontalCenter
//        }
//    }

}
