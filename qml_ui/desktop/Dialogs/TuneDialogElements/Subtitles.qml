import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import org.freedownloadmanager.fdm
import "../../BaseElements"
import "../../../common"

RowLayout {
    visible: downloadTools.subtitlesEnabled

    BaseCheckBox {
        id: subsCheckbox
        text: qsTr("Download subtitles") + App.loc.emptyString
        checked: downloadTools.needDownloadSubtitles
        checkBoxStyle: "gray"
        xOffset: 0
        onCheckedChanged: {
            downloadTools.needDownloadSubtitles = checked;
            downloadTools.needDownloadSubtitlesChangedByUser = true;
        }
    }

    WaSvgImage {
        id: editListBtn
        source: Qt.resolvedUrl("../../../images/desktop/edit_list.svg")
        Layout.preferredHeight: preferredHeight
        Layout.preferredWidth: preferredWidth
        zoom: appWindow.zoom
        layer {
            effect: MultiEffect {
                colorization: 1.0
                colorizationColor: appWindow.uiver === 1 ?
                                       appWindow.theme.foreground :
                                       appWindow.theme_v2.textColor
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
