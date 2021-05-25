import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.1

Item {

    id: root

    anchors.fill: parent

    ListModel {
        id: logModel
        ListElement {
            date: "Jul 9, 20018 8:03 AM"
            string: "#3 closed"
        }
        ListElement {
            date: "Jul 9, 20018 8:03 AM"
            string: "#1234567890 closed"
        }
        ListElement {
            date: "Jul 9, 20018 8:03 AM"
            string: "Removing temporary file"
        }
    }

    Rectangle {
        anchors.fill: parent
        anchors.margins: 20
        color: "transparent"

        ListView {
            anchors.fill: parent

            model: logModel

            delegate: Row {
                spacing: 10
                Text {
                    text: date
                }
                Text
                {
                    anchors.verticalCenter: parent.verticalCenter
                    text: string
                }
            }

        }

    }


}
