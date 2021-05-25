import QtQuick 2.10
import QtQuick.Controls 2.3
import "../BaseElements"

Rectangle {
    id: root
    width: btn.implicitWidth
    height: 18
    color: appWindow.theme.filterBtnBackground
    property var tag
    property int downloadId

    Row {
        id: btn
        anchors.verticalCenter: parent.verticalCenter
        spacing: 3
        topPadding: 2
        bottomPadding: 2
        leftPadding: 6
        rightPadding: 6
        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            visible: tag ? !tag.readOnly : false
            width: 8
            height: 8
            color: tag ? tag.color : "#000"
        }
        Label {
            text: tag ? tag.name : ""
            color: appWindow.theme.filterBtnText
            padding: 0
            font.pixelSize: 11
            textFormat: Text.PlainText
        }
    }

    MouseArea {
        enabled: downloadId
        anchors.fill: parent
        acceptedButtons: Qt.RightButton
        onClicked: showMenu(mouse);
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
