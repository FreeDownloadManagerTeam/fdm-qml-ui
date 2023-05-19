import QtQuick 2.12
import QtQuick.Controls 2.12
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.appsettings 1.0
import org.freedownloadmanager.fdm.appfeatures 1.0
import org.freedownloadmanager.fdm.dmcoresettings 1.0
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
