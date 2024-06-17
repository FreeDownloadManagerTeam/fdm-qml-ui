import QtQuick 2.0
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0
import "../../BaseElements"

RowLayout {
    property bool forceDisableOK: false

    readonly property alias downloadBtnEnabled: okbtn.enabled

    Layout.topMargin: 10*appWindow.zoom
    Layout.bottomMargin: 15*appWindow.zoom
    Layout.alignment: Qt.AlignRight

    spacing: 5*appWindow.zoom

    Rectangle {
        color: "transparent"
        height: okbtn.height
        Layout.fillWidth: true

        BaseLabel {
            visible: schedulerTools.statusWarning || downloadTools.emptyDownloadsListWarning
                     || downloadTools.batchDownloadLimitWarning || downloadTools.notEnoughSpaceWarning
                     || downloadTools.wrongFilePathWarning || downloadTools.wrongFileNameWarning
                     || !downloadTools.hasWriteAccess
            anchors.verticalCenter: parent.verticalCenter
            text: schedulerTools.statusWarning ? schedulerTools.lastError : (
                  downloadTools.emptyDownloadsListWarning ? qsTr("Please select download link") + App.loc.emptyString : (
                  downloadTools.batchDownloadLimitWarning ? qsTr("You can select no more than %1 links at a time").arg(downloadTools.batchDownloadMaxUrlsCount) + App.loc.emptyString : (
                  !downloadTools.hasWriteAccess ? qsTr("No write access to the selected directory") + App.loc.emptyString : (
                  downloadTools.notEnoughSpaceWarning ? qsTr("Not enough disk space") + App.loc.emptyString : (
                  downloadTools.wrongFilePathWarning ? qsTr("The path contains invalid characters") : (
                  downloadTools.wrongFileNameWarning ? (downloadTools.batchDownload ? qsTr("The subfolder name contains invalid characters") : qsTr("The filename contains invalid characters")) :
                                                       ""))))))
            clip: true
            elide: Text.ElideRight
            width: parent.width
            font.pixelSize: 13*appWindow.fontZoom
            color: "#585759"
        }
    }


    CustomButton {
        id: cnclBtn
        text: qsTr("Cancel") + App.loc.emptyString
        onClicked: downloadTools.doReject()
    }

    CustomButton {
        id: okbtn
        text: qsTr("Download") + App.loc.emptyString
        blueBtn: true
        alternateBtnPressed: cnclBtn.isPressed
        enabled: !forceDisableOK &&
                 (downloadTools.hasWriteAccess && !downloadTools.notEnoughSpaceWarning && !downloadTools.emptyDownloadsListWarning)
        onClicked: tuneDialog.doOK()
    }
}
