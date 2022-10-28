import QtQuick 2.6
import QtQuick.Controls 2.1

Button {

    id: customBtn

    property bool blueBtn: false
    property bool smallBtn: false
    property int radius: (appWindow.macVersion ? 5 : 0)*appWindow.zoom
    property bool alternateBtnPressed: false

    property color gradientTop
    property color gradientBottom
    property color borderColor
    property color textColor

    property color primaryBtnColor: blueBtn ? appWindow.theme.btnBlueBackgroud : appWindow.theme.btnGreyBackgroud
    property color secondaryBtnColor: blueBtn ? appWindow.theme.btnGreyBackgroud : appWindow.theme.btnBlueBackgroud
    property color primaryTextColor: blueBtn ? appWindow.theme.btnBlueText : appWindow.theme.btnGreyText
    property color secondaryTextColor: blueBtn ? appWindow.theme.btnGreyText : appWindow.theme.btnBlueText
    property color primaryBorderColor: blueBtn ? appWindow.theme.btnBlueBorder : appWindow.theme.btnGreyBorder
    property color secondaryBorderColor: blueBtn ? appWindow.theme.btnGreyBorder : appWindow.theme.btnBlueBorder

    onAlternateBtnPressedChanged: {
        state = enabled ? (appWindow.macVersion && alternateBtnPressed ? "alternateBtnPressed" : "active") : "disabled"
    }

    onIsHoveredChanged: {
        customBtn.state = !customBtn.enabled ? "disabled" : (isHovered && !appWindow.macVersion ? "hovered" : "active");
    }

    onIsPressedChanged: {
        customBtn.state = !customBtn.enabled ? "disabled" : (isPressed ? "pressed" : "active");
    }

    leftPadding: 10*appWindow.zoom
    rightPadding: 10*appWindow.zoom
    opacity: enabled ? 1 : 0.7

    property bool isHovered: false
    property bool isPressed: false

    state: "active"

    states: [
        State {
            name: "active"
            PropertyChanges {
                target: customBtn
                borderColor: primaryBorderColor
                gradientTop: primaryBtnColor
                gradientBottom: Qt.darker(gradientTop, 1.1)
                textColor: primaryTextColor
            }
        },
        State {
            name: "hovered"
            PropertyChanges {
                target: customBtn
                borderColor: primaryBorderColor
                gradientTop: Qt.lighter(primaryBtnColor, 1.2)
                gradientBottom: Qt.darker(gradientTop, 1.1)
                textColor: primaryTextColor
            }
        },
        State {
            name: "disabled"
            PropertyChanges {
                target: customBtn
                borderColor: primaryBorderColor
                gradientTop: Qt.lighter(primaryBtnColor, 1.2)
                gradientBottom: Qt.darker(gradientTop, 1.1)
                textColor: primaryTextColor
            }
        },
        State {
            name: "pressed"
            PropertyChanges {
                target: customBtn
                borderColor: appWindow.macVersion && !blueBtn ? secondaryBorderColor : primaryBorderColor
                gradientTop: appWindow.theme === "lightTheme" ? Qt.darker(appWindow.macVersion && !blueBtn  ? secondaryBtnColor : primaryBtnColor, 1.1) : Qt.lighter(appWindow.macVersion && !blueBtn  ? secondaryBtnColor : primaryBtnColor, 1.1)
                gradientBottom: Qt.darker(gradientTop, 1.1)
                textColor: appWindow.macVersion && !blueBtn  ? secondaryTextColor : primaryTextColor
            }
        },
        State {
            name: "alternateBtnPressed"
            PropertyChanges {
                target: customBtn
                borderColor: secondaryBorderColor
                gradientTop: secondaryBtnColor
                gradientBottom: Qt.darker(gradientTop, 1.1)
                textColor: secondaryTextColor
            }
        }
    ]

    background: Rectangle {
        implicitHeight: (appWindow.macVersion ? 22 : 30)*appWindow.zoom
        implicitWidth: customBtn.smallBtn ? (labelElement.implicitWidth + 20*appWindow.zoom) : Math.max(labelElement.implicitWidth + 20*appWindow.zoom, 90*appWindow.zoom)

        border.color: customBtn.borderColor
        border.width: 1*appWindow.zoom
        radius: customBtn.radius

        gradient: Gradient {
            GradientStop { position: 0.0; color: customBtn.gradientTop }
            GradientStop { position: 1.0; color: customBtn.gradientBottom }
        }
    }

    contentItem: BaseLabel {
        id: labelElement
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: parent.text
        color: customBtn.textColor
    }

    MouseArea {
        anchors.fill: parent
        onClicked: parent.clicked()
        enabled: customBtn.enabled
        cursorShape: customBtn.enabled ? Qt.PointingHandCursor: Qt.ArrowCursor
        hoverEnabled: true
        onEntered: customBtn.isHovered = true
        onExited: customBtn.isHovered = false
        onPressed: customBtn.isPressed = true
        onReleased: customBtn.isPressed = false
    }
}
