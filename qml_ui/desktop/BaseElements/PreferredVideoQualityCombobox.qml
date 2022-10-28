import QtQuick 2.0
import QtQuick.Controls 2.3
import org.freedownloadmanager.fdm 1.0
import "../../common"

ComboBox {
    id: root

    rightPadding: 5*appWindow.zoom
    leftPadding: 5*appWindow.zoom

    property int visibleRowsCount: 4

    model: []

    textRole: "label"

    onVisibleChanged: {
        if (visible) {
            updateState();
        }
    }

    Component.onCompleted: root.reloadCombo()

    Connections {
        target: App.loc
        onCurrentTranslationChanged: root.reloadCombo()
    }

    function reloadCombo() {
        root.model = [
                    {label: "240p" + " (" + qsTr("Lowest") + ")", value: "240"},
                    {label: "480p", value: "480"},
                    {label: "720p", value: "720"},
                    {label: "1080p", value: "1080"},
                    {label: "4K (2160p)", value: "2160"},
                    {label: "5K (2880p)", value: "2880"},
                    {label: "8K (4320p)" + " (" + qsTr("Highest") + ")", value: "4320"}];
    }

    function updateState() {
        var ph = downloadTools.preferredVideoHeight || downloadTools.defaultPreferredVideoHeight;
        var needIndex = -1;
        var nearestIndex = -1;
        var nearestDistance = -1;
        for (var i = 0; i < root.count; i ++) {
            if (ph == model[i].value) {
                needIndex = i;
                break;
            }
            else
            {
                var distance = Math.abs(ph - model[i].value);
                if (nearestIndex == -1 ||
                        nearestDistance > distance)
                {
                    nearestIndex = i;
                    nearestDistance = distance;
                }
            }
        }
        if (needIndex == -1)
            needIndex = nearestIndex != -1 ? nearestIndex : 0;
        currentIndex = needIndex;
    }

    delegate: Rectangle {
        property bool hover: false
        color: hover ? appWindow.theme.menuHighlight : "transparent"
        implicitHeight: Math.max(30*appWindow.zoom, l1.implicitHeight)
        implicitWidth: Math.max(parent.width, l1.implicitWidth)
        BaseLabel {
            id: l1
            leftPadding: 6*appWindow.zoom
            anchors.verticalCenter: parent.verticalCenter
            text: modelData.label
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: parent.hover = true
            onExited: parent.hover = false
            onClicked: {
                root.currentIndex = index
                root.popup.close();
                downloadTools.setPreferredVideoHeight(modelData.value, true);
            }
        }
    }

    background: Rectangle {
        color: appWindow.theme.background
        border.color: appWindow.theme.border
        border.width: 1*appWindow.zoom
    }

    contentItem: Rectangle {
        color: "transparent"
        BaseLabel {
            anchors.verticalCenter: parent.verticalCenter
            text: root.currentText
        }
    }

    indicator: Rectangle {
        x: root.width - width
        y: root.topPadding + (root.availableHeight - height) / 2
        width: height - 1*appWindow.zoom
        height: root.height
        color: "transparent"
        border.width: 1*appWindow.zoom
        border.color: appWindow.theme.border
        Rectangle {
            width: 9*appWindow.zoom
            height: 8*appWindow.zoom
            color: "transparent"
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            clip: true
            WaSvgImage {
                source: appWindow.theme.elementsIcons
                zoom: appWindow.zoom
                x: 0
                y: -448*zoom
            }
        }
    }

    popup: Popup {
        y: root.height - 1
        width: root.width
        height: visibleRowsCount * 30*appWindow.zoom + 2*appWindow.zoom
        padding: 1*appWindow.zoom

        background: Rectangle {
            color: appWindow.theme.background
            border.color: appWindow.theme.border
            border.width: 1*appWindow.zoom
        }

        contentItem: Item {
            ListView {
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                anchors.fill: parent
                model: root.model
                currentIndex: root.highlightedIndex
                delegate: root.delegate
            }
        }
    }
}
