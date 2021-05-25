import QtQuick 2.10
import QtQuick.Controls 2.3

Rectangle {
    id: root

    width: small ? 105 : 225
    height: 14
    color: "transparent"

    property int progress: -1
    property bool infinityIndicator: false
    property bool inProgress: true
    property color progressColor: appWindow.theme.progressRunning
    property bool small: true

    //value in %
    Label {
        visible: !infinityIndicator
        anchors.rightMargin: 5
        anchors.right: small ? progressBar.left : undefined
        anchors.left: small ? undefined : progressBar.right
        anchors.leftMargin: small ? undefined : 10
        anchors.verticalCenter: parent.verticalCenter
        text: root.progress + '%'
        font.pixelSize: 11//small ? 11 : 12
        font.weight: Font.Light
    }

    Rectangle {
        id: progressBar

        anchors.right: small ? parent.right : undefined
        anchors.left: small ? undefined : parent.left
        anchors.verticalCenter: parent.verticalCenter
        height: 9
        width: small ? 67 : 174
        color: 'transparent'
        border.width: 1
        border.color: appWindow.theme.progressBorder

        //infinity indicator
        Rectangle {
            visible: infinityIndicator
            width: parent.width - 2
            height: parent.height - 2
            anchors.left: parent.left
            anchors.margins: 1
            anchors.verticalCenter: parent.verticalCenter

            //disabled
            Image {
                visible: infinityIndicator && !inProgress
                width: parent.width
                height: parent.height
                source: appWindow.theme.infiniteInactive
                fillMode: Image.TileHorizontally
                verticalAlignment: Image.AlignLeft
            }

            //enabled
            Row {
                visible: infinityIndicator && inProgress
                width: parent.width
                spacing: 0
                clip: true
                Repeater {
                    model: parseInt(parent.width/10) + 1
                    AnimatedImage {
                        source: appWindow.theme.infiniteActive
                        paused: !visible
                    }
                }
            }
        }

        //progressbar
        Rectangle {
            visible: !infinityIndicator
            height: parent.height - 2
            anchors.left: parent.left
            anchors.margins: 1
            width: (parent.width - 2) * root.progress / 100
            color: progressColor
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
