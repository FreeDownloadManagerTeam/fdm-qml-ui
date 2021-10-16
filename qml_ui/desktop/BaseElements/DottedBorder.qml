import QtQuick 2.0

Item {
    id: component

    property int borderLine: 24
    property int borderSpace: 10
    property int borderItem: borderLine + borderSpace
    property string color: appWindow.theme.dottedBorder

    PathView {
        anchors.fill: component
        model: component.width > 0 ? component.width/component.borderItem : 0
        path: Path {

            startX: component.borderLine/2
            startY: 1

            PathLine {
                x: component.width + component.borderLine - 2
                y: 1
            }
        }
        delegate: Rectangle {
            width: component.borderLine
            height: 1
            color: component.color
        }
    }

    PathView {
        anchors.fill: component
        model: component.height > 0 ? component.height/component.borderItem : 0
        path: Path {

            startX: 1
            startY: component.borderLine/2

            PathLine {
                x: 1
                y: component.height + component.borderLine + 2
            }
        }
        delegate: Rectangle {
            width: 1
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
            height: 1
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
                y: component.height + component.borderLine + 2
            }
        }
        delegate: Rectangle {
            width: 1
            height: component.borderLine
            color: component.color
        }
    }

}
