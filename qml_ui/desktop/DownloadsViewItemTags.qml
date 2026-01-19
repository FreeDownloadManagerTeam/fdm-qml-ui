/* Displays "status" column content */

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import "../common"
import "../common/Tools"
import org.freedownloadmanager.fdm
import "./BaseElements"

Row {
    spacing: 3

    Repeater {
        model: downloadsItemTools.topTags

        delegate: Rectangle {
            width: 8*appWindow.zoom
            height: 8*appWindow.zoom
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

    Item {
        visible: downloadsItemTools.moreTags
        width: 8*appWindow.zoom
        height: 8*appWindow.zoom
        WaSvgImage {
            source: appWindow.theme.elementsIconsRoot + "/triangle_down3.svg"
            zoom: appWindow.zoom
            anchors.centerIn: parent
            layer {
                effect: MultiEffect {
                    colorization: 1.0
                    colorizationColor: "#868486"
                }
                enabled: true
            }
        }
    }
}
