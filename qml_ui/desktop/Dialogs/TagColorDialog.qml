import QtQuick 2.10
import QtQuick.Controls 2.3
import org.freedownloadmanager.fdm 1.0
import "../BaseElements"
import "../../qt5compat"

Popup {
    id: root
    width: (appWindow.uiver === 1 ? 130 : 160)*appWindow.zoom
    padding: 0
    focus: false
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

    property int tagId
    property color tagColor: "#000"
    property string tagName

    leftPadding: (appWindow.uiver === 1 ? 1 : 16)*appWindow.zoom
    rightPadding: leftPadding
    topPadding: (appWindow.uiver === 1 ? 6 : 16)*appWindow.zoom
    bottomPadding: topPadding

    contentItem: Column {
        spacing: 5*appWindow.zoom
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
