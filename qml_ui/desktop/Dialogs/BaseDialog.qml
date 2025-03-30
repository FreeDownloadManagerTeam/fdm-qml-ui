import QtQuick 2.0
import QtQuick.Controls 2.3
import "../../qt5compat"

Dialog {
    id: root

    modal: false
    dim: false
    closePolicy: Popup.NoAutoClose

    property bool standalone: false

    property alias showTitleIcon: title.showTitleIcon
    property alias showCloseButton: title.showCloseButton
    property alias titleIconUrl: title.titleIconUrl

    signal closeClick()

    x: Math.round((parent.width - width) / 2)
    y: Math.round((parent.height - height) / 2)

    leftPadding: (appWindow.uiver === 1 ? 10 : 16)*appWindow.zoom
    rightPadding: leftPadding
    topPadding: (appWindow.uiver === 1 ? 10 : 8)*appWindow.zoom
    bottomPadding: (appWindow.uiver === 1 ? 10 : 12)*appWindow.zoom

    header: DialogTitle {
        id: title
        visible: text
        text: root.title
        leftPadding: root.leftPadding
        rightPadding: root.rightPadding
        topPadding: appWindow.uiver === 1 ? 0 : 12*appWindow.zoom
        bottomPadding: appWindow.uiver === 1 ? 0 : 8*appWindow.zoom
        onCloseClick: root.closeClick()
    }

    background: Item {
        RectangularGlow {
            visible: appWindow.uiver === 1 || appWindow.theme_v2.useGlow
            anchors.fill: parent
            color: appWindow.uiver === 1 ?
                       appWindow.theme.dialogGlow :
                       appWindow.theme_v2.glowColor
            glowRadius: appWindow.uiver === 1 ?
                            4*appWindow.zoom :
                            0
            spread: 0
            cornerRadius: appWindow.uiver === 1 ?
                              4*appWindow.zoom :
                              bgr.radius
        }

        Rectangle {
            id: bgr
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
            topMargin = 0;
            leftMargin = 0;
            rightMargin = 0;
            bottomMargin = 0;
        }
    }
}
