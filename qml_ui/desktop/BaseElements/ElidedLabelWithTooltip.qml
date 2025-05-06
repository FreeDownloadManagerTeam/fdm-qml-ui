import QtQuick 2.12
import "../../common"

BaseLabel
{
    id: label

    property string sourceText: ""
    readonly property int sourceTextWidth: Math.ceil(fm.advanceWidth(sourceText)) + fm.font.pixelSize*0
    readonly property bool containsMouse: ma.containsMouse

    MyFontMetrics {
        id: fm
        font: label.font
    }

    text: fm.myElidedText(
              sourceText,
              width - leftPadding - rightPadding + fm.font.pixelSize*0)

    MouseArea {
        id: ma
        enabled: label.text != label.sourceText
        propagateComposedEvents: true
        anchors.fill: parent
        hoverEnabled: true
        onClicked : function (mouse) {mouse.accepted = false;}
        onPressed: function (mouse) {mouse.accepted = false;}

        BaseToolTip {
            text: label.sourceText
            visible: parent.containsMouse
        }
    }
}
