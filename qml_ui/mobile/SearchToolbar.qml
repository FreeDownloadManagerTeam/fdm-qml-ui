import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.4
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.dmcoresettings 1.0
import org.freedownloadmanager.fdm.tum 1.0
import "BaseElements"

Rectangle {
    id: root

    signal switchMainView()
    signal switchSearchView()

    onSwitchSearchView: searchText.forceActiveFocus()

    visible: false

    width: parent.width
    height: 63
    color: appWindow.theme.primary
    Material.foreground: appWindow.theme.toolbarTextColor

    ToolbarButton {
        id: backbtn
        anchors.left: parent.left
        anchors.leftMargin: 11
        anchors.verticalCenter: parent.verticalCenter

        icon.source: LayoutMirroring.enabled ?
                         Qt.resolvedUrl("../images/mobile/arrow_forward.svg") :
                         Qt.resolvedUrl("../images/mobile/arrow_back.svg")

        onClicked: {
            searchText.text = "";
            downloadsViewTools.resetDownloadsTitleFilter();
            switchMainView();
        }
    }

    TextField
    {
        id: searchText
        width: parent.width - backbtn.width - 40
        placeholderText: qsTr("Search") + App.loc.emptyString
        placeholderTextColor: appWindow.theme.searchPlaceholder
        anchors.left: backbtn.right
        anchors.right: clearbtn.left
        anchors.verticalCenter: parent.verticalCenter
        selectByMouse: true
        inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhSensitiveData
        EnterKey.type: Qt.EnterKeySearch
        Material.accent: appWindow.theme.toolbarTextColor
        color: appWindow.theme.toolbarTextColor
        opacity: enabled ? 1 : 0.3
        horizontalAlignment: Text.AlignLeft
        onDisplayTextChanged: downloadsViewTools.setDownloadsTitleFilter(displayText)
    }

    ToolbarBackButton {
        id: clearbtn
        visible: searchText.displayText.length > 0
        anchors.right: parent.right
        anchors.rightMargin: 11
        anchors.verticalCenter: parent.verticalCenter
        onClicked:  {
            searchText.text = '';
            searchText.forceActiveFocus();
        }
    }

    Connections {
        target: downloadsViewTools
        onDownloadsTitleFilterChanged: {
            searchText.text = downloadsViewTools.downloadsTitleFilter;
        }
    }
}
