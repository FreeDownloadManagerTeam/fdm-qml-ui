/*
  Remote banner component MUST define "finished" signal.
  This signal should be issued when the user has finished working with the banner.
  After this signal, this banner will not be shown to the user again.
*/

import QtQuick 2.12
import QtQml 2.12
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.appsettings 1.0

Item
{
    id: root

    property var settings
    readonly property bool bannerOpened: d.banner ? d.banner.opened : false

    QtObject
    {
        id: d
        property string bannerId
        property var bannerComponent
        property var banner
    }

    Timer
    {
        id: checkTimer
        interval: 1000
        repeat: false
        onTriggered: checkAndShow()
    }

    function check()
    {
        return App.settings.toBool(App.settings.app.value(AppSettings.ShowSpecialOffers)) &&
                App.remoteBanner &&
                !d.bannerComponent &&
                !d.banner &&
                settings.lastRemoteBannerId !== App.remoteBanner.id &&
                appWindow.active &&
                appWindow.canShowCreateDownloadDialog();
    }

    function checkAndApplyTimer()
    {
        if (check())
            checkTimer.start();
        else
            checkTimer.stop();
    }

    function checkAndShow()
    {
        if (check())
        {
            console.log("[RemoteBanner]: creating component");

            d.bannerId = App.remoteBanner.id;

            d.bannerComponent = Qt.createComponent(
                        App.remoteBanner.url,
                        root.parent);

            if (d.bannerComponent.status == Component.Loading)
                d.bannerComponent.statusChanged.connect(processBannerComponentStatus);
            else
                processBannerComponentStatus();
        }
    }

    function processBannerComponentStatus()
    {
        if (d.bannerComponent.status == Component.Ready)
            createBanner();
        else if (d.bannerComponent.status == Component.Error)
            console.error("[RemoteBanner]: failed to load banner component: ", d.bannerComponent.errorString());
    }

    function createBanner()
    {
        console.log("[RemoteBanner]: creating banner");

        d.banner = d.bannerComponent.createObject(
                    root.parent,
                    {"anchors.centerIn": root.parent});

        d.banner.finished.connect(onBannerFinished);
    }

    function onBannerFinished()
    {
        console.log("[RemoteBanner]: finished");

        settings.lastRemoteBannerId = d.bannerId;

        d.bannerId = "";
        d.banner = undefined;
        d.bannerComponent = undefined;
    }

    Component.onCompleted: checkAndApplyTimer()

    Connections
    {
        target: appWindow
        onActiveChanged: checkAndApplyTimer()
    }

    Connections
    {
        target: App.remoteBanner
        onIdChanged: checkAndApplyTimer()
    }
}
