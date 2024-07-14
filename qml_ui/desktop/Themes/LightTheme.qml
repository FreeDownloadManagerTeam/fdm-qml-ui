import QtQuick 2.12

QtObject {
    readonly property bool isLightTheme: true
    readonly property bool macOS: Qt.platform.os === "osx"

    readonly property color foreground: "#000"//"#646464"
    readonly property color background: "#FFFFFF"
    readonly property color toolbarBackground: "#333c4e"
    readonly property color macToolbarBorder: "#a7a6a6"
    readonly property color macToolbarOverlay: "#b3e3e2e2"
    readonly property color titleBar: "#404040"
    readonly property color statusBar: "#fff"
    readonly property color bottomPanelBar: "#eee"
    readonly property color border: "#DDDDDD"
    readonly property color downloadItemsBorder: "#d7e8ed"
    readonly property color selectedBorder: "#8bd0fb"
    readonly property color selectedBackground: "#66b7e8fc"//"#e6f7fe"
    readonly property color errorMessage: "#bc3737"
    readonly property color successMessage: "#5AC981"
    readonly property color warningMessage: "#ffc000"
    readonly property color tableHeaderItem: "#000"
    readonly property color menuHighlight: "#e6f7fe"
    readonly property color insideMainMenuBackground: "#F9F9F9"
    readonly property color settingsSidebarHeader: "#000"
    readonly property color settingsGroupHeader: "#4e5764"
    readonly property color settingsSubgroupHeader: "#000"
    readonly property color settingsItem: foreground //"#303942"
    readonly property color settingsLine: "#eee"
    readonly property color settingsControlBorder: "#e5e5e5"
    readonly property color dottedBorder: "#17a2f7"
    readonly property color searchFieldBackgound: "#fff"
    readonly property color searchFieldBorder: "#000"
    readonly property color searchFieldBorderMac: "#d1d1d1"
    readonly property color modalDimmingEffect: "#fff"
    readonly property color dialogTitleBackground: "#333c4e"
    readonly property color dialogBackground: "#f5f5f5"
    readonly property color dialogGlow: "#999"
    readonly property color dialogTitle: "#fff"
    readonly property color dialogTitleMac: "#444"
    readonly property color batchDownloadBackground: "#66d7e8ed"
    readonly property color filterBtnBackground: "#ebebeb"
    readonly property color filterBtnText: "#4c4c4c"
    readonly property color filterBtnSelectedText: "#4c4c4c"
    readonly property color filterBtnPlaceholder: placeholder
    readonly property color highMode: "#7ed350"
    readonly property color mediumMode: "#ffc000"
    readonly property color lowMode: "#d54744"
    readonly property color shadow: "#80000000"
    readonly property color placeholder: "#808080"
    readonly property color progressRunningBackground: "#d5e2e8"
    readonly property color progressPausedBackground: "#e5e5e5"
    readonly property color progressRunning: "#17a2f7"
    readonly property color progressPaused: "#acacac"
    readonly property color link: "#18a3f7"
    readonly property string elementsIconsRoot: Qt.resolvedUrl("../../images/desktop/light/elements")
    readonly property string checkboxIconsRoot: Qt.resolvedUrl("../../images/desktop/light/checkbox")
    readonly property string btDldOpenFolder: Qt.resolvedUrl("../../images/desktop/folder_green_t.svg")
    readonly property string headerIcons: Qt.resolvedUrl("../../images/desktop/header_button_win.svg")
    readonly property string headerIconsMac: Qt.resolvedUrl("../../images/desktop/header_button.svg")
    readonly property string infiniteActive: Qt.resolvedUrl("../../images/desktop/line.gif")
    readonly property string infiniteInactive: Qt.resolvedUrl("../../images/desktop/line.png")
    readonly property string infiniteActiveSmall: Qt.resolvedUrl("../../images/desktop/line_small.gif")
    readonly property string infiniteInactiveSmall: Qt.resolvedUrl("../../images/desktop/line_small.png")
    readonly property string progressMapClear: Qt.resolvedUrl("../../images/progress_clear.svg")
    readonly property string progressMapFill: Qt.resolvedUrl("../../images/progress_fill.svg")
    readonly property string progressMapClearBorder: "#d7e8ed"
    readonly property string progressMapFillBorder: "#16a4fa"
    readonly property string progressMapFillBackground: "#8bd0fb"
    readonly property string arrowDownListImg: Qt.resolvedUrl("../../images/desktop/arrow_down_list.svg")
    readonly property string arrowUpListImg: Qt.resolvedUrl("../../images/desktop/arrow_up_list.svg")
    readonly property string arrowDownSbarImg: Qt.resolvedUrl("../../images/desktop/arrow_down_sbar.svg")
    readonly property string arrowUpSbarImg: Qt.resolvedUrl("../../images/desktop/arrow_up_sbar.svg")
    readonly property color generalTabKey: "#737373"
    readonly property color generalTabValue: "#000"
    readonly property color bottomPanelSelectedTabText: "#000"
    readonly property color bottomPanelTabText: "#000"
    readonly property color toolTipBackground: "#f2eeeeee"
    readonly property color toolTipBorder: "#DDDDDD"
    readonly property color toolTipText: "#000"
    readonly property color bannerBackground: "#d7e8ed"
    readonly property color shutdownBannerBackground: "#006ea0"
    readonly property double modeBackgroundOpacity: 0.08
    readonly property double snailBackgroundOpacity: 0.12
    readonly property color filesTreeText: "#000"
    readonly property color filesTreeBackground: "transparent"
    readonly property color emptyListText: "#16a4fa"
    readonly property string batchDownloadIcon: Qt.resolvedUrl("../../images/desktop/batch_download.svg")
    readonly property color textHighlight: "#a6d1fe"
    readonly property string defaultFileIcon: Qt.resolvedUrl("../../images/desktop/file.svg")
    readonly property string defaultFileIconSmall: Qt.resolvedUrl("../../images/desktop/file_small.svg")
    readonly property color snailBtnBackgroundStart: "#ffffff"
    readonly property color snailBtnBackgroundEnd: "#f5f5f5"
    readonly property color snailBtnBackgroundStartChecked: "#e5e5e5"
    readonly property color snailBtnBackgroundEndChecked: "#dbdbdb"
    readonly property color snailBtnBorder: "#b8b8b8"
    readonly property color inactiveControl: "#dddddd"
    readonly property color inactiveSelectedBorder: "#b8b8b8"
    readonly property color textFieldActiveBorderMac: "#cc4c4c4c"
    readonly property int textFieldActiveBorderWidthMac: 2
    readonly property int textFieldBorderRadiusMac: 5

    readonly property color btnBlueText: "#fff"
    readonly property color btnBlueBorder: "#2fa4ed"
    readonly property color btnBlueBackgroud: "#4cb9fc"
    readonly property color btnGreyText: "#000"
    readonly property color btnGreyBorder: "#d4d4d4"
    readonly property color btnGreyBackgroud: "#f0f0f0"

    readonly property string checkmark: Qt.resolvedUrl("../../images/desktop/checkmark.svg")
    readonly property string pause: Qt.resolvedUrl("../../images/desktop/pause.svg")
    readonly property string play: Qt.resolvedUrl("../../images/desktop/play.svg")
    readonly property string linkImg: Qt.resolvedUrl("../../images/desktop/link.svg")
    readonly property string pause2: Qt.resolvedUrl("../../images/desktop/pause2.svg")
    readonly property string play2: Qt.resolvedUrl("../../images/desktop/play2.svg")
    readonly property string restart: Qt.resolvedUrl("../../images/desktop/restart.svg")
    readonly property string alarm: Qt.resolvedUrl("../../images/desktop/alarm.svg")
    readonly property string folder: Qt.resolvedUrl("../../images/desktop/folder.svg")
    readonly property string batch: Qt.resolvedUrl("../../images/desktop/batch.svg")

    readonly property string up: Qt.resolvedUrl("../../images/desktop/up.svg")
    readonly property string up_mac: Qt.resolvedUrl("../../images/desktop/up_mac.svg")
    readonly property string down: Qt.resolvedUrl("../../images/desktop/down.svg")
    readonly property string down_mac: Qt.resolvedUrl("../../images/desktop/down_mac.svg")
    readonly property string up_check: Qt.resolvedUrl("../../images/desktop/up_check.svg")
    readonly property string up_check_mac: Qt.resolvedUrl("../../images/desktop/up_mac_check.svg")
    readonly property string down_check: Qt.resolvedUrl("../../images/desktop/down_check.svg")
    readonly property string down_check_mac: Qt.resolvedUrl("../../images/desktop/down_check_mac.svg")

    readonly property var mainTbImgNonMac: ({
        arrow_left: Qt.resolvedUrl("../../images/desktop/light/main_toolbar/arrow_left.svg"),
        bin: Qt.resolvedUrl("../../images/desktop/light/main_toolbar/delete.svg"),
        bin_check: Qt.resolvedUrl("../../images/desktop/light/main_toolbar/delete_check.svg"),
        down: Qt.resolvedUrl("../../images/desktop/light/main_toolbar/down.svg"),
        down_check: Qt.resolvedUrl("../../images/desktop/light/main_toolbar/down_check.svg"),
        folder: Qt.resolvedUrl("../../images/desktop/light/main_toolbar/folder.svg"),
        folder_check: Qt.resolvedUrl("../../images/desktop/light/main_toolbar/folder_check.svg"),
        menu: Qt.resolvedUrl("../../images/desktop/light/main_toolbar/menu.svg"),
        pause_all: Qt.resolvedUrl("../../images/desktop/light/main_toolbar/pause_all.svg"),
        pause_check: Qt.resolvedUrl("../../images/desktop/light/main_toolbar/pause_check.svg"),
        play_all: Qt.resolvedUrl("../../images/desktop/light/main_toolbar/play_all.svg"),
        play_check: Qt.resolvedUrl("../../images/desktop/light/main_toolbar/play_check.svg"),
        plus: Qt.resolvedUrl("../../images/desktop/light/main_toolbar/plus.svg"),
        reverse: Qt.resolvedUrl("../../images/desktop/light/main_toolbar/reverse.svg"),
        search: Qt.resolvedUrl("../../images/desktop/light/main_toolbar/search.svg"),
        search_2: Qt.resolvedUrl("../../images/desktop/light/main_toolbar/search_2.svg"),
        up: Qt.resolvedUrl("../../images/desktop/light/main_toolbar/up.svg"),
        up_check: Qt.resolvedUrl("../../images/desktop/light/main_toolbar/up_check.svg"),
    })

    readonly property var mainTbImgMac: ({
        arrow_left: Qt.resolvedUrl("../../images/desktop/light/main_toolbar_mac/arrow_left.svg"),
        bin: Qt.resolvedUrl("../../images/desktop/light/main_toolbar_mac/delete.svg"),
        bin_check: Qt.resolvedUrl("../../images/desktop/light/main_toolbar_mac/delete_check.svg"),
        down: Qt.resolvedUrl("../../images/desktop/light/main_toolbar_mac/down.svg"),
        down_check: Qt.resolvedUrl("../../images/desktop/light/main_toolbar_mac/down_check.svg"),
        folder: Qt.resolvedUrl("../../images/desktop/light/main_toolbar_mac/folder.svg"),
        folder_check: Qt.resolvedUrl("../../images/desktop/light/main_toolbar_mac/folder_check.svg"),
        menu: Qt.resolvedUrl("../../images/desktop/light/main_toolbar_mac/menu.svg"),
        pause_all: Qt.resolvedUrl("../../images/desktop/light/main_toolbar_mac/pause_all.svg"),
        pause_check: Qt.resolvedUrl("../../images/desktop/light/main_toolbar_mac/pause_check.svg"),
        play_all: Qt.resolvedUrl("../../images/desktop/light/main_toolbar_mac/play_all.svg"),
        play_check: Qt.resolvedUrl("../../images/desktop/light/main_toolbar_mac/play_check.svg"),
        plus: Qt.resolvedUrl("../../images/desktop/light/main_toolbar_mac/plus.svg"),
        reverse: Qt.resolvedUrl("../../images/desktop/light/main_toolbar_mac/reverse.svg"),
        search: Qt.resolvedUrl("../../images/desktop/light/main_toolbar_mac/search.svg"),
        up: Qt.resolvedUrl("../../images/desktop/light/main_toolbar_mac/up.svg"),
        up_check: Qt.resolvedUrl("../../images/desktop/light/main_toolbar_mac/up_check.svg"),
    })

    readonly property var mainTbImg: macOS ? mainTbImgMac : mainTbImgNonMac

    readonly property url userSortImg: Qt.resolvedUrl("../../images/desktop/light/user_sort.svg")
    readonly property url attentionImg: Qt.resolvedUrl("../../images/common/light/attention.svg")
}
