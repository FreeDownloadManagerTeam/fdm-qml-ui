/* Displays "status" column content */

import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "../common/Tools"
import org.freedownloadmanager.fdm 1.0
import "./BaseElements"

Row {
    spacing: 3

    Repeater {
        model: downloadsItemTools.topTags

        delegate: Rectangle {
            width: 8
            height: 8
            color: modelData.color

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                propagateComposedEvents: true
                onPressed: function (mouse) {mouse.accepted = false;}

                BaseToolTip {
                    text: modelData.name
                    visible: parent.containsMouse
                }
            }
        }
    }

    Rectangle {
        visible: downloadsItemTools.moreTags
        width: 8
        height: 8
        color: "transparent"
        clip: true
        Image {
            source: appWindow.theme.elementsIcons
            sourceSize.width: 93
            sourceSize.height: 456
            x: 0
            y: -448
        }
    }
}
