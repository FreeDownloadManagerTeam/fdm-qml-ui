import QtQuick
import QtQuick.Controls
import QtQuick.Effects

CheckBox {
    id: root

    property string checkBoxStyle: "blue"
    property bool vertical: false
    property string textColor
    property int size: 12
    property int wrapMode: Text.NoWrap

    padding: 0
    spacing: vertical ? 20 : undefined
    focusPolicy: Qt.NoFocus

    indicator: Rectangle {
        implicitWidth: size
        implicitHeight: size
        anchors.left: parent.left
        anchors.horizontalCenter: vertical ? parent.horizontalCenter : undefined
        anchors.bottom: vertical ? parent.bottom : undefined
        anchors.verticalCenter: vertical ? undefined : parent.verticalCenter
        color: checkState === Qt.Unchecked ? "transparent" : appWindow.theme.toolbarBackground
        border.color: appWindow.theme.border
        border.width: checkState === Qt.Unchecked ? 1 : 0
        opacity: enabled ? 1 : 0.5

        Image {
            id: img
            visible: checkState === Qt.Checked
            sourceSize.width: 12
            sourceSize.height: 12
            source: Qt.resolvedUrl("../../images/mobile/checkbox.svg")
            anchors.centerIn: parent
        }

        Rectangle {
            visible: checkState === Qt.PartiallyChecked
            width: size - 6
            height: width
            x: (size - width) / 2
            y: x
            color: "#FFFFFF"
        }
    }

    contentItem: BaseLabel {
        leftPadding: qtbug.leftPadding(vertical ? 0 : 20, 0)
        rightPadding: qtbug.rightPadding(vertical ? 0 : 20, 0)
        text: parent.text
        anchors.horizontalCenter: vertical ? parent.horizontalCenter : undefined
        anchors.top: vertical ? parent.top : undefined
        bottomPadding: vertical ? 10 : 0
        opacity: root.enabled ? 1 : 0.5
        color: appWindow.theme.foreground
        font.pixelSize: root.size == 16 ? 14 : 12
        wrapMode: root.wrapMode
    }
}
