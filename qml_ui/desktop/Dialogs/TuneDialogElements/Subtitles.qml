import QtQuick 2.0
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0
import "../../../qt5compat"
import "../../BaseElements"

RowLayout {
    visible: downloadTools.subtitlesEnabled
    Layout.preferredHeight: visible ? 40 : 0

    BaseCheckBox {
        id: subsCheckbox
        text: qsTr("Download subtitles") + App.loc.emptyString
        checked: downloadTools.needDownloadSubtitles
        checkBoxStyle: "gray"
        onCheckedChanged: {
            downloadTools.needDownloadSubtitles = checked;
            downloadTools.needDownloadSubtitlesChangedByUser = true;
        }
    }

    Rectangle {
        id: editListBtn
        width: 16
        height: 16
        color: "transparent"

        Image {
            source: Qt.resolvedUrl("../../../images/desktop/edit_list.png")
            sourceSize.width: 16
            sourceSize.height: 16
            layer {
                effect: ColorOverlay {
                    color: appWindow.theme.foreground
                }
                enabled: true
            }
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onClicked: function (mouse) {showMenu(mouse);}
                onEntered: toolTipHosts.visible = true
                onExited: toolTipHosts.visible = false

                BaseToolTip {
                    id: toolTipHosts
                    text: qsTr("Edit list") + App.loc.emptyString
                }
            }
        }
    }

    function showMenu(mouse)
    {
        var component = Qt.createComponent("../../BaseElements/SubtitlesMenu.qml");
        var menu = component.createObject(editListBtn, {});
        menu.x = Math.round(mouse.x);
        menu.y = Math.round(mouse.y);
        menu.currentIndex = -1; // bug under Android workaround
        menu.open();
        menu.aboutToHide.connect(function(){
            menu.destroy();
        });
    }
}
