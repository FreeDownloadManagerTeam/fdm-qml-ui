import QtQuick
import QtQuick.Controls
import "../BaseElements"

Item {
    property alias text: lbl.text

    implicitHeight: lbl.implicitHeight
    implicitWidth: lbl.implicitWidth

    BaseLabel {
        id: lbl
        text: parent.text
        width: parent.width
        wrapMode: Label.Wrap
    }
}
