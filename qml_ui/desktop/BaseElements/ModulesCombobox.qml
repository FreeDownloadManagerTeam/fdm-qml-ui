import QtQuick 2.0
import QtQuick.Controls 2.3
import org.freedownloadmanager.fdm 1.0
import "../../common"

Item {

    visible: downloadTools.modulesUrl && downloadTools.modulesUrl == downloadTools.urlText && combo.count > 1

    implicitWidth: combo.implicitWidth
    implicitHeight: combo.implicitHeight

    BaseComboBox {
        id: combo

        anchors.fill: parent

        onActivated: index => downloadTools.selectModule(combo.model[index].id)
    }

    Connections {
        target: downloadTools
        onModulesChanged: (modulesUids, urlDescriptions) => initialization(modulesUids, urlDescriptions)
    }

    function initialization(modulesUids, urlDescriptions) {
        let m = [];
        var index = -1;
        if (modulesUids.length > 1) {
            for (var i = 0; i < modulesUids.length; i++) {
                if (downloadTools.modulesSelectedUid == modulesUids[i]) {
                    index = i;
                }
                m.push.insert({'id': modulesUids[i], 'text': App.loc.tr(urlDescriptions[i])});
            }
        }
        combo.model = m;
        if (index !== -1)
            combo.currentIndex = index;
    }
}
