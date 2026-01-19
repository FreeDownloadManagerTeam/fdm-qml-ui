import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.dmcoresettings
import org.freedownloadmanager.fdm.appsettings
import "../BaseElements"
import "../../common"

BaseComboBox {
    id: root

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
