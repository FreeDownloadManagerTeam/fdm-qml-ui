import QtQuick 2.0
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.appsettings 1.0

SettingsCheckBox {
    text: qsTr("Show total upload speed in the Dock icon") + App.loc.emptyString
    checked: App.settings.toBool(App.settings.app.value(AppSettings.ShowTotalUploadSpeedInDock))
    onClicked: { App.settings.app.setValue(
                     AppSettings.ShowTotalUploadSpeedInDock,
                     App.settings.fromBool(checked)); }
}
