import QtQuick
import org.freedownloadmanager.fdm

Item
{
    readonly property var activeBanner: (integrationBanner.active && integrationBanner.item && integrationBanner.item.shouldBeVisible) ? integrationBanner :
                                        uiUpdatedBanner.shouldBeVisible ? uiUpdatedBanner :
                                        shutdownBanner.shouldBeVisible ? shutdownBanner :
                                        null

    visible: activeBanner

    implicitHeight: activeBanner ? activeBanner.implicitHeight : 0
    implicitWidth: activeBanner ? activeBanner.implicitWidth : 0

    Loader {
        id: integrationBanner
        active: btSupported && !App.rc.client.active
        source: "../../bt/desktop/IntegrationBanner.qml"
        width: parent.width
        height: parent.height
    }

    UiUpdatedBanner {
        id: uiUpdatedBanner
    }

    ShutdownBanner {
        id: shutdownBanner
    }
}
