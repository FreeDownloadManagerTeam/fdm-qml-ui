import QtQuick 2.0
import QtQuick.Controls 2.3
import org.freedownloadmanager.fdm 1.0
import "./BaseElements"

Page {

    property string pageName: "WaitingPage"

    header: Column {
        height: 108
        width: parent.width

        Rectangle
        {
            width: parent.width
            height: 60

            color: "#ffffff"

            Text {
                width: parent.width
                text: App.shortDisplayName
                clip: true
                elide: Text.ElideMiddle
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 20
                font.family: "Roboto"
                horizontalAlignment: Text.AlignHCenter
                font.weight: Font.DemiBold
                color: "#4a4a4a"
            }
        }

        Rectangle {
            color: "#ededed"
            height: 48
            width: parent.width

            BaseLabel {
                text: "Loading"
                width: parent.width
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignHCenter

            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#FFFFFF"
    }

    Rectangle {
        anchors.fill: parent
        anchors.margins: 20
        Button {
            text: qsTr("Refresh") + App.loc.emptyString
            onClicked: uiReadyTools.checkUiState()
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }


}
