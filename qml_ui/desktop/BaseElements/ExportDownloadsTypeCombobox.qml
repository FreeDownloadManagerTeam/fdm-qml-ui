import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0
import "../../common"

ComboBox {
    id: root

    rightPadding: 5*appWindow.zoom
    leftPadding: 5*appWindow.zoom

    property int visibleRowsCount: 3
    property string extension: "fdd"
    property string filter: qsTr("%1 downloads files (%2)").arg(App.shortDisplayName).arg("*.fdd") + App.loc.emptyString

    model: []
    textRole: "text"

    delegate: Rectangle {
        property bool hover: false
        color: hover ? appWindow.theme.menuHighlight : "transparent"
        height: 30*appWindow.zoom
        width: parent.width
        BaseLabel {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            leftPadding: qtbug.leftPadding(4*appWindow.zoom, 0)
            rightPadding: qtbug.rightPadding(4*appWindow.zoom, 0)
            text: modelData.text
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: parent.hover = true
            onExited: parent.hover = false
            onClicked: {
                root.currentIndex = index
                extension = modelData.extension;
                filter = modelData.filter;
                root.popup.close();
            }
        }
    }

    background: Rectangle {
        color: appWindow.theme.background
        border.color: appWindow.theme.border
        border.width: 1*appWindow.zoom
    }

    contentItem: Rectangle {
        color: "transparent"
        BaseLabel {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            text: root.displayText
        }
    }

    indicator: Rectangle {
        x: LayoutMirroring.enabled ? 0 : root.width - width
        y: root.topPadding + (root.availableHeight - height) / 2
        width: height - 1*appWindow.zoom
        height: root.height
        color: "transparent"
        border.width: 1*appWindow.zoom
        border.color: appWindow.theme.border
        Rectangle {
            width: 9*appWindow.zoom
            height: 8*appWindow.zoom
            color: "transparent"
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            clip: true
            WaSvgImage {
                source: appWindow.theme.elementsIcons
                zoom: appWindow.zoom
                x: 0
                y: -448*zoom
            }
        }
    }

    popup: Popup {
        y: root.height - 1
        width: root.width
        height: visibleRowsCount * 30*appWindow.zoom + 2*appWindow.zoom
        padding: 1*appWindow.zoom

        background: Rectangle {
            color: appWindow.theme.background
            border.color: appWindow.theme.border
            border.width: 1*appWindow.zoom
        }

        contentItem: Item {
            ListView {
                clip: true
                anchors.fill: parent
                model: root.model
                currentIndex: root.highlightedIndex
                delegate: root.delegate
            }
        }
    }

    Component.onCompleted: root.reloadCombo()

    Connections {
        target: App.loc
        onCurrentTranslationChanged: root.reloadCombo()
    }

    function reloadCombo() {
        root.model = [{ text: qsTr("Default format"), extension: 'fdd', filter: qsTr("%1 downloads files (%2)").arg(App.shortDisplayName).arg("*.fdd") },
                      { text: qsTr("List of URLs"), extension: 'txt', filter: qsTr("Text files (%1)").arg("*.txt") },
                      { text: qsTr("CSV file"), extension: 'csv', filter: qsTr("CSV files (%1)").arg("*.csv") }];
    }
}
