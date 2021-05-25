import QtQuick 2.10
import QtQuick.Controls 2.3
import org.freedownloadmanager.fdm 1.0
import "../BaseElements"

ComboBox {
    id: root
    height: 25
    width: 100
    rightPadding: 5
    leftPadding: 5

    property int visibleRowsCount: 5

    model: []

    delegate: Rectangle {
        property bool hover: false
        color: hover ? appWindow.theme.menuHighlight : "transparent"
        height: 18
        width: root.width

        BaseLabel {
            leftPadding: 6
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 12
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
        radius: 5
        border.color: appWindow.theme.settingsControlBorder
        border.width: 1
    }

    contentItem: Rectangle {
        color: "transparent"
        BaseLabel {
            leftPadding: 2
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 12
            color: appWindow.theme.settingsItem
            text: root.model[currentIndex].text
        }
    }

    indicator: Rectangle {
        x: root.width - width
        y: root.topPadding + (root.availableHeight - height) / 2
        width: height - 1
        height: root.height
        color: "transparent"
        Rectangle {
            width: 9
            height: 8
            color: "transparent"
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            clip: true
            Image {
                source: appWindow.theme.elementsIcons
                sourceSize.width: 93
                sourceSize.height: 456
                x: 0
                y: -448
            }
        }
    }

    popup: Popup {
        y: root.height
        width: root.width
        height: 18 * root.model.length + 2
        padding: 1

        background: Rectangle {
            color: appWindow.theme.background
            border.color: appWindow.theme.settingsControlBorder
            border.width: 1
        }

        contentItem: Item {
            ListView {
                clip: true
                anchors.fill: parent
                model: root.model
                currentIndex: root.highlightedIndex
                delegate: root.delegate
                flickableDirection: Flickable.VerticalFlick
                boundsBehavior: Flickable.StopAtBounds
            }
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
