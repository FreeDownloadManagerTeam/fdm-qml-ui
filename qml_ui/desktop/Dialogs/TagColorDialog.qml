import QtQuick 2.10
import QtQuick.Controls 2.3
import org.freedownloadmanager.fdm 1.0
import "../BaseElements"

Popup {
    id: root
    width: 130
    padding: 0
    focus: false
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

    property int tagId
    property color tagColor: "#000"
    property string tagName

    contentItem: Column {
        spacing: 5
        padding: 1
        topPadding: 6
        bottomPadding: 6
        width: parent.width - 2

        TagPalette {
            selectedColor: tagColor
            width: parent.width - 2

            onColorSelected: {
                root.tagColor = selectedColor;
                console.log("selectedColor", selectedColor);
                tagsTools.changeTagColor(tagId, selectedColor)
            }
            onCloseTagColorDialog: root.close()
        }
    }

    background: Rectangle {
        color: appWindow.theme.background
        border.width: 1
        border.color: appWindow.theme.border
    }
}
