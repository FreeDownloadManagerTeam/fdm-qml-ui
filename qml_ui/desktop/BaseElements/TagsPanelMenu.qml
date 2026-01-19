import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import org.freedownloadmanager.fdm
import "../BaseElements"

Popup {
    id: root
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    padding: 12*appWindow.zoom
    width: (250 + 24)*appWindow.zoom

    background: Item {
        implicitWidth: contentItem.implicitWidth
        implicitHeight: contentItem.implicitHeight

        Rectangle {
            clip: true
            color: "transparent"
            width: 10*appWindow.zoom
            height: 5*appWindow.zoom
            anchors.left: parent.left
            anchors.leftMargin: 200*appWindow.zoom
            y: -5*appWindow.zoom
            z: 10*appWindow.zoom

            Canvas {
                width: parent.width
                height: parent.height
                onPaint: {
                    var ctx = getContext("2d")
                    ctx.lineWidth = 1*appWindow.zoom
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

        MultiEffect {
            anchors.fill: menuBackground
            source: menuBackground
            shadowEnabled: true
            shadowBlur: 0.5
            shadowColor: "gray"
        }

        Rectangle {
            id: menuBackground
            anchors.fill: parent
            color: appWindow.theme.background
            radius: 6*appWindow.zoom
        }
    }

    contentItem: Column {
        id: col
        width: 250*appWindow.zoom
        spacing: 10*appWindow.zoom

        ListView {
            id: tagsList
            width: 250*appWindow.zoom
            height: Math.min(tagsTools.tagsScrollMaxHeight, contentHeight)
            flickableDirection: Flickable.VerticalFlick
            ScrollBar.vertical: ScrollBar{ visible: tagsList.height < tagsList.contentHeight; policy: ScrollBar.AlwaysOn; }
            boundsBehavior: Flickable.StopAtBounds
            clip: true
            spacing: 10*appWindow.zoom

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
            width: (250 + 24)*appWindow.zoom
            height: 1*appWindow.zoom
            x: - 12*appWindow.zoom
        }

        AddTag{
            width: 250*appWindow.zoom
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
