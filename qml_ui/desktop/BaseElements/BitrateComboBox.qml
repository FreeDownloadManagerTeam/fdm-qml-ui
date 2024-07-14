import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0
import "../BaseElements"
import "../../common"

BaseComboBox {
    id: root
    height: 25*appWindow.zoom
    rightPadding: 5*appWindow.zoom
    leftPadding: 5*appWindow.zoom

    property int visibleRowsCount: 5
    property bool constantBitrate: false

    property int minBitrate
    property int maxBitrate

    property int popupWidth: 120*appWindow.zoom

    property string kbps: qsTr("kbps") + App.loc.emptyString

    implicitWidth: (constantBitrate ?
                       fontMetrics.advanceWidth(root.kbpsText(999)) :
                       fontMetrics.advanceWidth(root.vbrKbpsText(999,999))) +
                   50*appWindow.zoom + fontMetrics.font.pixelSize*0

    model: []

    delegate: Rectangle {
        property bool hover: false
        color: hover ? appWindow.theme.menuHighlight : "transparent"
        height: 18*appWindow.zoom
        width: constantBitrate ? popupWidth : root.width

        BaseLabel {
            anchors.left: parent.left
            leftPadding: qtbug.leftPadding(6*appWindow.zoom, 0)
            rightPadding: qtbug.rightPadding(6*appWindow.zoom, 0)
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 12*appWindow.fontZoom
            color: appWindow.theme.settingsItem
            text: modelData.text
            font.weight: index === currentIndex ? Font.DemiBold : Font.Normal
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: parent.hover = true
            onExited: parent.hover = false
            onClicked: {
                root.currentIndex = index;
                root.setCurrentValue();
                root.applyValues();
                root.popup.close();
            }
        }
    }

    popup: Popup {
        y: root.height-1
        width: constantBitrate ? popupWidth : root.width
        height: 18*appWindow.zoom * root.model.length + 2*appWindow.zoom
        padding: 1*appWindow.zoom

        background: Rectangle {
            color: appWindow.theme.background
            border.color: appWindow.theme.settingsControlBorder
            border.width: 1*appWindow.zoom
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

    Connections {
        target: App.loc
        onCurrentTranslationChanged: root.reloadCombo()
    }

    function kbpsText(value, desc)
    {
        var result = value.toString() + ' ' + kbps;
        if (desc)
            result += " (" + desc + ")";
        return result;
    }

    function vbrKbpsText(from, to, desc)
    {
        var result = qsTr("From %1 %2 to %3 %4").arg(from).arg(kbps).arg(to).arg(kbps);
        if (desc)
            result += " (" + desc + ")";
        return result;
    }

    function reloadCombo() {
        if (constantBitrate) {
            root.model = [
                        {text: kbpsText(320, qsTr("CD quality")), value: 320},
                        {text: kbpsText(256, qsTr("High quality")), value: 256},
                        {text: kbpsText(224), value: 224},
                        {text: kbpsText(192, qsTr("Medium quality")), value: 192},
                        {text: kbpsText(160), value: 160},
                        {text: kbpsText(128, qsTr("Radio quality")), value: 128},
                        {text: kbpsText(112), value: 112},
                        {text: kbpsText(96, qsTr("Low quality")), value: 96},
                        {text: kbpsText(80), value: 80},
                        {text: kbpsText(64), value: 64},
                        {text: kbpsText(48), value: 48},
                        {text: kbpsText(40), value: 40},
                        {text: kbpsText(32, qsTr("Speech")), value: 32},
                        {text: kbpsText(24), value: 24},
                        {text: kbpsText(16), value: 16},
                        {text: kbpsText(8, qsTr("Lowest quality, smallest file size")), value: 8},
                    ];
            root.currentIndex = root.model.findIndex(e => e.value == minBitrate);
        } else {
            root.model = [
                        {text: vbrKbpsText(220,260), value: '{220, 260}'},
                        {text: vbrKbpsText(190,250), value: '{190, 250}'},
                        {text: vbrKbpsText(170,210), value: '{170, 210}'},
                        {text: vbrKbpsText(150,195), value: '{150, 195}'},
                        {text: vbrKbpsText(140,185), value: '{140, 185}'},
                        {text: vbrKbpsText(120,150), value: '{120, 150}'},
                        {text: vbrKbpsText(100,130), value: '{100, 130}'},
                        {text: vbrKbpsText(80,120), value: '{80, 120}'},
                        {text: vbrKbpsText(70,105), value: '{70, 105}'},
                        {text: vbrKbpsText(45,85), value: '{45, 85}'}
                    ];
            root.currentIndex = root.model.findIndex(e => e.value == '{' + minBitrate + ', ' + maxBitrate + '}');
        }

        if (root.currentIndex == -1) {
            root.currentIndex = 0;
        }

        setCurrentValue();
        setPopupWidth();
    }

    function applyValues() {
        if (constantBitrate) {
            minBitrate = maxBitrate = parseInt(model[currentIndex].value);
        } else {
            var str = model[currentIndex].value;

            const reg = /\d+/g;
            const m = str.match(reg);
            minBitrate = m[0];
            maxBitrate = m[1];
        }
    }

    function setPopupWidth() {
        if (constantBitrate) {
            var maxVal = 0;
            var currentVal = 0;
            for (var index in model) {
                currentVal = checkTextSize(model[index].text);
                maxVal = maxVal < currentVal ? currentVal : maxVal;
            }
            popupWidth = maxVal + 20*appWindow.zoom;
        } else {
            popupWidth = 120*appWindow.zoom;
        }
    }

    function setCurrentValue() {
        contentItem.text = constantBitrate ? root.model[currentIndex].value + ' ' + kbps : root.model[currentIndex].text
    }

    function checkTextSize(text)
    {
        textMetrics.text = text;
        return textMetrics.width;
    }

    TextMetrics {
        id: textMetrics
        font.pixelSize: 12*appWindow.fontZoom
        font.family: Qt.platform.os === "osx" ? font.family : "Arial"
    }
}
