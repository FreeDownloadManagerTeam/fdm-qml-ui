import QtQuick
import QtQuick.Controls
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.appsettings
import org.freedownloadmanager.fdm.appfeatures
import org.freedownloadmanager.fdm.dmcoresettings
import "."
import "../BaseElements/"

Page {
    id: root

    header: PageHeaderWithBackArrow {
        pageTitle: qsTr("Remote control settings") + App.loc.emptyString
        onPopPage: root.StackView.view.pop()
    }

    SwitchSetting {
        description: qsTr("Don't use network proxy") + App.loc.emptyString
        switchChecked: App.settings.toBool(App.settings.app.value(AppSettings.DontUseNetworkProxyForRemoteAccess))
        onClicked: {
            switchChecked = !switchChecked;
            App.settings.app.setValue(
                        AppSettings.DontUseNetworkProxyForRemoteAccess,
                        App.settings.fromBool(switchChecked));
        }
    }
}
