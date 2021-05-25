import QtQuick 2.10
import QtQuick.Controls 2.3
import QtGraphicalEffects 1.0
import org.freedownloadmanager.fdm 1.0
import "../BaseElements"
import "../Dialogs"

Item {
    id: root
    width: parent.width
    height: 30
    property int tagPanelMenuHeight

    Row {
        id: btn
        anchors.verticalCenter: parent.verticalCenter
        spacing: 10
        topPadding: 2
        bottomPadding: 2
        rightPadding: 6

        //color
        Rectangle {
            id: marker
            anchors.verticalCenter: parent.verticalCenter
            width: 11
            height: 12
            color: tagsTools.newTagColor
            clip: true

            Component.onCompleted: {marker.color = tagsTools.newTagColor}

            Image {
                visible: colorMouseArea.containsMouse
                source: appWindow.theme.elementsIcons
                sourceSize.width: 93
                sourceSize.height: 456
                x: 1
                y: -447
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
            width: 150
            implicitHeight: 20
            font.pixelSize: 13
            color: appWindow.theme.filterBtnText
            maximumLength: 20
            topPadding: 0
            bottomPadding: 0
            leftPadding: 5
            rightPadding: 5
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
        y: height > (appWindow.height - tagPanelMenuHeight - appWindow.mainToolbarHeight - 80) ? -125 : 25
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
