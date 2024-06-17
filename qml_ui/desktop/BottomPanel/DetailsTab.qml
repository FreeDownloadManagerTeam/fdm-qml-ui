import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import "../BaseElements"
import org.freedownloadmanager.fdm 1.0

Item {

    anchors.fill: parent
    anchors.margins: 20*appWindow.zoom

    Loader {
        active: downloadsItemTools.moduleUid === "downloadsbt"
        source: "../../bt/desktop/BtDetailsTab.qml"
        anchors.fill: parent
        visible: active
    }
}
