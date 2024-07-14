import QtQuick 2.0
import QtQuick.Controls 2.3
import org.freedownloadmanager.fdm 1.0
import "../../common"

BaseComboBox {
    id: combo

    visible: count > 1

    rightPadding: 5*appWindow.zoom
    leftPadding: 5*appWindow.zoom

    property var labels: ['', qsTr('Audio') + App.loc.emptyString, qsTr('Video') + App.loc.emptyString]

    onActivated: index => downloadTools.setPreferredFileType(combo.model[index].value, true)

    Connections {
        target: downloadTools
        onOriginFilesTypesChanged: initialization()
    }

    function initialization() {
        let m = [];
        var needIndex = -1;
        if (downloadTools.originFilesTypes.length > 1) {
            needIndex = 0;
            for (var i = 0; i < downloadTools.originFilesTypes.length; i++) {
                m.push({
                           value: downloadTools.originFilesTypes[i],
                           text: combo.labels[downloadTools.originFilesTypes[i]]
                       });
                if (downloadTools.preferredFileType == downloadTools.originFilesTypes[i])
                    needIndex = i;
            }
        }
        combo.model = m;
        if (needIndex !== -1)
            combo.currentIndex = needIndex;
    }
}
