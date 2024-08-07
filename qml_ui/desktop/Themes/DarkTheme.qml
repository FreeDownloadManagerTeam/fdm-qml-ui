import QtQuick 2.0

QtObject {
    readonly property bool isLightTheme: false
    readonly property bool macOS: Qt.platform.os === "osx"

    readonly property color foreground: "#d8d8d8"
    readonly property color background: "#28292A"//"#272d32"
    readonly property color toolbarBackground: "#1a2025"
    readonly property color macToolbarBorder: "#000000"
    readonly property color macToolbarOverlay: "#804d4d4d"
    readonly property color titleBar: "#e5e5e4"
    readonly property color statusBar: "#0f1519"
    readonly property color bottomPanelBar: "#0f1519"
    readonly property color border: "#505050"
    readonly property color downloadItemsBorder: "#4D505050"//"#262c30"
    readonly property color selectedBorder: "#007dc2"
    readonly property color selectedBackground: "#384555"//"#353B43"//"#665D84B7"//
    readonly property color errorMessage: "#D9F86061"//bc3737
    readonly property color successMessage: "#58936D"
    readonly property color warningMessage: "#ffc000"
    readonly property color tableHeaderItem: "#8f9295"
    readonly property color menuHighlight: "#3A3939"
    readonly property color insideMainMenuBackground: "#3A3939"
    readonly property color settingsSidebarHeader: "#999"
    readonly property color settingsGroupHeader: "#d8d8d8"
    readonly property color settingsSubgroupHeader: "#999"
    readonly property color settingsItem: foreground //"#dedede"
    readonly property color settingsLine: "#1b2026"
    readonly property color settingsControlBorder: "#51565a"
    readonly property color dottedBorder: "#03596F"
    readonly property color searchFieldBackgound: "#272E32"
    readonly property color searchFieldBorder: "#505050"
    readonly property color searchFieldBorderMac: "#505050"
    readonly property color modalDimmingEffect: "#000"
    readonly property color dialogTitleBackground: "#1C2026"
    readonly property color dialogBackground: "#262C30"
    readonly property color dialogGlow: "#51565a"
    readonly property color dialogTitle: "#fff"
    readonly property color dialogTitleMac: "#fff"
    readonly property color batchDownloadBackground: "#663C4F68"
    readonly property color filterBtnBackground: "#20262a"
    readonly property color filterBtnSelectedText: "#eaeaea"
    readonly property color filterBtnText: "#8f9295"
    readonly property color filterBtnPlaceholder: placeholder
    readonly property color highMode: "#7ed350"
    readonly property color mediumMode: "#ffc000"
    readonly property color lowMode: "#d54744"
    readonly property color shadow: "#80ffffff"
    readonly property color placeholder: "#808080"
    readonly property color progressRunningBackground: "#777"
    readonly property color progressPausedBackground: "#777"
    readonly property color progressRunning: "#007dc2"
    readonly property color progressPaused: "#999"
    readonly property color link: "#007dc2"
    readonly property string elementsIconsRoot: Qt.resolvedUrl("../../images/desktop/dark/elements")
    readonly property string checkboxIconsRoot: Qt.resolvedUrl("../../images/desktop/dark/checkbox")
    readonly property string btDldOpenFolder: Qt.resolvedUrl("../../images/desktop/dark/folder_green_t.svg")
    readonly property string headerIcons: Qt.resolvedUrl("../../images/desktop/dark/header_button_win.svg")
    readonly property string headerIconsMac: Qt.resolvedUrl("../../images/desktop/dark/header_button.svg")
    readonly property string infiniteActive: Qt.resolvedUrl("../../images/desktop/dark/line.gif")
    readonly property string infiniteInactive: Qt.resolvedUrl("../../images/desktop/dark/line.png")
    readonly property string infiniteActiveSmall: Qt.resolvedUrl("../../images/desktop/dark/line_small.gif")
    readonly property string infiniteInactiveSmall: Qt.resolvedUrl("../../images/desktop/dark/line_small.png")
    readonly property string progressMapClear: Qt.resolvedUrl("../../images/desktop/dark/progress_clear.svg")
    readonly property string progressMapFill: Qt.resolvedUrl("../../images/desktop/dark/progress_fill.svg")
    readonly property string progressMapClearBorder: "#595b5c"
    readonly property string progressMapFillBorder: "#3b6a89"
    readonly property string progressMapFillBackground: "#335f7b"
    readonly property string arrowDownListImg: Qt.resolvedUrl("../../images/desktop/dark/arrow_down_list.svg")
    readonly property string arrowUpListImg: Qt.resolvedUrl("../../images/desktop/dark/arrow_up_list.svg")
    readonly property string arrowDownSbarImg: Qt.resolvedUrl("../../images/desktop/dark/arrow_down_sbar.svg")
    readonly property string arrowUpSbarImg: Qt.resolvedUrl("../../images/desktop/dark/arrow_up_sbar.svg")
    readonly property color generalTabKey: "#8f9295"
    readonly property color generalTabValue: "#8f9295"
    readonly property color bottomPanelSelectedTabText: "#d8d8d8"
    readonly property color bottomPanelTabText: "#8f9295"
    readonly property color toolTipBackground: "#f2777777"
    readonly property color toolTipBorder: "#262c30"
    readonly property color toolTipText: "#000"
    readonly property color bannerBackground: "#63848E"
    readonly property color shutdownBannerBackground: "#63848E"
    readonly property double modeBackgroundOpacity: 0.05
    readonly property double snailBackgroundOpacity: 0.04
    readonly property color filesTreeText: "#8f9295"
    readonly property color filesTreeBackground: "#1B2026"
    readonly property color emptyListText: "#d8d8d8"
    readonly property string batchDownloadIcon: Qt.resolvedUrl("../../images/desktop/dark/batch_download.svg")
    readonly property color textHighlight: "#505050"
    readonly property string defaultFileIcon: Qt.resolvedUrl("../../images/desktop/dark/file.svg")
    readonly property string defaultFileIconSmall: Qt.resolvedUrl("../../images/desktop/dark/file_small.svg")
    readonly property color snailBtnBackgroundStart: "#1e2123"
    readonly property color snailBtnBackgroundEnd: "#26282a"
    readonly property color snailBtnBackgroundStartChecked: "#4a5054"
    readonly property color snailBtnBackgroundEndChecked: "#4d5154"
    readonly property color snailBtnBorder: "#707070"
    readonly property color inactiveControl: "#505050"
    readonly property color inactiveSelectedBorder: "#b8b8b8"
    readonly property color textFieldActiveBorderMac: "#64d8d8d8"
    readonly property int textFieldActiveBorderWidthMac: 2
    readonly property int textFieldBorderRadiusMac: 5

    readonly property color btnBlueText: "#fff"
    readonly property color btnBlueBorder: "#0272C1"
    readonly property color btnBlueBackgroud: "#3A92C2"
    readonly property color btnGreyText: "#f0f0f0"
    readonly property color btnGreyBorder: "#28292A"
    readonly property color btnGreyBackgroud: "#5D5F61"

    readonly property string checkmark: Qt.resolvedUrl("../../images/desktop/dark/checkmark.svg")
    readonly property string pause: Qt.resolvedUrl("../../images/desktop/dark/pause.svg")
    readonly property string play: Qt.resolvedUrl("../../images/desktop/dark/play.svg")
    readonly property string linkImg: Qt.resolvedUrl("../../images/desktop/dark/link.svg")
    readonly property string pause2: Qt.resolvedUrl("../../images/desktop/dark/pause2.svg")
    readonly property string play2: Qt.resolvedUrl("../../images/desktop/dark/play2.svg")
    readonly property string restart: Qt.resolvedUrl("../../images/desktop/dark/restart.svg")
    readonly property string alarm: Qt.resolvedUrl("../../images/desktop/dark/alarm.svg")
    readonly property string folder: Qt.resolvedUrl("../../images/desktop/dark/folder.svg")
    readonly property string batch: Qt.resolvedUrl("../../images/desktop/dark/batch.svg")

    readonly property var mainTbImgNonMac: ({
        arrow_left: Qt.resolvedUrl("../../images/desktop/dark/main_toolbar/arrow_left.svg"),
        bin: Qt.resolvedUrl("../../images/desktop/dark/main_toolbar/delete.svg"),
        bin_check: Qt.resolvedUrl("../../images/desktop/dark/main_toolbar/delete_check.svg"),
        down: Qt.resolvedUrl("../../images/desktop/dark/main_toolbar/down.svg"),
        down_check: Qt.resolvedUrl("../../images/desktop/dark/main_toolbar/down_check.svg"),
        folder: Qt.resolvedUrl("../../images/desktop/dark/main_toolbar/folder.svg"),
        folder_check: Qt.resolvedUrl("../../images/desktop/dark/main_toolbar/folder_check.svg"),
        menu: Qt.resolvedUrl("../../images/desktop/dark/main_toolbar/menu.svg"),
        pause_all: Qt.resolvedUrl("../../images/desktop/dark/main_toolbar/pause_all.svg"),
        pause_check: Qt.resolvedUrl("../../images/desktop/dark/main_toolbar/pause_check.svg"),
        play_all: Qt.resolvedUrl("../../images/desktop/dark/main_toolbar/play_all.svg"),
        play_check: Qt.resolvedUrl("../../images/desktop/dark/main_toolbar/play_check.svg"),
        plus: Qt.resolvedUrl("../../images/desktop/dark/main_toolbar/plus.svg"),
        reverse: Qt.resolvedUrl("../../images/desktop/dark/main_toolbar/reverse.svg"),
        search: Qt.resolvedUrl("../../images/desktop/dark/main_toolbar/search.svg"),
        search_2: Qt.resolvedUrl("../../images/desktop/dark/main_toolbar/search_2.svg"),
        up: Qt.resolvedUrl("../../images/desktop/dark/main_toolbar/up.svg"),
        up_check: Qt.resolvedUrl("../../images/desktop/dark/main_toolbar/up_check.svg"),
    })

    readonly property var mainTbImgMac: ({
        arrow_left: Qt.resolvedUrl("../../images/desktop/dark/main_toolbar_mac/arrow_left.svg"),
        bin: Qt.resolvedUrl("../../images/desktop/dark/main_toolbar_mac/delete.svg"),
        bin_check: Qt.resolvedUrl("../../images/desktop/dark/main_toolbar_mac/delete_check.svg"),
        down: Qt.resolvedUrl("../../images/desktop/dark/main_toolbar_mac/down.svg"),
        down_check: Qt.resolvedUrl("../../images/desktop/dark/main_toolbar_mac/down_check.svg"),
        folder: Qt.resolvedUrl("../../images/desktop/dark/main_toolbar_mac/folder.svg"),
        folder_check: Qt.resolvedUrl("../../images/desktop/dark/main_toolbar_mac/folder_check.svg"),
        menu: Qt.resolvedUrl("../../images/desktop/dark/main_toolbar_mac/menu.svg"),
        pause_all: Qt.resolvedUrl("../../images/desktop/dark/main_toolbar_mac/pause_all.svg"),
        pause_check: Qt.resolvedUrl("../../images/desktop/dark/main_toolbar_mac/pause_check.svg"),
        play_all: Qt.resolvedUrl("../../images/desktop/dark/main_toolbar_mac/play_all.svg"),
        play_check: Qt.resolvedUrl("../../images/desktop/dark/main_toolbar_mac/play_check.svg"),
        plus: Qt.resolvedUrl("../../images/desktop/dark/main_toolbar_mac/plus.svg"),
        reverse: Qt.resolvedUrl("../../images/desktop/dark/main_toolbar_mac/reverse.svg"),
        search: Qt.resolvedUrl("../../images/desktop/dark/main_toolbar_mac/search.svg"),
        up: Qt.resolvedUrl("../../images/desktop/dark/main_toolbar_mac/up.svg"),
        up_check: Qt.resolvedUrl("../../images/desktop/dark/main_toolbar_mac/up_check.svg"),
    })

    readonly property var mainTbImg: macOS ? mainTbImgMac : mainTbImgNonMac

    readonly property string userSortImg: Qt.resolvedUrl("../../images/desktop/dark/user_sort.svg")
    readonly property url attentionImg: Qt.resolvedUrl("../../images/common/light/attention.svg")
}
