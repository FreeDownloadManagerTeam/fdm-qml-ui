import QtQuick 2.0
import QtQuick.Layouts 1.2
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.vmsqt 1.0
import "../BaseElements"

Rectangle
{
    visible: uiSettingsTools.settings.showUiUpdatedBanner

    width: parent.width
    height: parent.height
    color: appWindow.theme.shutdownBannerBackground

    RowLayout {
        anchors.fill: parent
        height: parent.height
        anchors.leftMargin: 10*appWindow.zoom
        anchors.rightMargin: 10*appWindow.zoom

        BaseLabel {
            Layout.fillWidth: true
            text: (appWindow.uiver === 1 ?
                      qsTr("The classic interface is turned on.") :
                      qsTr("The new interface is turned on.")) + App.loc.emptyString
            font.pixelSize: 13*appWindow.fontZoom
            color: "#ffffff"
        }

        BannerCustomButton {
            text: qsTr("OK") + App.loc.emptyString
            onClicked: {
                uiSettingsTools.settings.showUiUpdatedBanner = false;
            }
        }

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
