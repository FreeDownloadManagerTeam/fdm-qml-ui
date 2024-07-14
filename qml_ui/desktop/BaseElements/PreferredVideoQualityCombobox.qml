import QtQuick 2.0
import QtQuick.Controls 2.3
import org.freedownloadmanager.fdm 1.0
import "../../common"

BaseComboBox {
    id: root

    rightPadding: 5*appWindow.zoom
    leftPadding: 5*appWindow.zoom

    onVisibleChanged: {
        if (visible) {
            updateState();
        }
    }

    Component.onCompleted: root.reloadCombo()

    Connections {
        target: App.loc
        onCurrentTranslationChanged: root.reloadCombo()
    }

    function reloadCombo() {
        root.model = [
                    {text: "240p" + " (" + qsTr("Lowest") + ")", value: "240"},
                    {text: "480p", value: "480"},
                    {text: "720p", value: "720"},
                    {text: "1080p", value: "1080"},
                    {text: "4K (2160p)", value: "2160"},
                    {text: "5K (2880p)", value: "2880"},
                    {text: "8K (4320p)" + " (" + qsTr("Highest") + ")", value: "4320"}];
    }

    function updateState() {
        var ph = downloadTools.preferredVideoHeight || downloadTools.defaultPreferredVideoHeight;
        var needIndex = -1;
        var nearestIndex = -1;
        var nearestDistance = -1;
        for (var i = 0; i < root.count; i ++) {
            if (ph == model[i].value) {
                needIndex = i;
                break;
            }
            else
            {
                var distance = Math.abs(ph - model[i].value);
                if (nearestIndex == -1 ||
                        nearestDistance > distance)
                {
                    nearestIndex = i;
                    nearestDistance = distance;
                }
            }
        }
        if (needIndex == -1)
            needIndex = nearestIndex != -1 ? nearestIndex : 0;
        currentIndex = needIndex;
    }

    onActivated: index => downloadTools.setPreferredVideoHeight(root.model[index].value, true)
}
