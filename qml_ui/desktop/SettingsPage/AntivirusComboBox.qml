import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.dmcoresettings 1.0
import org.freedownloadmanager.fdm.appsettings 1.0
import "../BaseElements"
import "../../common"

BaseComboBox {
    id: root

    rightPadding: 5*appWindow.zoom
    leftPadding: 5*appWindow.zoom

    property string sCustom: qsTr("Configure manually...") + App.loc.emptyString

    popupVisibleRowsCount: 5
    settingsStyle: true
    fontSize: 12*appWindow.fontZoom

    onActivated: index => App.settings.dmcore.setValue(DmCoreSettings.AntivirusUid, model[index].id);

    Component.onCompleted: root.reloadCombo()

    Connections {
        target: App.loc
        onCurrentTranslationChanged: root.reloadCombo()
    }

    function reloadCombo() {
        var arr = [];
        var uids = App.knownAntiviruses.uids();

        for (var i = 0; i < uids.length; i++) {
            arr.push({'id': uids[i], 'text': App.knownAntiviruses.antivirusDisplayName(uids[i])});
        }

        arr.push({'id': "", 'text': sCustom});
        root.model = arr;

        var currentVal = App.settings.dmcore.value(DmCoreSettings.AntivirusUid);
        root.currentIndex = root.model.findIndex(e => e.id == currentVal);
    }
}
