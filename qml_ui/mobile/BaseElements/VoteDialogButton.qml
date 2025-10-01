import QtQuick
import QtQuick.Controls

Button {
    id: control

    leftPadding: 16
    rightPadding: 16

    property bool yesBtn: false
    property color textColor: yesBtn ? appWindow.theme.voteDialogYesBtnText : appWindow.theme.voteDialogNoBtnText
    property color backgroundColor: yesBtn ? appWindow.theme.voteDialogYesBtnBackground : appWindow.theme.voteDialogNoBtnBackground
    property color borderColor: yesBtn ? appWindow.theme.voteDialogYesBtnBorder : appWindow.theme.voteDialogNoBtnBorder

    contentItem: Text {
        text: control.text
        font.capitalization: Font.MixedCase
        font.pixelSize: 14
        font.weight: yesBtn ? Font.Normal : Font.Light
        opacity: enabled ? 1.0 : 0.3
        color: control.down ? textColor : textColor
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        opacity: enabled ? 1 : 0.3
        border.color: control.down ? borderColor : borderColor
        border.width: yesBtn ? 2 : 1
        radius: 6
        color: backgroundColor
    }
}
