import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../BaseElements"
import org.freedownloadmanager.fdm

Item {

    anchors.fill: parent

    BaseLabel {
        text: qsTr("There are no connections") + App.loc.emptyString
        anchors.centerIn: parent
        visible: !connectionsList.visible
        font.pixelSize: 13*appWindow.fontZoom
    }

    property int hostItemWidth: 0
    property int portItemWidth: 0

    ListView {
        id: connectionsList
        anchors.fill: parent
        anchors.topMargin: appWindow.uiver === 1 ? 0 : 8*appWindow.zoom
        anchors.leftMargin: appWindow.uiver === 1 ? 0 : appWindow.theme_v2.mainWindowLeftMargin*appWindow.zoom
        anchors.bottomMargin: 1*appWindow.zoom
        ScrollBar.vertical: BaseScrollBar{}
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
                Layout.preferredWidth: Math.max(200*appWindow.fontZoom, headerMinimumWidth, parent.width / 2)
                Layout.fillHeight: true
                color: appWindow.uiver === 1 ?
                           appWindow.theme.background :
                           appWindow.theme_v2.bgColor
                onWidthChanged: hostItemWidth = width
            }

            TablesHeaderItem {
                id: portItem
                text: qsTr("Port") + App.loc.emptyString
                Layout.preferredWidth: Math.max(70*appWindow.fontZoom, headerMinimumWidth)
                Layout.fillHeight: true
                color: appWindow.uiver === 1 ?
                           appWindow.theme.background :
                           appWindow.theme_v2.bgColor
                onWidthChanged: portItemWidth = width
            }

            TablesHeaderItem {
                id: countItem
                text: qsTr("Connection count") + App.loc.emptyString
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: appWindow.uiver === 1 ?
                           appWindow.theme.background :
                           appWindow.theme_v2.bgColor

                Rectangle {
                    visible: appWindow.uiver === 1
                    height: parent.height
                    width: 1*appWindow.zoom
                    anchors.right: parent.right
                    color: appWindow.theme.border
                }
            }
        }

        delegate: RowLayout {
            width: connectionsList.width
            height: 22*appWindow.zoom
            spacing: 0

            BaseLabel {
                text: model.host
                Layout.preferredWidth: hostItemWidth
                Layout.minimumWidth: Layout.preferredWidth
                Layout.fillHeight: true
                leftPadding: appWindow.uiver === 1 ? qtbug.leftPadding(6*appWindow.zoom,0) : 0
                rightPadding: appWindow.uiver === 1 ? qtbug.rightPadding(6*appWindow.zoom,0) : 0
            }

            BaseLabel {
                text: model.port
                Layout.preferredWidth: portItemWidth
                Layout.minimumWidth: Layout.preferredWidth
                Layout.fillHeight: true
                leftPadding: appWindow.uiver === 1 ? qtbug.leftPadding(6*appWindow.zoom,0) : 0
                rightPadding: appWindow.uiver === 1 ? qtbug.rightPadding(6*appWindow.zoom,0) : 0
            }

            BaseLabel {
                text: model.connectionCount
                Layout.fillWidth: true
                Layout.fillHeight: true
                leftPadding: appWindow.uiver === 1 ? qtbug.leftPadding(6*appWindow.zoom,0) : 0
                rightPadding: appWindow.uiver === 1 ? qtbug.rightPadding(6*appWindow.zoom,0) : 0
            }
        }
    }
}
