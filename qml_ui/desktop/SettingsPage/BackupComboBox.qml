import QtQuick 2.10
import QtQuick.Controls 2.3
import org.freedownloadmanager.fdm 1.0
import "../BaseElements"
import "../../common"

ComboBox {
    id: root
    height: 25*appWindow.zoom
    width: 70*appWindow.fontZoom + 30*appWindow.zoom
    rightPadding: 5*appWindow.zoom
    leftPadding: 5*appWindow.zoom

    property int visibleRowsCount: 5

    model: []

    delegate: Rectangle {
        property bool hover: false
        color: hover ? appWindow.theme.menuHighlight : "transparent"
        height: 18*appWindow.zoom
        width: root.width

        BaseLabel {
            anchors.left: parent.left
            leftPadding: qtbug.leftPadding(6*appWindow.zoom, 0)
            rightPadding: qtbug.rightPadding(6*appWindow.zoom, 0)
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 12*appWindow.fontZoom
            color: appWindow.theme.settingsItem
            text: modelData.text
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: parent.hover = true
            onExited: parent.hover = false
            onClicked: {
                root.currentIndex = index;
                App.settings.setDbBackupMinInterval(modelData.value);
                root.popup.close();
            }
        }
    }

    background: Rectangle {
        color: "transparent"
        radius: 5*appWindow.zoom
        border.color: appWindow.theme.settingsControlBorder
        border.width: 1*appWindow.zoom
    }

    contentItem: Rectangle {
        color: "transparent"
        BaseLabel {
            anchors.left: parent.left
            leftPadding: qtbug.leftPadding(6*appWindow.zoom, 0)
            rightPadding: qtbug.rightPadding(6*appWindow.zoom, 0)
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 12*appWindow.fontZoom
            color: appWindow.theme.settingsItem
            text: root.model[currentIndex].text
        }
    }

    indicator: Rectangle {
        x: LayoutMirroring.enabled ? 0 : root.width - width
        y: root.topPadding + (root.availableHeight - height) / 2
        width: height - 1*appWindow.zoom
        height: root.height
        color: "transparent"
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
        y: root.height
        width: root.width
        height: 18*appWindow.zoom * root.model.length + 2*appWindow.zoom
        padding: 1*appWindow.zoom

        background: Rectangle {
            color: appWindow.theme.background
            border.color: appWindow.theme.settingsControlBorder
            border.width: 1*appWindow.zoom
        }

        contentItem: ListView {
            clip: true
            anchors.fill: parent
            model: root.model
            currentIndex: root.highlightedIndex
            delegate: root.delegate
            flickableDirection: Flickable.VerticalFlick
            boundsBehavior: Flickable.StopAtBounds
        }
    }

    Component.onCompleted: root.reloadCombo(App.settings.dbBackupMinInterval())

    Connections {
        target: App.loc
        onCurrentTranslationChanged: root.reloadCombo()
    }

    function reloadCombo(defaultValue) {
        if (defaultValue == -1) {
            defaultValue = 10800;//3 hours
        } else if (root.model.length) {
            defaultValue = root.model[root.currentIndex].value;
        }

        root.model = [ {text: qsTr("5 minutes"), value: 300},
                       {text: qsTr("15 minutes"), value: 900},
                       {text: qsTr("1 hour"), value: 3600},
                       {text: qsTr("3 hours"), value: 10800},
                       {text: qsTr("1 day"), value: 86400} ];

        root.currentIndex = root.model.findIndex(e => e.value == defaultValue);
    }
}
