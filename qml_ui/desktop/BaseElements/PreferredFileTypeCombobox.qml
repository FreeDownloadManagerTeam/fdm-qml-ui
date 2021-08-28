import QtQuick 2.0
import QtQuick.Controls 2.3
import org.freedownloadmanager.fdm 1.0

ComboBox {
    id: combo

    visible: count > 1

    rightPadding: 5
    leftPadding: 5
    width: parent.width
    height: parent.height

    property int visibleRowsCount: 2
    property var labels: ['', qsTr('Audio') + App.loc.emptyString, qsTr('Video') + App.loc.emptyString]

    model: ListModel{}

    textRole: "label"

    delegate: Rectangle {
        property bool hover: false
        color: hover ? appWindow.theme.menuHighlight : "transparent"
        height: 30
        width: parent.width
        BaseLabel {
            leftPadding: 6
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
                downloadTools.setPreferredFileType(id)
            }
        }
    }

    background: Rectangle {
        color: appWindow.theme.background
        border.color: appWindow.theme.border
        border.width: 1
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
        width: height - 1
        height: combo.height
        color: "transparent"
        border.width: 1
        border.color: appWindow.theme.border
        Rectangle {
            width: 9
            height: 8
            color: "transparent"
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            clip: true
            Image {
                source: appWindow.theme.elementsIcons
                sourceSize.width: 93
                sourceSize.height: 456
                x: 0
                y: -448
            }
        }
    }

    popup: Popup {
        y: combo.height - 1
        width: combo.width
        height: Math.min(combo.visibleRowsCount, combo.count) * 30 + 2
        padding: 1

        background: Rectangle {
            color: appWindow.theme.background
            border.color: appWindow.theme.border
            border.width: 1
        }

        contentItem: Item {
            ListView {
                clip: true
//                flickableDirection: Flickable.VerticalFlick
//                ScrollBar.vertical: ScrollBar{ visible: downloadTools.versionCount > visibleRowsCount; policy: ScrollBar.AlwaysOn; }
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
