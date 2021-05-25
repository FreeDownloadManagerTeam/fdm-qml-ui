import QtQuick 2.11

Item {
    id: root
    focus: true

    Connections {
        target: appWindow
        // commented: this thing breaks setting focus by mouse;
        // I don't know what it was for, but it works too bad anyway
        //onGlobalFocusLost: setFocusIfNeed()
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
