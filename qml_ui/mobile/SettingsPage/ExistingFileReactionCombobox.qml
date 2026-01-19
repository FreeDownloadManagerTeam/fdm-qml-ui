import QtQuick
import QtQuick.Controls
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.appsettings
import org.freedownloadmanager.fdm.dmcoresettings
import org.freedownloadmanager.fdm.abstractdownloadsui 
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
