import QtQuick 2.0

Item {
    id: root
    anchors {
        fill: parent
        leftMargin: 5
        topMargin: 4
        bottomMargin: 5
        rightMargin: 5
    }

    Rectangle {
        id: progressWraper
        color: "transparent"
        anchors.fill: parent
        clip: true
    }

    Component.onCompleted: loadPoints()
    onVisibleChanged: loadPoints()
    Connections {
        target: downloadsItemTools
        onItemChanged: loadPoints()
    }

    property var currentPointsComponent
    function loadPoints()
    {
        if (currentPointsComponent && currentPointsComponent.destroy) {
            currentPointsComponent.destroy();
        }

        if (!root.visible) {
            return;
        }

        if (!downloadsItemTools.item) {
            return;
        }

        var component = Qt.createComponent("../../common/ProgressMap.qml");
        currentPointsComponent = component.createObject(progressWraper, {
                                              "downloadId": downloadsItemTools.itemId,
                                              "zoom": appWindow.zoom
                                          });
    }

}
