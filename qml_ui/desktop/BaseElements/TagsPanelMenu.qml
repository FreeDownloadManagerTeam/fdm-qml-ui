import QtQuick 2.11
import QtQuick.Controls 2.3
import QtGraphicalEffects 1.0
import org.freedownloadmanager.fdm 1.0
import "../BaseElements"

Popup {
    id: root
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    padding: 12
    width: 250 + 24

    background: Item {
        implicitWidth: contentItem.implicitWidth
        implicitHeight: contentItem.implicitHeight

        Rectangle {
            clip: true
            color: "transparent"
            width: 10
            height: 5
            anchors.left: parent.left
            anchors.leftMargin: 200
            y: -5
            z: 10

            Canvas {
                width: parent.width
                height: parent.height
                onPaint: {
                    var ctx = getContext("2d")
                    ctx.lineWidth = 1
                    ctx.strokeStyle = appWindow.theme.background
                    ctx.fillStyle = appWindow.theme.background
                    ctx.beginPath()
                    ctx.moveTo(width / 2,0)
                    ctx.lineTo(width,height)
                    ctx.lineTo(0,height)
                    ctx.lineTo(width / 2,0)
                    ctx.closePath()
                    ctx.fill()
                    ctx.stroke()
                }
            }
        }

        RectangularGlow {
            anchors.fill: menuBackground
            color: "gray"
            glowRadius: 0
            spread: 0
            cornerRadius: 20
        }

        Rectangle {
            id: menuBackground
            anchors.fill: parent
            color: appWindow.theme.background
            radius: 6
        }
    }

    contentItem: Column {
        id: col
        width: 250
        spacing: 10

        ListView {
            id: tagsList
            width: 250
            height: Math.min(tagsTools.tagsScrollMaxHeight, contentHeight)
            flickableDirection: Flickable.VerticalFlick
            ScrollBar.vertical: ScrollBar{ visible: tagsList.height < tagsList.contentHeight; policy: ScrollBar.AlwaysOn; }
            boundsBehavior: Flickable.StopAtBounds
            clip: true
            spacing: 10

            model: tagsTools.hiddenTags

            delegate: TagButton {
                tag: modelData
            }

            onModelChanged: {
                if (visible) {
                    tagsList.positionViewAtEnd()
                }
            }
        }

        Rectangle {
            visible: tagsTools.hiddenTags.length > 0
            color: appWindow.theme.downloadItemsBorder
            width: 250 + 24
            height: 1
            x: - 12
        }

        AddTag{
            width: 250
            tagPanelMenuHeight: root.height
        }
    }

    Connections {
        target: downloadsViewTools
        onFilterChanged: close()
    }

    Connections {
        target: appWindow
        onActiveChanged: {
            if (!appWindow.active) {
                close()
            }
        }
    }
}
