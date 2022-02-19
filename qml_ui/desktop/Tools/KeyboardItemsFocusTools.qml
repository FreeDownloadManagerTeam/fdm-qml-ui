import QtQuick 2.11

Item {
    id: root
    focus: true

    Connections {
        target: appWindow
        
        onModalDialogOpenedChanged: setFocusIfNeed()
        onAppWindowStateChanged: setFocusIfNeed()
    }

    function setFocusIfNeed()
    {
        if (!appWindow.modalDialogOpened) {
            if (stackView && stackView.currentItem && stackView.currentItem.keyboardFocusItem) {
                stackView.currentItem.keyboardFocusItem.focus = true;
            }
        }
    }
}
