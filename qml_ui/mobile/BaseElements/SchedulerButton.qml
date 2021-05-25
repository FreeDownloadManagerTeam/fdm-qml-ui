import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import org.freedownloadmanager.fdm 1.0

Rectangle {
    id: root
    color: 'transparent'
    Layout.topMargin: 5
    Layout.leftMargin: 20
    Layout.preferredHeight: 20
    Layout.fillWidth: true

    property bool highlighted
    signal clicked

    Item {
        width: content.width
        height: content.height

        Row {
            id: content
            spacing: 5

            Image {
                id: img
                sourceSize.width: 16
                sourceSize.height: 16
                source: Qt.resolvedUrl("../../images/mobile/scheduler.svg")
                Layout.alignment: Qt.AlignVCenter
                layer {
                    effect: ColorOverlay {
                        color: root.highlighted ? appWindow.theme.schedulerLabelText : appWindow.theme.schedulerLabelSelectedText
                    }
                    enabled: true
                }
            }

            Label {
                text: qsTr("Scheduler") + App.loc.emptyString
                color: root.highlighted ? appWindow.theme.schedulerLabelText : appWindow.theme.schedulerLabelSelectedText
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: root.clicked()
        }
    }
}
