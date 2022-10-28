import QtQuick 2.0
import QtQuick.Layouts 1.2
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.vmsqt 1.0
import "../BaseElements"

Rectangle {
    id: shutdownBanner
    visible: shutdownTools.showBanner
    width: parent.width
    height: parent.height
    color: appWindow.theme.shutdownBannerBackground

    RowLayout {
        anchors.fill: parent
        height: parent.height
        anchors.leftMargin: 10*appWindow.zoom
        anchors.rightMargin: 10*appWindow.zoom

        BaseLabel {
            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
            text: !shutdownTools.powerManagement ? "" :
                  shutdownTools.powerManagement.shutdownType == VmsQt.SuspendComputer ? qsTr("Computer will be put to sleep after all downloads are completed.") :
                  (shutdownTools.powerManagement.shutdownType == VmsQt.HibernateComputer ? qsTr("Computer will be hibernate after all downloads are completed.") :
                  (shutdownTools.powerManagement.shutdownType == VmsQt.ShutdownComputer  ? qsTr("Computer will be shutdown after all downloads are completed.") : "")) + App.loc.emptyString
            font.pixelSize: 13*appWindow.fontZoom
            color: "#ffffff"
        }

        BannerCustomButton {
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            text: qsTr("Cancel") + App.loc.emptyString
            onClicked: shutdownTools.cancelShutdown()
        }
    }
}
