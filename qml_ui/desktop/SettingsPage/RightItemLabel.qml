import QtQuick 2.12
import QtQuick.Controls 2.12
import "../BaseElements"

Item {
    id: root

    property bool current: false
    signal clicked
    property alias text: label.text

    implicitWidth: label.implicitWidth + (appWindow.uiver === 1 ? 0 : 12*appWindow.zoom)
    implicitHeight: label.implicitHeight

    readonly property int baseLeftOffset: (smallSettingsPage ? 18 : 22)*appWindow.zoom

    Rectangle {
        visible: appWindow.uiver === 1 && root.current
        color: "#4e5764"
        width: 6*appWindow.zoom
        height: parent.height
        anchors.left: parent.left
    }

    Rectangle {
        visible: appWindow.uiver !== 1 && root.current
        anchors.fill: parent
        anchors.leftMargin: baseLeftOffset
        color: appWindow.theme_v2.bg400
        radius: 8*appWindow.zoom
    }

    BaseLabel {
        id: label

        anchors.left: parent.left

        color: appWindow.uiver === 1 ?
                   appWindow.theme.settingsSidebarHeader :
                   appWindow.theme_v2.textColor

        leftPadding: qtbug.leftPadding(baseLeftOffset + (appWindow.uiver === 1 ? 0 : 12*appWindow.zoom), 0)
        rightPadding: qtbug.rightPadding(baseLeftOffset + (appWindow.uiver === 1 ? 0 : 12*appWindow.zoom), 0)
        topPadding: (smallSettingsPage ? 3 : 7)*appWindow.zoom
        bottomPadding: (smallSettingsPage ? 3 : 7)*appWindow.zoom

        wrapMode: Label.Wrap
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
