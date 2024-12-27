/*
  WARNING: use |sourceText| property instead of |text| one.
*/

import QtQuick
import QtQuick.Controls
import "../../../common"

BaseText_V2
{
    id: root

    property string sourceText: ""
    readonly property int sourceTextWidth: Math.ceil(fm.advanceWidth(sourceText)) + fm.font.pixelSize*0
    property alias containsMouse: ma.containsMouse

    MyFontMetrics {
        id: fm
        font: root.font
    }

    text: fm.myElidedText(
              sourceText,
              width - leftPadding - rightPadding + fm.font.pixelSize*0)

    MouseArea {
        id: ma
        enabled: root.text != root.sourceText
        propagateComposedEvents: true
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.NoButton
        BaseToolTip_V2 {
            text: root.sourceText
            visible: parent.containsMouse
        }
    }
}
