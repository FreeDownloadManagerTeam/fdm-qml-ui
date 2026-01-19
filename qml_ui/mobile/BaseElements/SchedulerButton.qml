import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import org.freedownloadmanager.fdm

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
        anchors.left: parent.left

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
                    effect: MultiEffect {
                        colorization: 1.0
                        colorizationColor: root.highlighted ? appWindow.theme.schedulerLabelText : appWindow.theme.schedulerLabelSelectedText
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
