import QtQuick 2.10
import QtQuick.Controls 2.4
import "../../qt5compat"
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.appsettings 1.0
import org.freedownloadmanager.fdm.dmcoresettings 1.0
import org.freedownloadmanager.fdm.abstractdownloadsui 1.0
import "../BaseElements"

BaseComboBox
{
    id: combo

    Component.onCompleted: combo.reloadCombo()

    onActivated: index => App.settings.dmcore.setValue(DmCoreSettings.ExistingFileReaction, model[index].value)

    function reloadCombo() {
        combo.model = [
                    {text: qsTr("Rename"), value: AbstractDownloadsUi.DefrRename},
                    {text: qsTr("Overwrite"), value: AbstractDownloadsUi.DefrOverwrite},
                    {text: qsTr("Always ask"), value: AbstractDownloadsUi.DefrAsk},
                ];

        let cv = parseInt(App.settings.dmcore.value(DmCoreSettings.ExistingFileReaction));
        combo.currentIndex = combo.model.findIndex(e => e.value === cv);
    }

    Connections {
        target: App.loc
        onCurrentTranslationChanged: combo.reloadCombo()
    }
}
