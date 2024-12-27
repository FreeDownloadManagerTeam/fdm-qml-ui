import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
//MultiEffect can be used instead of ColorOverlay; however it's not supported by Qt 6.4.3 which is used at the moment
//Warning: MultiEffect requires SVG image to be in white color OR "brightness: 1.0" should be applied too
// for its colorization effect to work properly.
// https://forum.qt.io/topic/144070/qt6-color-svg-using-multieffect
//import QtQuick.Effects
import "../../../common"

Item
{
    id: root

    signal clicked()
    signal checkBoxClicked()

    property bool hasCheckBox: false
    property url iconSource
    property color iconColor: textColor
    property string title
    property var dropDownMenu: null

    property bool primaryButton: false

    property int leftPadding: 8*appWindow.zoom
    property int rightPadding: 8*appWindow.zoom
    property int topPadding: 8*appWindow.zoom
    property int bottomPadding: 8*appWindow.zoom

    property bool transparentBackground: false

    property string tooltipText

    readonly property color textColor: primaryButton ? appWindow.theme_v2.bg100 : appWindow.theme_v2.bg1000

    property alias checkState: cb.checkState
    property alias tristate: cb.tristate
    property alias checked: cb.checked
    property alias border: myContent.border
    property alias radius: myContent.radius

    implicitHeight: myContent.implicitHeight
    implicitWidth: myContent.implicitWidth

    Rectangle
    {
        id: myContent

        anchors.fill: parent
        radius: 8*appWindow.zoom
        color: transparentBackground? "transparent" :
                                      appWindow.theme_v2.enabledColor(primaryButton ? appWindow.theme_v2.primary : appWindow.theme_v2.bg300,
                                                                      enabled)

        implicitHeight: myContent2.implicitHeight + root.topPadding + root.bottomPadding
        implicitWidth: myContent2.implicitWidth + root.leftPadding + root.rightPadding

        MouseAreaWithHand_V2
        {
            anchors.fill: parent
            hoverEnabled: tooltipText
            onClicked: {
                if (root.dropDownMenu)
                    root.showMenuIfRequired()
                else
                    root.clicked()
            }

            BaseToolTip_V2 {
                text: tooltipText
                visible: text ? parent.containsMouse && (!root.dropDownMenu || !root.dropDownMenu.opened) : false
            }
        }

        RowLayout
        {
            id: myContent2

            anchors.fill: parent
            anchors.leftMargin: root.leftPadding
            anchors.rightMargin: root.rightPadding
            anchors.topMargin: root.topPadding
            anchors.bottomMargin: root.bottomPadding

            spacing: 4*appWindow.zoom

            CheckBox_V2
            {
                id: cb
                visible: hasCheckBox
                Layout.alignment: Qt.AlignVCenter
                onClicked: root.checkBoxClicked()
            }

            WaSvgImage
            {
                source: root.iconSource
                zoom: appWindow.zoom
                visible: source.toString()
                layer.effect: ColorOverlay { color: root.iconColor }
                //layer.effect: MultiEffect {colorization: 1.0; colorizationColor: root.iconColor}
                layer.enabled: true
            }

            Item
            {
                visible: root.title
                implicitHeight: 16*appWindow.fontZoom
                implicitWidth: childrenRect.width
                BaseText_V2
                {
                    opacity: 1.0
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                    text: root.title
                    color: root.textColor
                    font.weight: root.primaryButton ? 600 : 500
                    font.pixelSize: (root.primaryButton ? 11 : appWindow.theme_v2.fontSize)*appWindow.fontZoom
                    font.capitalization: root.primaryButton ? Font.AllUppercase : Font.MixedCase
                }
            }

            WaSvgImage {
                visible: root.dropDownMenu
                zoom: appWindow.zoom
                source: Qt.resolvedUrl(dropDownMenu && dropDownMenu.opened ? "vertical_collapse_arrow.svg" : "vertical_expand_arrow.svg")
                layer.effect: ColorOverlay { color: root.textColor }
                layer.enabled: true
                Layout.alignment: Qt.AlignVCenter
            }
        }
    }

    QtObject {
        id: d
        property double menuCloseTime: 0
    }

    function showMenuIfRequired()
    {
        if (new Date().getTime() - d.menuCloseTime > 300) {
            let pt = root.mapToGlobal(0, root.height + 8*appWindow.zoom);
            let pt2 = root.dropDownMenu.parent.mapFromGlobal(pt.x, pt.y);
            root.dropDownMenu.x = pt2.x;
            root.dropDownMenu.y = pt2.y;
            root.dropDownMenu.open();
        }
    }

    Connections {
        enabled: root.dropDownMenu
        target: root.dropDownMenu
        function onClosed() {
            d.menuCloseTime = new Date().getTime()
        }
    }
}
