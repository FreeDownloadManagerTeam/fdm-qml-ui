import QtQuick 2.0
import QtQuick.Controls 2.3
import "../../qt5compat"
import "../../common"

BaseComboBox {
    id: root

    signal textChanged(string str)

    rightPadding: 5*appWindow.zoom
    leftPadding: 5*appWindow.zoom

    editable: true

    popupVisibleRowsCount: 7
    delegateMinimumHeight: 30*appWindow.zoom

    textRole: ""
    model: ["00:00", "01:00", "02:00", "03:00", "04:00", "05:00", "06:00", "07:00", "08:00", "09:00", "10:00", "11:00", "12:00",
            "13:00", "14:00", "15:00", "16:00", "17:00", "18:00", "19:00", "20:00", "21:00", "22:00", "23:00", "23:59"]
    currentIndex: -1

    onActivated: index => root.textChanged(model[index]);

    contentItem: BaseTextField {
        text: root.editText
        leftPadding: qtbug.leftPadding(0, 30*appWindow.zoom)
        rightPadding: qtbug.rightPadding(0, 30*appWindow.zoom)
        selectByMouse: true
        background: Rectangle {
            color: "transparent"
            border.color: "transparent"
        }

        inputMethodHints: Qt.ImhTime
        validator: QtRegExpValidator { regExp: /^(\d{0,2})([:]\d{0,2})?$/ }
        placeholderText: "00:00"
        onActiveFocusChanged: {
            if (!activeFocus) {
                root.textChanged(text)
            }
        }
        onAccepted: root.textChanged(text)
    }

    function setValue(value)
    {
        currentIndex = model.indexOf(value);
        editText = value;
    }
}
