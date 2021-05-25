import QtQuick 2.10
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "../BaseElements"
import org.freedownloadmanager.fdm 1.0

Item {

    anchors.fill: parent

    BaseLabel {
        text: qsTr("There are no connections") + App.loc.emptyString
        anchors.centerIn: parent
        visible: !connectionsList.visible
        font.pixelSize: 13
    }

    property int hostItemWidth: 0
    property int portItemWidth: 0

    ListView {
        id: connectionsList
        anchors.fill: parent
        anchors.bottomMargin: 1
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
                Layout.preferredWidth: Math.max(200, headerMinimumWidth, parent.width / 2)
                Layout.fillHeight: true
                color: appWindow.theme.background
                onWidthChanged: hostItemWidth = width
            }

            TablesHeaderItem {
                id: portItem
                text: qsTr("Port") + App.loc.emptyString
                Layout.preferredWidth: Math.max(50, headerMinimumWidth)
                Layout.fillHeight: true
                color: appWindow.theme.background
                onWidthChanged: portItemWidth = width
            }

            TablesHeaderItem {
                id: countItem
                text: qsTr("Connection count") + App.loc.emptyString
                Layout.fillWidth: true
                Layout.fillHeight: true
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
            width: parent.width
            height: 22
            spacing: 0

            BaseLabel {
                text: model.host
                Layout.preferredWidth: hostItemWidth
                Layout.minimumWidth: Layout.preferredWidth
                Layout.fillHeight: true
                leftPadding: 6
            }

            BaseLabel {
                text: model.port
                Layout.preferredWidth: portItemWidth
                Layout.minimumWidth: Layout.preferredWidth
                Layout.fillHeight: true
                leftPadding: 6
            }

            BaseLabel {
                text: model.connectionCount
                Layout.fillWidth: true
                Layout.fillHeight: true
                leftPadding: 6
            }
        }
    }
}
