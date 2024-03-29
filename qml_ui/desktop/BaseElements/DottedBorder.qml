import QtQuick 2.0

Item {
    id: component

    property int borderLine: 24*appWindow.zoom
    property int borderSpace: 10*appWindow.zoom
    property int borderItem: borderLine + borderSpace
    property string color: appWindow.theme.dottedBorder

    PathView {
        anchors.fill: component
        model: component.width > 0 ? component.width/component.borderItem : 0
        path: Path {

            startX: component.borderLine/2
            startY: 1*appWindow.zoom

            PathLine {
                x: component.width + component.borderLine - 2*appWindow.zoom
                y: 1*appWindow.zoom
            }
        }
        delegate: Rectangle {
            width: component.borderLine
            height: 1*appWindow.zoom
            color: component.color
        }
    }

    PathView {
        anchors.fill: component
        model: component.height > 0 ? component.height/component.borderItem : 0
        path: Path {

            startX: 1*appWindow.zoom
            startY: component.borderLine/2

            PathLine {
                x: 1*appWindow.zoom
                y: component.height + component.borderLine + 2
            }
        }
        delegate: Rectangle {
            width: 1*appWindow.zoom
            height: component.borderLine
            color: component.color
        }
    }

    PathView {
        anchors.fill: component
        model: component.width > 0 ? component.width/component.borderItem : 0
        path: Path {

            startX: component.borderLine/2
            startY: component.height

            PathLine {
                x: component.width + component.borderLine - 2
                y: component.height
            }
        }
        delegate: Rectangle {
            width: component.borderLine
            height: 1*appWindow.zoom
            color: component.color
        }
    }

    PathView {
        anchors.fill: component
        model: component.height > 0 ? component.height/component.borderItem : 0
        path: Path {

            startX: component.width
            startY: component.borderLine/2

            PathLine {
                x: component.width
                y: component.height + component.borderLine + 2*appWindow.zoom
            }
        }
        delegate: Rectangle {
            width: 1*appWindow.zoom
            height: component.borderLine
            color: component.color
        }
    }

}
