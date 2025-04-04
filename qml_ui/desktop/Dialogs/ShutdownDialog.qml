import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.vmsqt 1.0
import "../BaseElements"

BaseDialog {
    id: root
    property int timeout: 30
    property int countdown: root.timeout

    title: qsTr("Confirm") + App.loc.emptyString
    onCloseClick: root.setShutdownAccepted(false)

    contentItem: BaseDialogItem {

        Keys.onReturnPressed: root.setShutdownAccepted(true)
        Keys.onEscapePressed: root.setShutdownAccepted(false)

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 3*appWindow.zoom

            BaseLabel {
                text: !shutdownTools.powerManagement ? "" :
                      shutdownTools.powerManagement.shutdownType == VmsQt.SuspendComputer ? qsTr("Attention! Your computer will be put to Sleep mode.") :
                      (shutdownTools.powerManagement.shutdownType == VmsQt.HibernateComputer ? qsTr("Attention! Your computer will be hibernated.") :
                      (shutdownTools.powerManagement.shutdownType == VmsQt.ShutdownComputer  ? qsTr("Attention! Your computer will be shut down.") : "")) + App.loc.emptyString
                Layout.maximumWidth: 550*appWindow.fontZoom
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.topMargin: 10*appWindow.zoom

                Item {
                    Layout.fillWidth: true
                }

                BaseButton {
                    id: cnclBtn
                    text: qsTr("Cancel") + App.loc.emptyString
                    onClicked: root.setShutdownAccepted(false)
                }

                BaseButton {
                    text: qsTr("OK (%1)").arg(root.countdown) + App.loc.emptyString
                    blueBtn: true
                    alternateBtnPressed: cnclBtn.isPressed
                    onClicked: root.setShutdownAccepted(true)
                }
            }
        }
    }

    Timer {
        id: countdownTimer
        interval: 1000
        running: false
        repeat: true
        onTriggered: timerHandler()
    }

    function open(){
        if (shutdownTools.powerManagement.shutdownComputerWhenDownloadsFinished !== true) {
            return false
        }
        showWindow();
        root.visible = true
        root.countdown = root.timeout;
        countdownTimer.stop()
        countdownTimer.running = root.countdown > 0
        countdownTimer.start()
    }

    function timerHandler() {
        root.countdown--

        if (!root.countdown) {
            root.setShutdownAccepted(true)
        }
    }

    function setShutdownAccepted(val) {
        countdownTimer.stop()
        root.close()
        shutdownTools.acceptShutdown(val);
    }

    onOpened: {
        forceActiveFocus();
    }

    Connections {
        target: shutdownTools
        onShutdownCancelled: root.close()
    }
}
