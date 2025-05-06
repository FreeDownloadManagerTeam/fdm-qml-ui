import QtQuick 2.12
import QtQuick.Controls 2.12
import "../BaseElements"
import "../../common"
import "../../qt5compat"
import "V2"

ComboBox {
    id: root

    property bool settingsStyle: false

    property int fontSize: defaultLabel.font.pixelSize
    property int comboMinimumWidth: 0
    property int comboMaximumWidth: 0
    property int popupVisibleRowsCount: 0
    property int delegateMinimumHeight: 0
    property int delegateMinimumWidth: 0
    property int delegateTopPadding: appWindow.uiver === 1 ? 0 : 8*appWindow.zoom
    property int delegateBottomPadding: delegateTopPadding

    model: []
    textRole: "text"

    leftPadding: (appWindow.uiver === 1 ? 6 : 12)*appWindow.zoom
    rightPadding: (appWindow.uiver === 1 ? 6 : 8)*appWindow.zoom
    topPadding: (appWindow.uiver === 1 ? 5 : 8)*appWindow.zoom
    bottomPadding: (appWindow.uiver === 1 ? 5 : 8)*appWindow.zoom

    readonly property int popupListScrollBarWidth: popupListScrollBar.visible ? popupListScrollBar.width : 0
    // WARNING: a delegate must have "anchors.left: parent.left"
    //  for the recommendedDelegateWidth to work properly for RTL languages
    readonly property int recommendedDelegateWidth: popupList.width - popupListScrollBarWidth
    readonly property int recommendedDelegateHeight: Math.max(delegateMinimumHeight,
                                                              fontMetrics.height + delegateTopPadding + delegateBottomPadding)

    BaseLabel {
        id: defaultLabel
        visible: false
    }

    BaseLabel {
        id: l
        visible: false
        font.pixelSize: root.fontSize
    }

    readonly property var fontMetrics: FontMetrics {
        font: l.font
    }

    implicitHeight: fontMetrics.height + topPadding + bottomPadding

    implicitWidth: {
        let h = 0;
        for (let i = 0; i < model.length; ++i)
            h = Math.max(h, fontMetrics.advanceWidth(textRole ? model[i][textRole] : model[i]));
        let result = Math.max(comboMinimumWidth, h + 44*appWindow.zoom + fontMetrics.font.pixelSize*0);
        result += root.leftPadding + root.rightPadding
        return comboMaximumWidth ? Math.min(comboMaximumWidth, result) : result;
    }

    delegate: Item {
        property bool hover: false

        anchors.left: parent ? parent.left : undefined
        height: recommendedDelegateHeight
        width: recommendedDelegateWidth

        Rectangle {
            anchors.fill: parent
            anchors.margins: appWindow.uiver === 1 ? 0 : 2*appWindow.zoom
            color: parent.hover ?
                       (appWindow.uiver === 1 ? appWindow.theme.menuHighlight : appWindow.theme_v2.hightlightBgColor) :
                       "transparent"
            radius: parent.hover ?
                        (appWindow.uiver === 1 ? 0 : 4*appWindow.zoom) :
                        0
        }

        BaseLabel {
            id: delegateLabel
            anchors.left: parent.left
            leftPadding: root.leftPadding
            rightPadding: root.rightPadding
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: root.fontSize
            text: textRole ? modelData[textRole] : modelData
            font.weight: index === currentIndex ? Font.DemiBold : Font.Normal
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: parent.hover = true
            onExited: parent.hover = false
            onClicked: {
                root.popup.close();
                if (root.editable)
                    root.editText = root.textRole ? modelData[root.textRole] : modelData;
                root.activated(root.currentIndex = index);
            }
        }
    }

    background: Rectangle {
        color: appWindow.uiver === 1 ?
                   (root.settingsStyle ? "transparent" : appWindow.theme.background) :
                   appWindow.theme_v2.bgColor
        radius: appWindow.uiver === 1 ?
                    (root.settingsStyle ? 5*appWindow.zoom : 0) :
                    8*appWindow.zoom
        border.color: appWindow.uiver === 1 ?
                          (root.settingsStyle ? appWindow.theme.settingsControlBorder : appWindow.theme.border) :
                          (root.activeFocus || root.contentItem.activeFocus ? appWindow.theme_v2.primary : appWindow.theme_v2.editTextBorderColor)
        border.width: 1*appWindow.zoom
    }

    contentItem: BaseLabel {
        text: root.displayText
        leftPadding: qtbug.leftPadding(0, root.indicator.width + 4*appWindow.zoom)
        rightPadding: qtbug.rightPadding(0, root.indicator.width + 4*appWindow.zoom)
        anchors.verticalCenter: parent.verticalCenter
        font.pixelSize: root.fontSize
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter
        opacity: enabled ? 1 : 0.5
    }

    indicator: Rectangle {
        z: 1
        opacity: enabled ? 1 : (appWindow.uiver === 1 ? 0.5 : appWindow.theme_v2.opacityDisabled)
        readonly property bool ignorePadding: appWindow.uiver === 1 && !root.settingsStyle
        x: LayoutMirroring.enabled ? (ignorePadding ? 0 : root.leftPadding) :
                                     root.width - width - (ignorePadding ? 0 : root.rightPadding)
        y: root.topPadding + (root.availableHeight - height) / 2
        width: height - 1*appWindow.zoom
        height: root.height
        color: "transparent"
        border.width: appWindow.uiver === 1 ?
                          (root.settingsStyle ? 0 : 1*appWindow.zoom) :
                          0
        border.color: appWindow.uiver === 1 ?
                          (root.settingsStyle ? appWindow.theme.settingsControlBorder : appWindow.theme.border) :
                          "transparent"
        WaSvgImage {
            visible: appWindow.uiver === 1
            source: visible ? appWindow.theme.elementsIconsRoot + "/triangle_down3.svg" : ""
            zoom: appWindow.zoom
            anchors.centerIn: parent
        }
        SvgImage_V2 {
            visible: appWindow.uiver !== 1
            source: visible ? Qt.resolvedUrl("V2/expand_more.svg") : ""
            anchors.centerIn: parent
            rotation: popup.opened ? 180 : 0
        }

        MouseArea {
            enabled: root.editable
            propagateComposedEvents: false
            anchors.fill: parent
            cursorShape: Qt.ArrowCursor
            onClicked: {
                if (root.popup.opened)
                    root.popup.close();
                else
                    root.popup.open();
            }
        }
    }

    popup: Popup {
        y: root.height + ((appWindow.uiver === 1 ? 0 : 4) - 1)*appWindow.zoom
        width: Math.max(root.width, delegateMinimumWidth + popupListScrollBarWidth)
        implicitHeight: recommendedDelegateHeight*root.model.length + topPadding + bottomPadding
        height: root.popupVisibleRowsCount ?
                    Math.min(recommendedDelegateHeight*root.popupVisibleRowsCount + 2*appWindow.zoom, implicitHeight) :
                    implicitHeight
        padding: (appWindow.uiver === 1 ? 1 : 2)*appWindow.zoom

        background: Item {
            RectangularGlow {
                visible: appWindow.uiver !== 1 && appWindow.theme_v2.useGlow
                anchors.fill: popupBackground
                color: appWindow.theme_v2.glowColor
                glowRadius: 0
                spread: 0
                cornerRadius: popupBackground.radius
            }
            Rectangle {
                id: popupBackground
                anchors.fill: parent
                color: appWindow.uiver === 1 ?
                           appWindow.theme.background :
                           appWindow.theme_v2.bgColor
                border.color: appWindow.uiver === 1 ?
                                  (root.settingsStyle ? appWindow.theme.settingsControlBorder : appWindow.theme.border) :
                                  appWindow.theme_v2.editTextBorderColor
                border.width: 1*appWindow.zoom
                radius: appWindow.uiver === 1 ? 0 : 8*appWindow.zoom
            }
        }

        contentItem: ListView {
            id: popupList
            clip: true
            model: root.model
            currentIndex: root.highlightedIndex
            delegate: root.delegate
            flickableDirection: Flickable.VerticalFlick
            boundsBehavior: Flickable.StopAtBounds
            ScrollBar.vertical: BaseScrollBar_V2 {
                id: popupListScrollBar
                policy: popupList.contentHeight > popupList.height ?
                            ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
            }
        }
    }
}
