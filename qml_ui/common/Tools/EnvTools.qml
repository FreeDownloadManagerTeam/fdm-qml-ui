import QtQuick 2.0
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.abstractdownloadsui 1.0

Item
{
    property bool hasInternetConnection: App.netOnlineStateMon.switchedOn
    property bool hasAllowedInternetConnection: App.allowedNetMon.switchedOn

    property bool downloadsAutoStartPrevented: App.downloads.mgr.autoStartPrevented

    property string downloadsAutoStartPreventReasonUiText:
        (!downloadsAutoStartPrevented ? "" :
        App.downloads.mgr.autoStartPreventerCulprit == AbstractDownloadsUi.AspcLowBattery ? qsTr("Low battery") :
        App.downloads.mgr.autoStartPreventerCulprit == AbstractDownloadsUi.AspcNetworkRoaming ? qsTr("Data roaming disabled") :
        App.downloads.mgr.autoStartPreventerCulprit == AbstractDownloadsUi.AspcNotOnline ? qsTr("No Internet connection") :
        App.downloads.mgr.autoStartPreventerCulprit == AbstractDownloadsUi.AspcNoAllowedNetworkInterfaceFound ? qsTr("Mobile data use disabled") :
        "No downloads allowed") + App.loc.emptyString
}
