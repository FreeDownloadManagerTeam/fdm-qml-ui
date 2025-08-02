import QtQuick

QtObject
{
    property bool isLightTheme: false

    readonly property color dark100: "#141415"
    readonly property color dark200: "#1C1D1F"
    readonly property color dark300: "#27282A"
    readonly property color dark400: "#383A3D"
    readonly property color dark500: "#54575C"
    readonly property color dark600: "#7A7E85"
    readonly property color dark700: "#9D9FA3"
    readonly property color dark800: "#B0B3B8"
    readonly property color dark900: "#E1E4EB"
    readonly property color dark1000: "#F4F5F5"
    readonly property color darkPrimary: "#73CEFC"
    readonly property color darkPrimaryOpacity: "#51849E"
    readonly property color darkSecondary: "#4EC284"
    readonly property color darkAmber: "#C29B4E"
    readonly property color darkDanger: "#C24E5D"

    readonly property color light100: "#171A1F"
    readonly property color light200: "#1F2329"
    readonly property color light300: "#272C33"
    readonly property color light400: "#424B57"
    readonly property color light500: "#5A6677"
    readonly property color light600: "#929DAD"
    readonly property color light700: "#CED6E0"
    readonly property color light800: "#E6EAEF"
    readonly property color light900: "#ECEFF3"
    readonly property color light1000: "#FDFDFD"
    readonly property color lightPrimary: "#3F80E0"
    readonly property color lightPrimaryOpacity: "#92B7ED"
    readonly property color lightSecondary: "#288F58"
    readonly property color lightAmber: "#8F6D28"
    readonly property color lightDanger: "#8F2836"


    readonly property color bg100: isLightTheme ? light1000 : dark100
    readonly property color bg200: isLightTheme ? light900 : dark200
    readonly property color bg300: isLightTheme ? light900 : dark300 // dark300 --> light900 instead of light800
    readonly property color bg400: isLightTheme ? light700 : dark400
    readonly property color bg500: isLightTheme ? light600 : dark500
    readonly property color bg600: isLightTheme ? light500 : dark600
    readonly property color bg700: isLightTheme ? light400 : dark700
    readonly property color bg800: isLightTheme ? light300 : dark800
    readonly property color bg900: isLightTheme ? light200 : dark900
    readonly property color bg1000: isLightTheme ? light100 : dark1000
    readonly property color primary: isLightTheme ? lightPrimary : darkPrimary
    readonly property color primaryOpacity: isLightTheme ? lightPrimaryOpacity : darkPrimaryOpacity
    readonly property color secondary: isLightTheme ? lightSecondary : darkSecondary
    readonly property color amber: isLightTheme ? lightAmber : darkAmber
    readonly property color danger: isLightTheme ? lightDanger : darkDanger

    readonly property string fontFamily: "IBM Plex Sans"
    readonly property int fontSize: 13
    readonly property int tooltipFontSize: 12

    readonly property color textColor: bg1000
    readonly property color bgColor: bg100
    readonly property color outlineBorderColor: bg400
    readonly property color selectedTextColor: isLightTheme ? light1000 : dark1000
    readonly property color selectedTextBgColor: isLightTheme ? light500 : dark500
    readonly property color placeholderTextColor: bg700
    readonly property color editTextBorderColor: outlineBorderColor
    readonly property color hightlightBgColor: bg400
    readonly property color popupBgColor: bg300
    readonly property color tooltipBgColor: isLightTheme ? light500 : dark400
    readonly property color tooltipTextColor: isLightTheme ? light900 : light1000
    readonly property color dialogBgColor: bg200
    readonly property color dialogBorderColor: outlineBorderColor
    readonly property color glowColor: dark300
    readonly property bool useGlow: isLightTheme
    readonly property color settingsSubgroupHeader: bg800
    readonly property color dialogSpecialAreaColor: isLightTheme ? light1000 : dark300

    readonly property real opacityDisabled: 0.4

    readonly property int mainWindowTopMargin: 9
    readonly property int mainWindowBottomMargin: 4
    readonly property int mainWindowLeftMargin: 16
    readonly property int mainWindowRightMargin: 16

    readonly property int tagSquareSize: 12

    readonly property color lightSnailOnGradientStart: "#C29B4E"
    readonly property color lightSnailOnGradientEnd: "#F9D876"
    readonly property color darkSnailOnGradientStart: "#7C5300"
    readonly property color darkSnailOnGradientEnd: "#C29B4E"
    readonly property color snailOnGradientStart: isLightTheme ? lightSnailOnGradientStart : darkSnailOnGradientStart
    readonly property color snailOnGradientEnd: isLightTheme ? lightSnailOnGradientEnd : darkSnailOnGradientEnd
    readonly property color snailOnTextColor: light1000
    readonly property var snailOnGradient: Gradient {
        orientation: Gradient.Horizontal
        GradientStop { position: 0.0; color: snailOnGradientStart }
        GradientStop { position: 1.0; color: snailOnGradientEnd }
    }

    readonly property color lightHighlightedDownloadGradientStart: "#99DAE0E7"
    readonly property color lightHighlightedDownloadGradientEnd: "#00DAE0E7"
    readonly property color darkHighlightedDownloadGradientStart: Qt.lighter(dark200, 1.2)
    readonly property color darkHighlightedDownloadGradientEnd: Qt.rgba(darkHighlightedDownloadGradientStart.r, darkHighlightedDownloadGradientStart.g, darkHighlightedDownloadGradientStart.b, 0.5)
    readonly property color highlightedDownloadGradientStart: isLightTheme ? lightHighlightedDownloadGradientStart : darkHighlightedDownloadGradientStart
    readonly property color highlightedDownloadGradientEnd: isLightTheme ? lightHighlightedDownloadGradientEnd : lightHighlightedDownloadGradientEnd

    function opacityColor(clr, opacity)
    {
        return Qt.rgba(clr.r, clr.g, clr.b, opacity);
    }

    function enabledColor(clr, isEnabled)
    {
        return isEnabled ?
                    clr :
                    opacityColor(clr, opacityDisabled);
    }
}
