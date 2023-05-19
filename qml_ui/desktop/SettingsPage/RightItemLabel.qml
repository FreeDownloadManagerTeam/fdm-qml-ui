import QtQuick 2.12
import QtQuick.Controls 2.12
import "../BaseElements"

BaseLabel {
    property bool current: false
    signal clicked

    color: appWindow.theme.settingsSidebarHeader
    leftPadding: qtbug.leftPadding((smallSettingsPage ? 18 : 22)*appWindow.zoom, 0)
    rightPadding: qtbug.rightPadding((smallSettingsPage ? 18 : 22)*appWindow.zoom, 0)
    topPadding: (smallSettingsPage ? 3 : 7)*appWindow.zoom
    bottomPadding: (smallSettingsPage ? 3 : 7)*appWindow.zoom
    wrapMode: Label.Wrap
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: parent.clicked()
    }
    Rectangle {
        visible: current
        color: "#4e5764"
        width: 6*appWindow.zoom
        height: parent.height
        anchors.left: parent.left
    }
}
