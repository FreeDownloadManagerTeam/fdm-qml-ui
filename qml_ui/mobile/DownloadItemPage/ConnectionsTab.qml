import QtQuick 2.10
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "../BaseElements"
import org.freedownloadmanager.fdm 1.0

Rectangle {
    id: root

    anchors.fill: parent
    color: "transparent"

    property int hostColWidth: 150
    property int portColWidth: 70
    property int countColWidth: 110

    Rectangle {
        anchors.fill: parent
        anchors.leftMargin: appWindow.showBordersInDownloadsList ? parent.width * 0.1 : 0
        anchors.rightMargin: appWindow.showBordersInDownloadsList ? parent.width * 0.1 : 0
        color: "transparent"

        border.color: appWindow.theme.border

        BaseLabel {
            text: qsTr("There are no connections") + App.loc.emptyString
            anchors.centerIn: parent
            visible: !connectionsList.visible
            font.pixelSize: 13
        }

        ListView {
            id: connectionsList
            anchors.fill: parent
            anchors.topMargin: 1
            ScrollBar.vertical: ScrollBar{}
            flickableDirection: Flickable.AutoFlickIfNeeded
            boundsBehavior: Flickable.StopAtBounds
            clip: true
            headerPositioning: ListView.OverlayHeader

            visible: downloadsItemTools.running && count

            model: downloadsItemTools.connectionsModel

            header: RowLayout {
                width: parent.width
                spacing: 0
                z: 2

                TablesHeaderItem {
                    id: hostItem
                    text: qsTr("Host") + App.loc.emptyString
                    Layout.fillWidth: true
                    Layout.preferredHeight: appWindow.smallScreen ? 48 : 24
                    onWidthChanged: hostColWidth = width
                    color: appWindow.theme.background
                }

                TablesHeaderItem {
                    id: portItem
                    text: qsTr("Port") + App.loc.emptyString
                    Layout.preferredWidth: 70
                    Layout.preferredHeight: appWindow.smallScreen ? 48 : 24
                    onWidthChanged: portColWidth = width
                    color: appWindow.theme.background
                }

                TablesHeaderItem {
                    id: countItem
                    text: qsTr("Connection count") + App.loc.emptyString
                    Layout.preferredWidth: appWindow.smallScreen ? 110 : 180
                    Layout.preferredHeight: appWindow.smallScreen ? 48 : 24
                    onWidthChanged: countColWidth = width
                    color: appWindow.theme.background

                    Rectangle {
                        height: parent.height
                        width: 1
                        anchors.right: parent.right
                        color: appWindow.theme.border
                    }
                }
            }

            delegate: RowLayout {
                property int rowHeigth: 22
                width: connectionsList.width
                height: rowHeigth
                Layout.preferredHeight: rowHeigth
                spacing: 0

                BaseLabel {
                    text: model.host
                    Layout.preferredWidth: hostColWidth
                    elide: Text.ElideRight
                    height: rowHeigth
                    leftPadding: qtbug.leftPadding(6, 0)
                    rightPadding: qtbug.rightPadding(6, 0)
                }

                BaseLabel {
                    text: model.port
                    Layout.preferredWidth: portColWidth
                    height: rowHeigth
                    leftPadding: qtbug.leftPadding(6, 0)
                    rightPadding: qtbug.rightPadding(6, 0)
                }

                BaseLabel {
                    text: model.connectionCount
                    Layout.preferredWidth: countColWidth
                    height: rowHeigth
                    leftPadding: qtbug.leftPadding(6, 0)
                    rightPadding: qtbug.rightPadding(6, 0)
                }
            }
        }
    }
}
