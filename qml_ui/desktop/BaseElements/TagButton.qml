import QtQuick
import QtQuick.Controls
import org.freedownloadmanager.fdm
import "../BaseElements"
import "../Dialogs"

Rectangle {
    id: root
    width: btn.implicitWidth
    height: 18*appWindow.fontZoom
    color: appWindow.theme.filterBtnBackground

    property var tag
    property bool selected: downloadsViewTools.downloadsTagFilter == tag.id
    property bool editMode: tagsTools.tagFormOpened && tagsTools.editedTagId == tag.id

    property var downloadsIds: tag ? App.downloads.tagsHelper2.tagHelper(tag.id).downloadsIds : []

    Row {
        id: btn
        anchors.verticalCenter: parent.verticalCenter
        spacing: 3*appWindow.zoom
        topPadding: 2*appWindow.zoom
        bottomPadding: 2*appWindow.zoom
        leftPadding: 6*appWindow.zoom
        rightPadding: 6*appWindow.zoom

        //color
        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            visible: tag && !tag.readOnly
            width: 9*appWindow.zoom
            height: 8*appWindow.zoom
            color: tag ? tag.color : undefined
        }

        //tag
        Label {
            id: label
            visible: !editMode
            text: tag.readOnly ? App.loc.tr(tag.name) + App.loc.emptyString : tag.name
            color: selected ? appWindow.theme.filterBtnSelectedText : appWindow.theme.filterBtnText
            padding: 0
            font.pixelSize: 11*appWindow.fontZoom
            textFormat: Text.PlainText
        }

        TextInput {
            id: textInput
            visible: editMode
            width: contentWidth
            font.pixelSize: 11*appWindow.fontZoom
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
            font.pixelSize: 11*appWindow.fontZoom
        }
    }

    //underline
    Rectangle {
        visible: root.selected
        color: "#16a4fa"
        width: parent.width
        height: 1*appWindow.zoom
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }

    MouseArea {
        z: -1
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: function (mouse) {
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
        x: 18*appWindow.zoom
        y: 20*appWindow.zoom
        tagId: tag.id
        tagColor: tag ? tag.color : undefined
        visible: editMode
        onOpened: textInput.forceActiveFocus();
        onClosed: tagsTools.changeTagName()
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
