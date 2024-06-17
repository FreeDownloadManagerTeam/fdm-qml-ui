import QtQuick 2.10
import QtQuick.Controls 2.3
import "../../qt5compat"
import org.freedownloadmanager.fdm 1.0
import "../BaseElements"
import "../Dialogs"
import "../../common"

Item {
    id: root
    width: parent.width
    height: 30*appWindow.zoom
    property int tagPanelMenuHeight

    Row {
        id: btn
        anchors.verticalCenter: parent.verticalCenter
        spacing: 10*appWindow.zoom
        topPadding: 2*appWindow.zoom
        bottomPadding: 2*appWindow.zoom
        rightPadding: 6*appWindow.zoom

        //color
        Rectangle {
            id: marker
            anchors.verticalCenter: parent.verticalCenter
            width: 11*appWindow.zoom
            height: 12*appWindow.zoom
            color: tagsTools.newTagColor
            clip: true

            Component.onCompleted: {marker.color = tagsTools.newTagColor}

            WaSvgImage {
                visible: colorMouseArea.containsMouse
                source: appWindow.theme.elementsIcons
                zoom: appWindow.zoom
                x: 1*appWindow.zoom
                y: -447*appWindow.zoom
                layer {
                    effect: ColorOverlay {
                        color: "#fff"
                    }
                    enabled: true
                }
            }

            MouseArea {
                id: colorMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: tagPalette.toggle()
            }
        }

        BaseTextField {
            id: textInput
            placeholderText: qsTr("Add tag") + App.loc.emptyString
            placeholderTextColor: appWindow.theme.filterBtnPlaceholder
            width: 150*appWindow.zoom
            implicitHeight: 20*appWindow.zoom
            font.pixelSize: 13*appWindow.fontZoom
            color: appWindow.theme.filterBtnText
            maximumLength: 20
            topPadding: 0
            bottomPadding: 0
            leftPadding: 5*appWindow.zoom
            rightPadding: 5*appWindow.zoom
            focus: true
            onAccepted: {
                tagsTools.addTag(text)
                text = "";
            }
            onVisibleChanged: {
                if (visible && !tagsTools.hiddenTags.length) {
                    textInput.forceActiveFocus();
                }
            }
        }
    }

    TagColorDialog {
        id: tagPalette
        visible: false
        tagColor: tagsTools.newTagColor
        y: (height > (appWindow.height - tagPanelMenuHeight - appWindow.mainToolbarHeight - 80*appWindow.zoom) ? -125 : 25)*appWindow.zoom
        onOpened: textInput.forceActiveFocus();

        function toggle() {
            if (this.opened) {
                this.close()
            } else {
                this.open()
            }
        }
    }

    Connections {
        target: tagsTools
        onNewTagColorChanged: {marker.color = tagsTools.newTagColor}
    }
}
