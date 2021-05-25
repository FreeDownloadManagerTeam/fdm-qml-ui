import QtQuick 2.10
import QtQuick.Controls 2.3
import QtGraphicalEffects 1.0
import org.freedownloadmanager.fdm 1.0
import "../BaseElements"
import "../Dialogs"

Rectangle {
    id: root
    width: btn.implicitWidth
    height: 18
    color: appWindow.theme.filterBtnBackground

    property var tag
    property bool selected: downloadsViewTools.downloadsTagFilter == tag.id
    property bool editMode: tagsTools.tagFormOpened && tagsTools.editedTagId == tag.id

    property var downloadsIds: tag ? App.downloads.tagsHelper2.tagHelper(tag.id).downloadsIds : []

    Row {
        id: btn
        anchors.verticalCenter: parent.verticalCenter
        spacing: 3
        topPadding: 2
        bottomPadding: 2
        leftPadding: 6
        rightPadding: 6

        //color
        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            visible: tag && !tag.readOnly
            width: 9
            height: 8
            color: tag ? tag.color : undefined
//            clip: true

//            Image {
//                visible: colorMouseArea.containsMouse
//                source: appWindow.theme.elementsIcons
//                sourceSize.width: 93
//                sourceSize.height: 456
//                x: 0
//                y: -448
//                layer {
//                    effect: ColorOverlay {
//                        color: "#fff"
//                    }
//                    enabled: true
//                }
//            }

//            MouseArea {
//                id: colorMouseArea
//                anchors.fill: parent
//                hoverEnabled: true
//                onClicked: tagColorDialog.toggle()
//            }
        }

        //tag
        Label {
            id: label
            visible: !editMode
            text: tag.readOnly ? App.loc.tr(tag.name) + App.loc.emptyString : tag.name
            color: selected ? appWindow.theme.filterBtnSelectedText : appWindow.theme.filterBtnText
            padding: 0
            font.pixelSize: 11
            textFormat: Text.PlainText
        }

        TextInput {
            id: textInput
            visible: editMode
            width: contentWidth
            font.pixelSize: 11
            color: appWindow.theme.filterBtnText
            selectByMouse: true
            selectionColor: appWindow.theme.textHighlight
            selectedTextColor: appWindow.theme.foreground
            padding: 0
            focus: true
            onTextEdited: tagsTools.saveEditedTagName(text)
            onAccepted: tagsTools.changeTagName()
            onVisibleChanged: {
                text = tagsTools.editedTagName;
            }
            Keys.onEscapePressed: tagsTools.endTagEditing()
            maximumLength: 20
            Component.onCompleted: {
                text = tagsTools.editedTagName;
            }
        }

        Label {
            text: tag ? '(' + downloadsIds.length + ')' : ''
            visible: tag && downloadsIds.length > 0
            color: appWindow.theme.filterBtnText
            padding: 0
            font.pixelSize: 11
        }
    }

    //underline
    Rectangle {
        visible: root.selected
        color: "#16a4fa"
        width: parent.width
        height: 1
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }

    MouseArea {
        z: -1
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: {
            if (tagsTools.tagFormOpened) {
                return;
            }

            if (mouse.button === Qt.RightButton) {
                if (!tag.readOnly && !editMode) {
                    root.showMenu(mouse);
                }
            } else {
                downloadsViewTools.setDownloadsTagFilter(tag.id)
            }
        }
    }

    TagColorDialog {
        id: tagColorDialog
        x: 18
        y: 20
        tagId: tag.id
        tagColor: tag ? tag.color : undefined
        visible: editMode
        onOpened: textInput.forceActiveFocus();
        onClosed: tagsTools.changeTagName()
//        function toggle() {
//            if (this.opened) {
//                this.close()
//            } else {
//                tagsTools.startTagEditing(tag)
//            }
//        }
    }


    function showMenu(mouse)
    {
        var component = Qt.createComponent("TagMenu.qml");
        var menu = component.createObject(root, {
                                              "tag": tag
                                          });
        menu.x = Math.round(mouse.x);
        menu.y = Math.round(mouse.y);
        menu.currentIndex = -1; // bug under Android workaround
        menu.open();
        menu.aboutToHide.connect(function(){
            menu.destroy();
        });
    }
}
