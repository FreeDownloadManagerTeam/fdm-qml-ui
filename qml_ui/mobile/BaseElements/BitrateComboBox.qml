import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import "../BaseElements"

BaseComboBox
{
    id: root

    property bool constantBitrate: false
    property int minBitrate
    property int maxBitrate
    property string kbps: qsTr("kbps") + App.loc.emptyString
    property int popupWidth: 300
    property int maxComboWidth: 300

    implicitWidth: 70 + fontMetrics.boundingRect(
               constantBitrate ?
                   root.kbpsText(999, "") :
                   root.vbrKbpsText(999,999)).width

    FontMetrics {id: fontMetrics; font.pixelSize: root.fontSize}

    onMaxComboWidthChanged: root.setPopupWidth()

    delegate: Rectangle {
        height: label.contentHeight > 30 ? 50 : 35
        width: constantBitrate ? popupWidth : root.width
        color: appWindow.theme.background
        BaseLabel {
            id: label
            leftPadding: 6
            rightPadding: 6
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            text: modelData.text
            font.pixelSize: root.fontSize
            font.weight: index === currentIndex ? Font.DemiBold : Font.Normal
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            width: parent.width
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                root.currentIndex = index;
                root.setCurrentValue();
                root.applyValues();
                root.popup.close();
            }
        }
    }

    popup: Popup {
        width: constantBitrate ? popupWidth : root.width
        height: 18 * root.model.length + 2
        padding: 1

        x: appWindow.LayoutMirroring.enabled ?
               root.width - width:
               0

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

    function setCurrentValue() {
        contentItem.text = constantBitrate ? root.model[currentIndex].value + ' ' + kbps : root.model[currentIndex].text
    }

    function setPopupWidth() {
        if (constantBitrate) {
            var maxVal = 0;
            var currentVal = 0;
            for (var index in model) {
                currentVal = checkTextSize(model[index].text);
                maxVal = Math.max(maxVal, currentVal);
            }

            popupWidth = Math.min(maxComboWidth, maxVal + 20);
        } else {
            popupWidth = 300;
        }
    }

    function checkTextSize(text)
    {
        textMetrics.text = text;
        return textMetrics.width;
    }

    TextMetrics {
        id: textMetrics
        font.pixelSize: root.fontSize
    }

    Connections {
        target: App.loc
        onCurrentTranslationChanged: root.reloadCombo()
    }
}
