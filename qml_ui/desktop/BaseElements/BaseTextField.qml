import QtQuick
import QtQuick.Controls
import org.freedownloadmanager.fdm
import "../BaseElements"

TextField {
    id: textInput

    property bool enable_QTBUG_110471_workaround: true
    property bool enable_QTBUG_110471_workaround_2: false
    property bool selectAllAtInit: false

    leftPadding: (appWindow.uiver === 1 ? 4 : 8)*appWindow.zoom
    rightPadding: leftPadding

    implicitHeight: 30*appWindow.fontZoom
    selectByMouse: true
    selectionColor: appWindow.uiver === 1 ?
                        appWindow.theme.textHighlight :
                        appWindow.theme_v2.selectedTextBgColor
    selectedTextColor: appWindow.uiver === 1 ?
                           appWindow.theme.foreground :
                           appWindow.theme_v2.selectedTextColor
    font.pixelSize: appWindow.uiver === 1 ?
                        14*appWindow.fontZoom :
                        appWindow.theme_v2.fontSize*appWindow.fontZoom
    font.family: appWindow.uiver === 1 ?
                     (Qt.platform.os === "osx" ? font.family : "Arial") :
                     appWindow.theme_v2.fontFamily
    color: appWindow.uiver === 1 ?
               appWindow.theme.foreground :
               appWindow.theme_v2.textColor
    placeholderTextColor: appWindow.uiver === 1 ?
                              appWindow.theme.placeholder :
                              appWindow.theme_v2.placeholderTextColor
    opacity: enabled ? 1 : (appWindow.uiver === 1 ? 0.5 : appWindow.theme_v2.opacityDisabled)
    horizontalAlignment: TextInput.AlignLeft

    background: Rectangle {
        border.color: appWindow.uiver === 1 ?
                          appWindow.theme.border :
                          (textInput.activeFocus ? appWindow.theme_v2.primary : appWindow.theme_v2.editTextBorderColor)
        border.width: 1*appWindow.zoom
        color: appWindow.uiver === 1 ?
                   appWindow.theme.background :
                   appWindow.theme_v2.bgColor
        radius: appWindow.uiver === 1 ? 0 : 8*appWindow.zoom
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
