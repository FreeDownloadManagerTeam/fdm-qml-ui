import QtQuick 2.11
import QtQuick.Controls 2.3
import "../BaseElements"

Rectangle {
    id: rect
    color: "transparent"

    property string text

    BaseLabel {
        id: lbl
        text: parent.text
        width: parent.width
        wrapMode: Label.Wrap
    }

    Component.onCompleted: {
        rect.implicitHeight = lbl.implicitHeight
    }
}
