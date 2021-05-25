import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.4
import org.freedownloadmanager.fdm 1.0
import "../BaseElements"

Drawer {
    id: root
    width: parent.width
    height: 205
    edge: Qt.BottomEdge
    interactive: stackView.depth == 1
    Material.background: appWindow.theme.background
    Material.foreground: appWindow.theme.foreground

    property int selectedMode: 0

    ListView {
        id: sort
        width: 330
        height: parent.height
        anchors.horizontalCenter: parent.horizontalCenter

        header: Pane {
            width: parent.width
            height: 50
            padding: 0

            Label {
                text: qsTr("Sort") + App.loc.emptyString
                font.pixelSize: 17
                font.weight: Font.DemiBold
                anchors.topMargin: 15
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
            }
        }

        model: sortTools.sortByValues

        delegate: RadioDelegate {
            id: control
            text: sortTools.getSortTitle(modelData)
            checked: sortTools.sortBy === modelData
            width: parent.width
            height: 30
            font.pixelSize: 14
            onClicked: {selectedMode = modelData}
            padding: 0

            indicator: Rectangle {

                implicitWidth: 18
                implicitHeight: 18
                x: control.width - width - control.rightPadding
                y: parent.height / 2 - height / 2
                radius: 9
                color: control.checked ? appWindow.theme.toolbarBackground : "transparent"
                border.color: appWindow.theme.toolbarBackground
                border.width: 2

                Rectangle {
                    width: 8
                    height: 8
                    x: 5
                    y: 5
                    radius: 4
                    color: "#FFFFFF"
                    visible: control.checked
                }
            }

            Rectangle
            {
                color: appWindow.theme.border
                width: parent.width
                anchors.bottom: parent.bottom
                height: 1
                visible: modelData !== sortTools.sortByValues.length
            }
        }

        footer: RowLayout {
            width: parent.width
            height: 65

            RoundButton {
                text: qsTr("Ascending") + App.loc.emptyString
                icon.source: Qt.resolvedUrl("../../images/mobile/asc.svg")
                icon.color: appWindow.theme.sortButton
                icon.width: 14
                icon.height: 14
                Material.foreground: appWindow.theme.sortButton
                implicitWidth: 166
                height: 48
                flat: true
                font.capitalization: Font.MixedCase
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                onClicked: {
                    sortTools.setSortBy(selectedMode > 0 ? selectedMode : sortTools.sortBy, true);
                    root.close();
                }
            }

            Rectangle {
                width: 1
                height: 20
                color: appWindow.theme.border
                Layout.alignment: Qt.AlignCenter

            }

            RoundButton {
                text: qsTr("Descending") + App.loc.emptyString
                icon.source: Qt.resolvedUrl("../../images/mobile/desc.svg")
                icon.color: appWindow.theme.sortButton
                icon.width: 14
                icon.height: 14
                Material.foreground: appWindow.theme.sortButton
                implicitWidth: 166
                height: 48
                flat: true
                font.capitalization: Font.MixedCase
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                onClicked: {
                    sortTools.setSortBy(selectedMode > 0 ? selectedMode : sortTools.sortBy, false);
                    root.close();
                }
            }
        }
    }
}
