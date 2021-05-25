import QtQuick 2.0
import QtQuick.Layouts 1.3

ColumnLayout {
    property string titleText
    width: parent.width
    spacing: 10
    signal closeClick

    DialogTitle {
        Layout.fillWidth: true
        text: titleText
        onCloseClick: {
            parent.closeClick();
        }
    }
}
