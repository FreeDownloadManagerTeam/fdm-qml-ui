import QtQuick 2.10
import QtQuick.Controls 2.3
import org.freedownloadmanager.fdm 1.0
import "../BaseElements"

Popup {
    id: root
    width: 130*appWindow.zoom
    padding: 0
    focus: false
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

    property int tagId
    property color tagColor: "#000"
    property string tagName

    contentItem: Column {
        spacing: 5*appWindow.zoom
        padding: 1*appWindow.zoom
        topPadding: 6*appWindow.zoom
        bottomPadding: 6*appWindow.zoom
        width: parent.width - 2*appWindow.zoom

        TagPalette {
            selectedColor: tagColor
            width: parent.width - 2*appWindow.zoom

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
        border.width: 1*appWindow.zoom
        border.color: appWindow.theme.border
    }
}
