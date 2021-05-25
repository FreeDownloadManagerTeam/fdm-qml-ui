import QtQuick 2.0

Rectangle {

    property bool infinityIndicator: false
    property int percent: 0
    property bool inProgress: true
    property bool small: true

    height: small ? 6 : 10
    color: parent.inProgress ? appWindow.theme.progressRunningBackground : appWindow.theme.progressPausedBackground
    clip: true

    Rectangle {
        visible: !infinityIndicator
        color: parent.inProgress ? appWindow.theme.progressRunning : appWindow.theme.progressPaused
        height: parent.height
        width: parent.width * percent / 100
    }

    Image {
        visible: infinityIndicator && !parent.inProgress
        width: parent.width
        source: small ? appWindow.theme.infiniteInactiveSmall : appWindow.theme.infiniteInactive
        sourceSize.width: small ? 20 : 40
        sourceSize.height: small ? 20 : 40
        fillMode: Image.TileHorizontally
        verticalAlignment: Image.AlignLeft
    }

    Row {
        visible: infinityIndicator && parent.inProgress
        width: parent.width
        spacing: 0
        Repeater {
            model: parseInt(parent.width/20) + 1
            AnimatedImage {
                source: small ? appWindow.theme.infiniteActiveSmall : appWindow.theme.infiniteActive
//                sourceSize.width: small ? 20 : 40
//                sourceSize.height: small ? 20 : 40
                paused: !visible
            }
        }
    }
}
