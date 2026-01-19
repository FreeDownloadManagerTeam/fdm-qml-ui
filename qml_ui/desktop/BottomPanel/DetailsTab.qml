import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../BaseElements"
import org.freedownloadmanager.fdm

Item {

    anchors.fill: parent
    anchors.margins: appWindow.uiver === 1 ? 20*appWindow.zoom : 0

    Loader {
        active: downloadsItemTools.moduleUid === "downloadsbt"
        source: "../../bt/desktop/BtDetailsTab.qml"
        anchors.fill: parent
        visible: active
    }
}
