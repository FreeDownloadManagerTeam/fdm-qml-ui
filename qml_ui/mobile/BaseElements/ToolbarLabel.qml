import QtQuick 2.0
import QtQuick.Controls 2.1

Label {
    clip: true
    elide: Label.ElideMiddle
    horizontalAlignment: Qt.AlignHCenter
    verticalAlignment: Qt.AlignVCenter
    font.pixelSize: 20
    font.family: "Roboto"
    font.weight: Font.DemiBold
    color: appWindow.theme.toolbarTextColor
}
