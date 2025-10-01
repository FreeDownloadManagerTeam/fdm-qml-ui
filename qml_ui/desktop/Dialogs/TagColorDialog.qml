import QtQuick 2.10
import QtQuick.Controls 2.3
import org.freedownloadmanager.fdm 1.0
import "../BaseElements"
import "../../qt5compat"

Popup {
    id: root
    padding: 0
    focus: false
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

    property int tagId
    property color tagColor: "#000"
    property string tagName

    leftPadding: 16*appWindow.zoom
    rightPadding: leftPadding
    topPadding: 16*appWindow.zoom
    bottomPadding: topPadding

    contentItem: TagPalette {
        selectedColor: tagColor
        onColorSelected: (selectedColor) => {
            root.tagColor = selectedColor;
            tagsTools.changeTagColor(tagId, selectedColor)
        }
        onCloseTagColorDialog: root.close()
    }

    background: Item {

        RectangularGlow {
            visible: appWindow.uiver !== 1 && appWindow.theme_v2.useGlow
            anchors.fill: parent
            color: appWindow.theme_v2.glowColor
            glowRadius: 0
            spread: 0
            cornerRadius: bgr.radius
        }

        Rectangle {
            id: bgr
            anchors.fill: parent
            color: appWindow.uiver === 1 ?
                       appWindow.theme.background :
                       appWindow.theme_v2.bg100
            border.width: 1*appWindow.zoom
            border.color: appWindow.uiver === 1 ?
                              appWindow.theme.border :
                              appWindow.theme_v2.bg200
            radius: appWindow.uiver === 1 ? 0 : 8*appWindow.zoom
        }
    }
}
