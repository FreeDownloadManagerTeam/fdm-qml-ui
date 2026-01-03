import QtQuick 2.0
import QtQuick.Layouts 1.2
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.vmsqt 1.0
import "../BaseElements"

BannerStrip
{
    readonly property bool shouldBeVisible: uiSettingsTools.settings.showUiUpdatedBanner
    visible: shouldBeVisible

    implicitWidth: meat.implicitWidth + meat.anchors.leftMargin + meat.anchors.rightMargin
    implicitHeight: meat.implicitHeight + meat.anchors.topMargin + meat.anchors.bottomMargin

    readonly property int __spacing: (appWindow.uiver === 1 ? 10 : 16)*appWindow.zoom

    RowLayout {
        id: meat

        anchors.fill: parent
        anchors.leftMargin: (appWindow.uiver === 1 ? 10 : 12)*appWindow.zoom
        anchors.rightMargin: anchors.leftMargin
        anchors.topMargin: (appWindow.uiver === 1 ? 0 : 8)*appWindow.zoom
        anchors.bottomMargin: anchors.topMargin

        spacing: 0

        BaseLabel {
            Layout.fillWidth: true
            text: (appWindow.uiver === 1 ?
                      qsTr("The classic interface is turned on.") :
                      qsTr("The new interface is turned on.")) + App.loc.emptyString
            color: appWindow.uiver === 1 ? appWindow.theme.foreground : appWindow.theme_v2.secondary
            font.pixelSize: 13*appWindow.fontZoom
        }

        Item {
            implicitHeight: 1
            Layout.fillWidth: true
            Layout.minimumWidth: __spacing
        }

        BannerCustomButton {
            text: qsTr("OK") + App.loc.emptyString
            onClicked: {
                uiSettingsTools.settings.showUiUpdatedBanner = false;
            }
        }

        Item {implicitWidth: __spacing; implicitHeight: 1}

        BannerCustomButton {
            text: (appWindow.uiver === 1 ?
                       qsTr("Switch to the new interface") :
                       qsTr("Switch to the classic interface")) + App.loc.emptyString
            onClicked: {
                uiSettingsTools.settings.uiVersion =
                        uiSettingsTools.settings.uiVersion === 1 ? 2 : 1;
                //uiSettingsTools.settings.showUiUpdatedBanner = false;
            }
        }
    }
}
