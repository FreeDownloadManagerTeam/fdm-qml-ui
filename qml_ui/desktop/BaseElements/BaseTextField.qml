import QtQuick 2.0
import QtQuick.Controls 2.3
import org.freedownloadmanager.fdm 1.0
import "../BaseElements"

TextField {
    id: textInput

    property bool enable_QTBUG_110471_workaround: true
    property bool enable_QTBUG_110471_workaround_2: false
    property bool selectAllAtInit: false

    implicitHeight: 30*appWindow.fontZoom
    selectByMouse: true
    selectionColor: appWindow.theme.textHighlight
    selectedTextColor: appWindow.theme.foreground
    font.pixelSize: 14*appWindow.fontZoom
    color: appWindow.theme.foreground
    opacity: enabled ? 1 : 0.5
    horizontalAlignment: TextInput.AlignLeft

    background: Rectangle {
        border.color: appWindow.theme.border
        border.width: 1*appWindow.zoom
        color: appWindow.theme.background
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

    Component.onCompleted: {
        // https://bugreports.qt.io/browse/QTBUG-110471
        if (enable_QTBUG_110471_workaround &&
                appWindow.LayoutMirroring.enabled &&
                !LayoutMirroring.enabled)
        {
            LayoutMirroring.enabled = Qt.binding(() => appWindow.LayoutMirroring.enabled);
            if (enable_QTBUG_110471_workaround_2)
            {
                let t = text;
                text = t + ' ';
                text = t;
            }
        }
        if (selectAllAtInit)
            selectAll();
    }
}
