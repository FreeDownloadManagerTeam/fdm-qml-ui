import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.dmcoresettings
import org.freedownloadmanager.fdm.appsettings
import "../../common"
import "../BaseElements"

CenteredDialog
{
    id: root
    width: 320

    modal: true

    contentItem: Column {
        width: parent.width
        spacing: 10
        anchors.margins: 20

        DialogTitle {
            text: qsTr("Mobile data usage") + App.loc.emptyString
            Layout.fillWidth: true
        }

        Label
        {
            text: qsTr("Waiting for Wi-Fi to start download.") + App.loc.emptyString
            topPadding: 10
            width: parent.width
            wrapMode: Label.WordWrap
            anchors.left: parent.left
            horizontalAlignment: Text.AlignLeft
        }

        Label
        {
            text: qsTr("Would you like to enable usage of mobile data? *") + App.loc.emptyString
            width: parent.width
            wrapMode: Label.WordWrap
            anchors.left: parent.left
            horizontalAlignment: Text.AlignLeft
        }

        BaseCheckBox {
            id: dontAsk
            text: qsTr("Don't ask again") + App.loc.emptyString
            anchors.left: parent.left
        }

        Row {
            anchors.right: parent.right

            spacing: 5

            DialogButton {
                text: qsTr("Yes") + App.loc.emptyString
                onClicked: root.setMobileDataUsage(true)
            }

            DialogButton {
                text: qsTr("No") + App.loc.emptyString
                onClicked: root.setMobileDataUsage(false)
            }
        }

        Label
        {
            text: qsTr("* additional charges may apply") + App.loc.emptyString
            width: parent.width
            horizontalAlignment: Qt.Right
            wrapMode: Label.WordWrap
            font.pixelSize: 12
        }
    }

    function setMobileDataUsage(value) {
        uiSettingsTools.settings.dontAskMobileDataUsage = dontAsk.checkState === Qt.Checked;
        App.settings.dmcore.setValue(
            DmCoreSettings.AllowToUseMobileNetworks,
            App.settings.fromBool(value));
        root.close();
    }

    Connections {
        target: appWindow
        onStartDownload: {
            if (false == uiSettingsTools.settings.dontAskMobileDataUsage
                    && false == root.opened
                    && false == App.settings.toBool(App.settings.dmcore.value(DmCoreSettings.AllowToUseMobileNetworks))
                    && !envTools.hasAllowedInternetConnection) {
                root.open();
            }
        }
    }
}
