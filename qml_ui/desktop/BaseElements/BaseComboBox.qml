import QtQuick 2.12
import QtQuick.Controls 2.12
import "../BaseElements"
import "../../common"

ComboBox {
    id: root

    property bool settingsStyle: false

    property int fontSize: defaultLabel.font.pixelSize
    property int comboMinimumWidth: 0
    property int comboMaximumWidth: 0
    property int popupVisibleRowsCount: 0
    property int delegateMinimumHeight: 0

    model: []
    textRole: "text"

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

    implicitHeight: fontMetrics.height + 10*appWindow.zoom

    implicitWidth: {
        let h = 0;
        for (let i = 0; i < model.length; ++i)
            h = Math.max(h, fontMetrics.advanceWidth(textRole ? model[i][textRole] : model[i]));
        let result = Math.max(comboMinimumWidth, h + 44*appWindow.zoom + root.fontSize*0);
        return comboMaximumWidth ? Math.min(comboMaximumWidth, result) : result;
    }

    delegate: Rectangle {
        property bool hover: false
        color: hover ?
                   (appWindow.uiver === 1 ? appWindow.theme.menuHighlight : appWindow.theme_v2.hightlightBgColor) :
                   "transparent"
        height: Math.max(delegateMinimumHeight, delegateLabel.implicitHeight)
        width: root.width

        BaseLabel {
            id: delegateLabel
            anchors.left: parent.left
            leftPadding: qtbug.leftPadding(6*appWindow.zoom, 0)
            rightPadding: qtbug.rightPadding(6*appWindow.zoom, 0)
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
        color: root.settingsStyle ?
                   "transparent" :
                   (appWindow.uiver === 1 ? appWindow.theme.background : appWindow.theme_v2.bgColor)
        radius: root.settingsStyle ? 5*appWindow.zoom : 0
        border.color: appWindow.uiver === 1 ?
                          (root.settingsStyle ? appWindow.theme.settingsControlBorder : appWindow.theme.border) :
                          appWindow.theme_v2.editTextBorderColor
        border.width: 1*appWindow.zoom
    }

    contentItem: BaseLabel {
        text: root.displayText
        anchors.left: parent.left
        leftPadding: qtbug.leftPadding(6*appWindow.zoom, 0)
        rightPadding: qtbug.rightPadding(6*appWindow.zoom, 0)
        anchors.verticalCenter: parent.verticalCenter
        font.pixelSize: root.fontSize
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter
        opacity: enabled ? 1 : 0.5
    }

    indicator: Rectangle {
        z: 1
        opacity: enabled ? 1 : 0.5
        x: LayoutMirroring.enabled ? 0 : root.width - width
        y: root.topPadding + (root.availableHeight - height) / 2
        width: height - 1*appWindow.zoom
        height: root.height
        color: "transparent"
        border.width: root.settingsStyle ? 0 : 1*appWindow.zoom
        border.color: appWindow.uiver === 1 ?
                          (root.settingsStyle ? appWindow.theme.settingsControlBorder : appWindow.theme.border) :
                          appWindow.theme_v2.editTextBorderColor
        WaSvgImage {
            source: appWindow.theme.elementsIconsRoot + "/triangle_down3.svg"
            zoom: appWindow.zoom
            anchors.centerIn: parent
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
        y: root.height-1
        width: root.width
        implicitHeight: Math.max(delegateMinimumHeight, fontMetrics.height) * root.model.length + 2*appWindow.zoom
        height: root.popupVisibleRowsCount ?
                    Math.min(Math.max(delegateMinimumHeight, fontMetrics.height) * root.popupVisibleRowsCount + 2*appWindow.zoom, implicitHeight) :
                    implicitHeight
        padding: 1*appWindow.zoom

        background: Rectangle {
            color: appWindow.uiver === 1 ?
                       appWindow.theme.background :
                       appWindow.theme_v2.popupBgColor
            border.color: appWindow.uiver === 1 ?
                              (root.settingsStyle ? appWindow.theme.settingsControlBorder : appWindow.theme.border) :
                              appWindow.theme_v2.editTextBorderColor
            border.width: 1*appWindow.zoom
        }

        contentItem: ListView {
            clip: true
            anchors.fill: parent
            model: root.model
            currentIndex: root.highlightedIndex
            delegate: root.delegate
            flickableDirection: Flickable.VerticalFlick
            boundsBehavior: Flickable.StopAtBounds
            ScrollBar.vertical: ScrollBar{ visible: parent.height < root.popup.implicitHeight; policy: ScrollBar.AlwaysOn; }
        }
    }
}
