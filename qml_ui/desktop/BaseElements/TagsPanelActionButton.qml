import QtQuick
import QtQuick.Controls
import "../BaseElements"
import "../../common"

Rectangle {
    id: root
    width: 18*appWindow.fontZoom
    height: 18*appWindow.fontZoom
    color: appWindow.theme.filterBtnBackground

    property bool plusBtn: !(tagsTools.hiddenTags.length > 0)
    property double timeMenuClosed: 0

    Rectangle {
        width: 18*Math.min(appWindow.fontZoom, appWindow.zoom)
        height: 18*Math.min(appWindow.fontZoom, appWindow.zoom)
        color: appWindow.theme.filterBtnBackground
        anchors.centerIn: parent

        WaSvgImage {
            source: appWindow.theme.elementsIconsRoot+(plusBtn ? "/plus.svg" : "/dots.svg")
            zoom: Math.min(appWindow.fontZoom, appWindow.zoom)
            anchors.centerIn: parent
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: function (mouse) {
            if (Date.now() - root.timeMenuClosed > 300)
                root.showMenu(mouse);
        }
    }

    function showMenu(mouse)
    {
        var component = Qt.createComponent("TagsPanelMenu.qml");
        var menu = component.createObject(root, {});
        menu.x = -196*appWindow.fontZoom;
        menu.y = 25*appWindow.fontZoom;
        menu.open();
        menu.aboutToHide.connect(function(){
            root.timeMenuClosed = Date.now();
            menu.destroy();
        });
    }
}
