import QtQuick 2.0
import QtQuick.Layouts 1.2
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.vmsqt 1.0
import "../BaseElements"

BannerStrip {
    id: shutdownBanner

    readonly property bool shouldBeVisible: shutdownTools.showBanner
    visible: shouldBeVisible

    isShutdownBanner: true

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
            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
            text: !shutdownTools.powerManagement ? "" :
                  shutdownTools.powerManagement.shutdownType == VmsQt.SuspendComputer ? qsTr("Computer will be put to sleep after all downloads are completed.") :
                  (shutdownTools.powerManagement.shutdownType == VmsQt.HibernateComputer ? qsTr("Computer will be hibernate after all downloads are completed.") :
                  (shutdownTools.powerManagement.shutdownType == VmsQt.ShutdownComputer  ? qsTr("Computer will be shutdown after all downloads are completed.") : "")) + App.loc.emptyString
            font.pixelSize: 13*appWindow.fontZoom
            color: appWindow.uiver === 1 ? "#ffffff" : appWindow.theme_v2.secondary
        }

        Item {
            implicitHeight: 1
            Layout.fillWidth: true
            Layout.minimumWidth: __spacing
        }

        BannerCustomButton {
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            text: qsTr("Cancel") + App.loc.emptyString
            onClicked: shutdownTools.cancelShutdown()
        }
    }
}
