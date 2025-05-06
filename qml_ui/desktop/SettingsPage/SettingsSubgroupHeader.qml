import QtQuick 2.10
import "../BaseElements"

BaseLabel {
    bottomPadding: 3*appWindow.zoom
    color: appWindow.uiver === 1 ? appWindow.theme.settingsSubgroupHeader : appWindow.theme_v2.settingsSubgroupHeader
}
