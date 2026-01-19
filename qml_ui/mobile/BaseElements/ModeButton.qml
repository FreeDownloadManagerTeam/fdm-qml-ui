import QtQuick
import QtQuick.Controls
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.dmcoresettings
import org.freedownloadmanager.fdm.tum

RoundButton {
    property int currentTumMode
    property color currentColor
    property string notice: envTools.downloadsAutoStartPreventReasonUiText
    property bool selectAllowed: false
    property bool selected: selectAllowed && currentTumMode == App.settings.tum.currentMode

    text: notice ? notice : tumModeDialog.tumModeStr(currentTumMode)
    padding: 0
    opacity: enabled ? 1 : 0.3
    implicitWidth: Math.max(label.contentWidth + 20, notice ? 190 : 116)
    implicitHeight: 18
    topInset: 0
    rightInset: 0
    bottomInset: 0
    leftInset: 0

    background: Rectangle {        
        border.color: notice ? appWindow.theme.errorMode : currentColor
        border.width: 2
        radius: 9
        color: notice ? appWindow.theme.errorMode : (selected ? "#fff" : currentColor)
    }

    contentItem: Label {
        id: label
        text: parent.text
        font.capitalization: Font.AllUppercase
        font.pointSize: 12
        color: !notice && selected ? currentColor : "#fff"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    function updateState()
    {
        currentColor = tumModeDialog.tumModeBgColor(currentTumMode);
    }

    Component.onCompleted: {
        updateState();
    }

    onCurrentTumModeChanged: {
        updateState();
    }

    Connections {
        target: envTools
        onDownloadsAutoStartPreventReasonUiTextChanged: updateState()
    }

    Connections {
        target: appWindow
        onThemeChanged: updateState();
    }
}
