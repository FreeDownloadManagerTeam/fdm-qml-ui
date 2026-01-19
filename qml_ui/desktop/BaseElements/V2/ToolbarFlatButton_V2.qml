import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import "../../../common"

Item
{
    id: root

    signal clicked()
    signal checkBoxClicked()

    property bool hasCheckBox: false
    property url iconSource
    property int iconPreferredHeight: 0
    property int iconPreferredWidth: 0
    property bool ignoreIconHeight: true
    property color iconColor: textColor
    property bool applyIconColor: true
    property bool iconRotate: false
    property string title
    property var dropDownMenu: null
    property alias iconMirror: iconImg.mirror

    enum ButtonType {
        NormalButton,
        PrimaryButton,
        DangerButton
    }

    property int buttonType: ToolbarFlatButton_V2.NormalButton

    property int leftPadding: 8*appWindow.zoom
    property int rightPadding: 8*appWindow.zoom
    property int topPadding: 8*appWindow.zoom
    property int bottomPadding: 8*appWindow.zoom

    property color bgColor: bgColorForButtonType(buttonType)
    property color textColor: textColorForButtonType(buttonType)

    property string tooltipText

    property bool useUppercase: buttonType == ToolbarFlatButton_V2.PrimaryButton ||
                                buttonType == ToolbarFlatButton_V2.DangerButton

    property alias checkState: cb.checkState
    property alias tristate: cb.tristate
    property alias checked: cb.checked
    property alias border: myContent.border
    property alias radius: myContent.radius

    function bgColorForButtonType(bt)
    {
        return bt == ToolbarFlatButton_V2.PrimaryButton ? appWindow.theme_v2.primary :
               bt == ToolbarFlatButton_V2.DangerButton ? appWindow.theme_v2.opacityColor(appWindow.theme_v2.danger, 0.2) :
               appWindow.theme_v2.bg300
    }

    function textColorForButtonType(bt)
    {
        return bt == ToolbarFlatButton_V2.PrimaryButton ? appWindow.theme_v2.bg100 :
               bt == ToolbarFlatButton_V2.DangerButton ? appWindow.theme_v2.danger :
               appWindow.theme_v2.bg1000
    }

    implicitHeight: myContent.implicitHeight
    implicitWidth: myContent.implicitWidth

    Rectangle
    {
        id: myContent

        anchors.fill: parent
        radius: 8*appWindow.zoom
        color: bgColor.a ?
                   appWindow.theme_v2.enabledColor(bgColor, enabled) :
                   bgColor

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
                v2EnableRicherBgColor: true
                Layout.alignment: Qt.AlignVCenter
                onClicked: root.checkBoxClicked()
            }

            Item
            {
                visible: iconImg.source.toString()
                implicitHeight: ignoreIconHeight ? Math.min(titleItem.implicitHeight, iconImg.implicitHeight) :
                                iconPreferredHeight ? iconPreferredHeight : iconImg.implicitHeight
                implicitWidth: iconPreferredWidth?  iconPreferredWidth : iconImg.implicitWidth
                WaSvgImage
                {
                    id: iconImg
                    source: root.iconSource
                    zoom: appWindow.zoom
                    layer.effect: MultiEffect {colorization: 1.0; colorizationColor: root.iconColor}
                    layer.enabled: root.applyIconColor
                    opacity: enabled ? 1.0 : appWindow.theme_v2.opacityDisabled
                    anchors.centerIn: parent
                    height: iconPreferredHeight ? iconPreferredHeight : preferredHeight
                    width: iconPreferredWidth ? iconPreferredWidth : preferredWidth

                    // QML bug workaround:
                    // RotationAnimator is not working here due to an unknown reason, so we use Timer instead.
                    Timer {
                        interval: 100
                        onTriggered: {
                            let r = iconImg.rotation += 45;
                            if (r >= 360)
                                r = 0;
                            iconImg.rotation = r;
                        }
                        running: root.iconRotate
                        repeat: true
                        onRunningChanged: {
                            if (!running)
                                iconImg.rotation = 0;
                        }
                    }
                }
            }

            Item
            {
                id: titleItem
                visible: root.title
                implicitHeight: 16*appWindow.fontZoom
                implicitWidth: childrenRect.width
                BaseText_V2
                {
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                    text: root.title
                    color: root.textColor
                    font.weight: root.useUppercase ? appWindow.theme_v2.fontWeight+100 : appWindow.theme_v2.fontWeight
                    font.pixelSize: (root.useUppercase ? 11 : appWindow.theme_v2.fontSize)*appWindow.fontZoom
                    font.capitalization: root.useUppercase ? Font.AllUppercase : Font.MixedCase
                }
            }

            WaSvgImage {
                visible: root.dropDownMenu
                zoom: appWindow.zoom
                source: Qt.resolvedUrl(dropDownMenu && dropDownMenu.opened ? "vertical_collapse_arrow.svg" : "vertical_expand_arrow.svg")
                layer.effect: MultiEffect {colorization: 1.0; colorizationColor: root.textColor}
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
