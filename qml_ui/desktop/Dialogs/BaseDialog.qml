import QtQuick 2.0
import QtQuick.Controls 2.3
import "../../qt5compat"

Dialog {
    id: baseDialog
    modal: false
    dim: false
    closePolicy: Popup.NoAutoClose

    property bool standalone: false

    x: Math.round((parent.width - width) / 2)
    y: Math.round((parent.height - height) / 2)

    background: Item {
        anchors.fill: baseDialog.contentItem

        RectangularGlow {
            visible: appWindow.uiver === 1
            anchors.fill: parent
            color: appWindow.theme.dialogGlow
            glowRadius: 4*appWindow.zoom
            spread: 0
            cornerRadius: 4*appWindow.zoom
        }

        Rectangle {
            anchors.fill: parent
            color: appWindow.uiver === 1 ?
                                   appWindow.theme.dialogBackground :
                                   appWindow.theme_v2.dialogBgColor
            radius: (appWindow.uiver === 1 || standalone) ? 0 : 12*appWindow.zoom
            border.color: (appWindow.uiver === 1 || standalone) ?
                              "transparent" :
                              appWindow.theme_v2.dialogBorderColor
            border.width: (appWindow.uiver === 1 || standalone) ? 0 : 1*appWindow.zoom
        }
    }

    Component.onCompleted:
    {
        if (standalone)
        {
            x = 0;
            y = 0;
            padding = 0;
            topMargin = 0;
            leftMargin = 0;
            rightMargin = 0;
            bottomMargin = 0;
        }
    }
}
