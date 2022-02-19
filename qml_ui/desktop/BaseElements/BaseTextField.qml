import QtQuick 2.0
import QtQuick.Controls 2.3
import org.freedownloadmanager.fdm 1.0
import "../BaseElements"

TextField {
    id: textInput
    implicitHeight: /*appWindow.macVersion ? 26 :*/ 30
    selectByMouse: true
    selectionColor: appWindow.theme.textHighlight
    selectedTextColor: appWindow.theme.foreground
    font.pixelSize: 14
    color: appWindow.theme.foreground//enabled ? "#000" : "#757575"
    opacity: enabled ? 1 : 0.5
    horizontalAlignment: TextInput.AlignLeft

    background: Rectangle {
        border.color: appWindow.theme.border
        border.width: 1
        color: appWindow.theme.background
//        radius: appWindow.macVersion ? appWindow.theme.textFieldBorderRadiusMac : 0
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.RightButton
        hoverEnabled: true
        property int selectStart
        property int selectEnd
        property int curPos
        onClicked: function (mouse) {
            selectStart = textInput.selectionStart;
            selectEnd = textInput.selectionEnd;
            curPos = textInput.cursorPosition;
            contextMenu.x = mouse.x;
            contextMenu.y = mouse.y;
            contextMenu.open();
            textInput.cursorPosition = curPos;
            textInput.select(selectStart,selectEnd);
        }
        onPressAndHold: function (mouse) {
            if (mouse.source === Qt.MouseEventNotSynthesized) {
                selectStart = textInput.selectionStart;
                selectEnd = textInput.selectionEnd;
                curPos = textInput.cursorPosition;
                contextMenu.x = mouse.x;
                contextMenu.y = mouse.y;
                contextMenu.open();
                textInput.cursorPosition = curPos;
                textInput.select(selectStart,selectEnd);
            }
        }

        BaseContextMenu {
            id: contextMenu
            Action {
                text: qsTr("Cut") + App.loc.emptyString
                onTriggered: {
                    textInput.cut()
                }
            }
            Action {
                text: qsTr("Copy") + App.loc.emptyString
                onTriggered: {
                    textInput.copy()
                }
            }
            Action {
                text: qsTr("Paste") + App.loc.emptyString
                onTriggered: {
                    textInput.paste()
                }
            }
        }
    }
}
