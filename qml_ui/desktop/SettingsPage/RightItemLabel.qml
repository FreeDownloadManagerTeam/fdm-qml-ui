import QtQuick 2.0
import QtQuick.Controls 2.3
import "../BaseElements"

BaseLabel {
    property bool current: false
    signal clicked

    color: appWindow.theme.settingsSidebarHeader
    leftPadding: smallSettingsPage ? 18 : 22
    topPadding: smallSettingsPage ? 3 : 7
    bottomPadding: smallSettingsPage ? 3 : 7
    wrapMode: Label.Wrap
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: parent.clicked()
    }
    Rectangle {
        visible: current
        color: "#4e5764"
        width: 6
        height: parent.height
    }
}
