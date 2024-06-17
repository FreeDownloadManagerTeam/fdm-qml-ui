import QtQuick

Item {

    anchors.fill: parent

    Loader {
        active: downloadsItemTools.moduleUid === "downloadsbt"
        source: "../../bt/mobile/BtDetailsTab.qml"
        anchors.fill: parent
        anchors.margins: 14
        visible: active
    }
}
