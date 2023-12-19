import QtQuick 2.0
import QtQuick.Controls 2.3
import org.freedownloadmanager.fdm 1.0
import "../BaseElements"

Rectangle {
    id: root

    property alias text: textArea.text
    property alias textFormat: textArea.textFormat
    property alias readOnly: textArea.readOnly
    property alias rightPadding: textArea.rightPadding
    property alias wrapMode: textArea.wrapMode
    signal selectAll

    property bool enable_QTBUG_110471_workaround: true
    property bool tabChangesFocus: false

    border.width: 1*appWindow.zoom
    border.color: appWindow.theme.border

    onSelectAll: textArea.selectAll()

    Flickable {
        id: flickable

        property bool hasVerticalScrollbar: contentHeight > height

        anchors.fill: parent
        anchors.margins: 1*appWindow.zoom
        clip: true
        flickableDirection: Flickable.VerticalFlick

        ScrollBar.vertical: ScrollBar {
            policy: flickable.hasVerticalScrollbar ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
        }
        ScrollBar.horizontal: null

        TextArea.flickable: TextArea {
            id: textArea
            horizontalAlignment: TextArea.AlignLeft
            focus: true
            wrapMode: TextArea.WordWrap
            font.pixelSize: 14*appWindow.fontZoom
            color: appWindow.theme.foreground
            selectByMouse: true
            Keys.onEscapePressed: root.close()
            Keys.onTabPressed: {
                if (root.tabChangesFocus)
                    nextItemInFocusChain().forceActiveFocus(Qt.TabFocusReason)
                else
                    event.accepted = false
            }

            background: Rectangle {
                color: appWindow.theme.background
            }

            Component.onCompleted: {
                // https://bugreports.qt.io/browse/QTBUG-110471
                if (enable_QTBUG_110471_workaround &&
                        appWindow.LayoutMirroring.enabled &&
                        !LayoutMirroring.enabled)
                {
                    LayoutMirroring.enabled = Qt.binding(() => appWindow.LayoutMirroring.enabled);
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.RightButton
        hoverEnabled: true
        property int selectStart
        property int selectEnd
        property int curPos
        onClicked: function (mouse) {
            selectStart = textArea.selectionStart;
            selectEnd = textArea.selectionEnd;
            curPos = textArea.cursorPosition;
            contextMenu.x = mouse.x;
            contextMenu.y = mouse.y;
            contextMenu.open();
            textArea.cursorPosition = curPos;
            textArea.select(selectStart,selectEnd);
        }
        onPressAndHold: function (mouse) {
            if (mouse.source === Qt.MouseEventNotSynthesized) {
                selectStart = textArea.selectionStart;
                selectEnd = textArea.selectionEnd;
                curPos = textArea.cursorPosition;
                contextMenu.x = mouse.x;
                contextMenu.y = mouse.y;
                contextMenu.open();
                textArea.cursorPosition = curPos;
                textArea.select(selectStart,selectEnd);
            }
        }

        BaseContextMenu {
            id: contextMenu
            Action {
                text: qsTr("Cut") + App.loc.emptyString
                onTriggered: {
                    textArea.cut()
                }
            }
            Action {
                text: qsTr("Copy") + App.loc.emptyString
                onTriggered: {
                    textArea.copy()
                }
            }
            Action {
                text: qsTr("Paste") + App.loc.emptyString
                onTriggered: {
                    textArea.paste()
                }
            }
        }
    }
}
