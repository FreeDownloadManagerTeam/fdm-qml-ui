import QtQuick 2.11
import QtQuick.Controls 2.3
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
