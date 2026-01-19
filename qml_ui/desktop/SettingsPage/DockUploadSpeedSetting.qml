import QtQuick
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.appsettings

SettingsCheckBox {
    text: qsTr("Show total upload speed in the Dock icon") + App.loc.emptyString
    checked: App.settings.toBool(App.settings.app.value(AppSettings.ShowTotalUploadSpeedInDock))
    onClicked: { App.settings.app.setValue(
                     AppSettings.ShowTotalUploadSpeedInDock,
                     App.settings.fromBool(checked)); }
}
