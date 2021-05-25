import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.dmcoresettings 1.0
import org.freedownloadmanager.fdm.appsettings 1.0
import "../BaseElements"

ComboBox {
    id: root
    height: 25
    width: 100
    implicitWidth: popupWidth + 30
    implicitHeight: 25
    rightPadding: 5
    leftPadding: 5

    property int visibleRowsCount: 3
    property int popupWidth: 120

    Layout.preferredWidth: popupWidth + 30

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
                uiSettingsTools.settings.theme = modelData.value
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
            text: root.model.length ? root.model[currentIndex].text : ""
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

    Component.onCompleted: root.reloadCombo()

    Connections {
        target: App.loc
        onCurrentTranslationChanged: root.reloadCombo()
    }

    function reloadCombo() {
        root.model = [
                    {text: qsTr("System"), value: 'system'},
                    {text: qsTr("Light"), value: 'light'},
                    {text: qsTr("Dark"), value: 'dark'},
                ];
        root.currentIndex = root.model.findIndex(e => e.value === uiSettingsTools.settings.theme);
        setPopupWidth();
    }

    function setPopupWidth() {
        var maxVal = 0;
        var currentVal = 0;
        for (var index in model) {
            currentVal = checkTextSize(model[index].text);
            maxVal = maxVal < currentVal ? currentVal : maxVal;
        }
        popupWidth = maxVal + 20;
    }

    function checkTextSize(text)
    {
        textMetrics.text = text;
        return textMetrics.width;
    }

    TextMetrics {
        id: textMetrics
        font.pixelSize: 12
        font.family: Qt.platform.os === "osx" ? font.family : "Arial"
    }
}
