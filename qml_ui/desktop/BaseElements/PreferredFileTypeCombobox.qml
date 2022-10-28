import QtQuick 2.0
import QtQuick.Controls 2.3
import org.freedownloadmanager.fdm 1.0
import "../../common"

ComboBox {
    id: combo

    visible: count > 1

    rightPadding: 5*appWindow.zoom
    leftPadding: 5*appWindow.zoom
    width: parent.width
    height: parent.height

    property int visibleRowsCount: 2
    property var labels: ['', qsTr('Audio') + App.loc.emptyString, qsTr('Video') + App.loc.emptyString]

    model: ListModel{}

    textRole: "label"

    delegate: Rectangle {
        property bool hover: false
        color: hover ? appWindow.theme.menuHighlight : "transparent"
        implicitHeight: Math.max(l1.implicitHeight, 30*appWindow.zoom)
        width: Math.max(l1.implicitWidth, parent.width)
        BaseLabel {
            id: l1
            leftPadding: 6*appWindow.zoom
            anchors.verticalCenter: parent.verticalCenter
            text: label
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: parent.hover = true
            onExited: parent.hover = false
            onClicked: {
                combo.currentIndex = index
                combo.popup.close();
                downloadTools.setPreferredFileType(id, true)
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
            text: combo.currentText
        }
    }

    indicator: Rectangle {
        x: combo.width - width
        y: combo.topPadding + (combo.availableHeight - height) / 2
        width: height - 1*appWindow.zoom
        height: combo.height
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
        y: combo.height - 1
        width: combo.width
        height: Math.min(combo.visibleRowsCount, combo.count) * 30*appWindow.zoom + 2*appWindow.zoom
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
                model: combo.model
                currentIndex: combo.highlightedIndex
                delegate: combo.delegate
            }
        }
    }

    Connections {
        target: downloadTools
        onOriginFilesTypesChanged: initialization()
    }

    function initialization() {
        combo.model.clear();
        var needIndex = 0;
        if (downloadTools.originFilesTypes.length > 1) {
            for (var i = 0; i < downloadTools.originFilesTypes.length; i++) {
                combo.model.insert(i, {'id': downloadTools.originFilesTypes[i], 'label': combo.labels[downloadTools.originFilesTypes[i]]});
                if (downloadTools.preferredFileType == downloadTools.originFilesTypes[i])
                    needIndex = i;
            }
            combo.currentIndex = needIndex;
        }
    }
}
