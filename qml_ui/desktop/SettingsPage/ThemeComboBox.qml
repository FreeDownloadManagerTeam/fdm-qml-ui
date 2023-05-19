import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.dmcoresettings 1.0
import org.freedownloadmanager.fdm.appsettings 1.0
import "../BaseElements"
import "../../common"

ComboBox {
    id: root
    height: 25*appWindow.fontZoom
    width: 100*appWindow.fontZoom
    implicitWidth: popupWidth + 30*appWindow.zoom
    implicitHeight: 25*appWindow.fontZoom
    rightPadding: 5*appWindow.zoom
    leftPadding: 5*appWindow.zoom

    property int popupWidth: 120*appWindow.fontZoom

    Layout.preferredWidth: popupWidth + 30*appWindow.zoom

    model: []

    delegate: Rectangle {
        property bool hover: false
        color: hover ? appWindow.theme.menuHighlight : "transparent"
        height: 18*appWindow.fontZoom
        width: root.width

        BaseLabel {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            leftPadding: qtbug.leftPadding(6*appWindow.zoom, 0)
            rightPadding: qtbug.rightPadding(6*appWindow.zoom, 0)
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
        radius: 5*appWindow.zoom
        border.color: appWindow.theme.settingsControlBorder
        border.width: 1*appWindow.zoom
    }

    contentItem: Rectangle {
        color: "transparent"
        BaseLabel {
            anchors.left: parent.left
            leftPadding: qtbug.leftPadding(2*appWindow.zoom,0)
            rightPadding: qtbug.rightPadding(2*appWindow.zoom,0)
            anchors.verticalCenter: parent.verticalCenter
            color: appWindow.theme.settingsItem
            text: root.model.length ? root.model[currentIndex].text : ""
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
        height: 18*appWindow.fontZoom * root.model.length + 2*appWindow.zoom
        padding: 1*appWindow.zoom

        background: Rectangle {
            color: appWindow.theme.background
            border.color: appWindow.theme.settingsControlBorder
            border.width: 1*appWindow.zoom
        }

        contentItem: ListView {
            clip: true
            model: root.model
            currentIndex: root.highlightedIndex
            delegate: root.delegate
            flickableDirection: Flickable.VerticalFlick
            boundsBehavior: Flickable.StopAtBounds
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

    BaseLabel {id: hiddenLabel; visible: false}

    TextMetrics {
        id: textMetrics
        font: hiddenLabel.font
    }
}
