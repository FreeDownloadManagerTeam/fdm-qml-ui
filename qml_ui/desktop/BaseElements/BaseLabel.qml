import QtQuick 2.11
import QtQuick.Controls 2.3

Label {
    opacity: enabled ? 1 : 0.5
    font.pixelSize: 14
    font.family: Qt.platform.os === "osx" ? font.family : "Arial"
    color: appWindow.theme.foreground
    linkColor: appWindow.theme.link
    horizontalAlignment: Text.AlignLeft
}
