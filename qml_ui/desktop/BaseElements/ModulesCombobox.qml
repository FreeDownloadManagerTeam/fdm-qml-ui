import QtQuick 2.0
import QtQuick.Controls 2.3
import org.freedownloadmanager.fdm 1.0
import "../../common"

Item {

    ComboBox {
        id: combo

        visible: downloadTools.modulesUrl && downloadTools.modulesUrl == downloadTools.urlText && count > 1

        rightPadding: 5*appWindow.zoom
        leftPadding: 5*appWindow.zoom
        width: parent.width
        height: parent.height

        property int visibleRowsCount: 2

        model: ListModel{}

        textRole: "label"

        delegate: Rectangle {
            property bool hover: false
            color: hover ? appWindow.theme.menuHighlight : "transparent"
            height: 30*appWindow.zoom
            width: parent.width
            BaseLabel {
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
                    downloadTools.selectModule(id)
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
            y: combo.height - 1*appWindow.zoom
            width: combo.width
            height: (Math.min(combo.visibleRowsCount, combo.count) * 30 + 2)*appWindow.zoom
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
    }

    Connections {
        target: downloadTools
        onModulesChanged: initialization(modulesUids, urlDescriptions)
    }

    function initialization(modulesUids, urlDescriptions) {
        combo.model.clear();
        var index = 0;
        if (modulesUids.length > 1) {
            for (var i = 0; i < modulesUids.length; i++) {
                if (downloadTools.modulesSelectedUid == modulesUids[i]) {
                    index = i;
                }
                combo.model.insert(i, {'id': modulesUids[i], 'label': App.loc.tr(urlDescriptions[i])});
            }
            combo.currentIndex = index;
        }
    }
}
