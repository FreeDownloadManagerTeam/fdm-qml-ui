import QtQuick 2.11

TextEdit {
    id: selectableLabel

    opacity: enabled ? 1 : (appWindow.uiver === 1 ? 0.5 : appWindow.theme_v2.opacityDisabled)

    font.pixelSize: appWindow.uiver === 1 ?
                        14*appWindow.fontZoom :
                        appWindow.theme_v2.fontSize*appWindow.fontZoom

    font.family: appWindow.uiver === 1 ?
                     (Qt.platform.os === "osx" ? font.family : "Arial") :
                     appWindow.theme_v2.fontFamily

    font.weight: appWindow.uiver === 1 ? 400 : 500

    color: appWindow.uiver === 1 ?
               appWindow.theme.foreground :
               appWindow.theme_v2.textColor

    wrapMode: TextEdit.Wrap

    readOnly: true
    selectByMouse: true

    selectionColor: appWindow.uiver === 1 ?
                        appWindow.theme.textHighlight :
                        appWindow.theme_v2.selectedTextBgColor

    selectedTextColor: appWindow.uiver === 1 ?
                           color :
                           appWindow.theme_v2.selectedTextColor

    horizontalAlignment: TextEdit.AlignLeft

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
