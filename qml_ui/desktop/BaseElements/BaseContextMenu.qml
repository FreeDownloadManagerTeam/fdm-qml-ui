import QtQuick 2.0
import QtQuick.Controls 2.4
import "../../qt5compat"
import "../../common"

Menu {
    id: root
    margins: appWindow.uiver === 1 ? 20*appWindow.zoom : 0

    topPadding: (appWindow.uiver === 1 ? 6 : 4)*appWindow.zoom
    bottomPadding: (appWindow.uiver === 1 ? 6 : 4)*appWindow.zoom
    padding: (appWindow.uiver === 1 ? 0 : 4)*appWindow.zoom

    implicitWidth: {
        if (uiver === 1)
        {
            var result = 0;
            for (var i = 0; i < count; ++i) {
                var item = itemAt(i);
                if (item.contentItem) {
                    result = Math.max(item.contentItem.implicitWidth, result);
                }
            }
            return result + 40*appWindow.zoom;
        }
        else
        {
            let w = 0;
            let p = 0;
            for (let i = 0; i < count; ++i) {
                let item = itemAt(i);
                if (item)
                {
                    w = Math.max(item.implicitWidth, w);
                    if (item.padding)
                        p = Math.max(item.padding, p);
                }
            }
            return w + p*2;
        }
    }

    background: Item {
        RectangularGlow {
            visible: appWindow.uiver === 1 || appWindow.theme_v2.useGlow
            anchors.fill: menuBackground
            color: appWindow.uiver === 1 ?
                       "black" :
                       appWindow.theme_v2.glowColor
            glowRadius: 0
            spread: 0
            cornerRadius: appWindow.uiver === 1 ?
                              20*appWindow.zoom :
                              menuBackground.radius
        }
        Rectangle {
            id: menuBackground
            anchors.fill: parent
            color: appWindow.uiver === 1 ?
                       appWindow.theme.background :
                       appWindow.theme_v2.popupBgColor
            radius: (appWindow.uiver === 1 ? 6 : 8)*appWindow.zoom
        }
    }

    delegate: BaseContextMenuItem {}
}
