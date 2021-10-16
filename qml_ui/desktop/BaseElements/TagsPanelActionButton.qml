import QtQuick 2.10
import QtQuick.Controls 2.3
import "../BaseElements"

Rectangle {
    id: root
    width: 18
    height: 18
    color: appWindow.theme.filterBtnBackground
    clip: true

    property bool plusBtn: !(tagsTools.hiddenTags.length > 0)
    property double timeMenuClosed: 0

    Image {
        source: appWindow.theme.elementsIcons
        sourceSize.width: 93
        sourceSize.height: 456
        x: plusBtn ? 3 : -57
        y: plusBtn ? 3 : 8
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
        menu.x = -196;
        menu.y = 25;
        menu.open();
        menu.aboutToHide.connect(function(){
            root.timeMenuClosed = Date.now();
            menu.destroy();
        });
    }
}
