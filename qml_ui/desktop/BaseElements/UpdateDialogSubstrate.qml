import QtQuick 2.0

MouseArea {
    id: root
    anchors.fill: parent
    enabled: false
    visible: enabled

    onClicked: appWindow.updateDlgClosed()

    Connections {
        target: appWindow
        onUpdateDlgOpened: {root.enabled = true}
        onUpdateDlgClosed: {root.enabled = false}
    }
}
