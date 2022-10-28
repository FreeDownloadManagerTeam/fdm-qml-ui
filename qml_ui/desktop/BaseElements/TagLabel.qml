import QtQuick 2.10
import QtQuick.Controls 2.3
import "../BaseElements"

Rectangle {
    id: root
    width: btn.implicitWidth
    height: 18*appWindow.zoom
    color: appWindow.theme.filterBtnBackground
    property var tag
    property int downloadId

    Row {
        id: btn
        anchors.verticalCenter: parent.verticalCenter
        spacing: 3*appWindow.zoom
        topPadding: 2*appWindow.zoom
        bottomPadding: 2*appWindow.zoom
        leftPadding: 6*appWindow.zoom
        rightPadding: 6*appWindow.zoom
        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            visible: tag ? !tag.readOnly : false
            width: 8*appWindow.zoom
            height: 8*appWindow.zoom
            color: tag ? tag.color : "#000"
        }
        Label {
            text: tag ? tag.name : ""
            color: appWindow.theme.filterBtnText
            padding: 0
            font.pixelSize: 11*appWindow.fontZoom
            textFormat: Text.PlainText
        }
    }

    MouseArea {
        enabled: downloadId
        anchors.fill: parent
        acceptedButtons: Qt.RightButton
        onClicked: function (mouse) {showMenu(mouse);}
    }

    function showMenu(mouse)
    {
        var component = Qt.createComponent("DownloadsTagMenu.qml");
        var menu = component.createObject(btn, {
                                              "tagId": tag.id,
                                              "downloadId": downloadId
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
