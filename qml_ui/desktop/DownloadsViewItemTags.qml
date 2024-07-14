/* Displays "status" column content */

import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "../common"
import "../common/Tools"
import org.freedownloadmanager.fdm 1.0
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
        }
    }
}
