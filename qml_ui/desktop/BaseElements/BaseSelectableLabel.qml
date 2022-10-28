import QtQuick 2.11

TextEdit {
    id: selectableLabel
    opacity: enabled ? 1 : 0.5
    font.pixelSize: 14*appWindow.fontZoom
    font.family: Qt.platform.os === "osx" ? font.family : "Arial"
    color: appWindow.theme.foreground
    wrapMode: TextEdit.Wrap
    readOnly: true
    selectByMouse: true
    selectionColor: appWindow.theme.textHighlight
    selectedTextColor: color

    MouseArea {
        height: parent.height
        width: parent.contentWidth
        cursorShape: Qt.IBeamCursor
        acceptedButtons: Qt.RightButton
        onClicked: function (mouse) {showMenu(mouse);}
    }

    onFocusChanged: { if (!focus) { deselect() }}
    onVisibleChanged: { if (!visible) { deselect() }}

    function showMenu(mouse)
    {
        var component = Qt.createComponent("CopyMenu.qml");
        var menu = component.createObject(selectableLabel, {
                                              "text": selectableLabel.selectedText
                                          });
        menu.x = Math.round(mouse.x);
        menu.y = Math.round(mouse.y);
        menu.open();
        menu.aboutToHide.connect(function(){
            menu.destroy();
        });
    }
}
