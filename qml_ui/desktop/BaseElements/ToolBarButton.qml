import QtQuick 2.10


Rectangle {

    id: root
    property int backgroundPositionX
    property int backgroundPositionY
    property bool indicator: false
    property bool rotate: false
    property string tooltipText

    signal clicked()

    color: "transparent"
    height: parent.height
    width: 58
    clip: true

    Rectangle {
        id: icon
        clip: true
        color: "transparent"
        width: appWindow.macVersion ? 40 : parent.width
        height: appWindow.macVersion ? 40 : parent.height
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        Image {
            opacity: root.enabled ? 1 : 0.3
            x: backgroundPositionX
            y: backgroundPositionY
            source: appWindow.macVersion ?
                appWindow.theme.headerIconsMac :
                appWindow.theme.headerIcons

            sourceSize.width: appWindow.macVersion ? 280 : 75
            sourceSize.height: appWindow.macVersion ? 80 : 559
        }

        MouseArea {
            visible: appWindow.macVersion
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            onClicked: root.clicked()
            BaseToolTip {
                text: root.tooltipText
                visible: root.enabled && parent.containsMouse && text.length > 0
                fontSize: 11
            }
        }

        RotationAnimator on rotation {
            from: 0;
            to: 360;
            loops: Animation.Infinite
            duration: 2000
            running: root.rotate
        }
    }

    Rectangle {
        visible: root.indicator
        anchors.right: icon.right
        anchors.bottom: icon.bottom
        anchors.rightMargin: 8
        anchors.bottomMargin: 8
        height: 8
        width: 8
        radius: 4
        color: "#40ca0a"
    }

    MouseArea {
        visible: !appWindow.macVersion
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true
        onClicked: root.clicked()
        BaseToolTip {
            text: root.tooltipText
            visible: root.enabled && parent.containsMouse && text.length > 0
            fontSize: 11
        }
    }
}
