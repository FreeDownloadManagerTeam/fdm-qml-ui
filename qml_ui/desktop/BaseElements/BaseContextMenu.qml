import QtQuick 2.0
import QtQuick.Controls 2.4
import "../../qt5compat"
import "../../common"

Menu {
    id: root
    margins: 20*appWindow.zoom

    topPadding: 6*appWindow.zoom
    bottomPadding: 6*appWindow.zoom

    implicitWidth: {
        var result = 0;
        for (var i = 0; i < count; ++i) {
            var item = itemAt(i);
            if (item.contentItem) {
                result = Math.max(item.contentItem.implicitWidth, result);
            }
        }
        return result + 40*appWindow.zoom;
    }

    background: Item {
        RectangularGlow {
            anchors.fill: menuBackground
            color: "black"
            glowRadius: 0
            spread: 0
            cornerRadius: 20*appWindow.zoom
        }
        Rectangle {
            id: menuBackground
            anchors.fill: parent
            color: appWindow.theme.background
            radius: 6*appWindow.zoom
        }
    }

    delegate: BaseContextMenuItem {}
}
