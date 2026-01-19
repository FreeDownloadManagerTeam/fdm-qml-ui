import QtQuick
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import "../../BaseElements"

RowLayout {
    property bool forceDisableOK: false

    readonly property alias downloadBtnEnabled: okbtn.enabled

    Layout.topMargin: 10*appWindow.zoom
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
                     || downloadTools.emptyFileNameWarning || !downloadTools.hasWriteAccess
            anchors.verticalCenter: parent.verticalCenter
            text: (schedulerTools.statusWarning ? schedulerTools.lastError : (
                  downloadTools.emptyDownloadsListWarning ? qsTr("Please select download link") : (
                  downloadTools.batchDownloadLimitWarning ? qsTr("You can select no more than %1 links at a time").arg(downloadTools.batchDownloadMaxUrlsCount) : (
                  !downloadTools.hasWriteAccess ? qsTr("No write access to the selected directory") : (
                  downloadTools.notEnoughSpaceWarning ? qsTr("Not enough disk space") : (
                  downloadTools.wrongFilePathWarning ? qsTr("The path contains invalid characters") : (
                  downloadTools.wrongFileNameWarning ? (downloadTools.batchDownload ? qsTr("The subfolder name contains invalid characters") : qsTr("The filename contains invalid characters")) : (
                  downloadTools.emptyFileNameWarning ? (downloadTools.batchDownload ? qsTr("The subfolder name must not be empty") : qsTr("The filename must not be empty")) :
                                                       "")))))))) + App.loc.emptyString
            clip: true
            elide: Text.ElideRight
            width: parent.width
            font.pixelSize: 13*appWindow.fontZoom
            color: "#585759"
        }
    }


    BaseButton {
        id: cnclBtn
        text: qsTr("Cancel") + App.loc.emptyString
        onClicked: downloadTools.doReject()
    }

    BaseButton {
        id: okbtn
        text: qsTr("Download") + App.loc.emptyString
        blueBtn: true
        alternateBtnPressed: cnclBtn.isPressed
        enabled: !forceDisableOK &&
                 downloadTools.hasWriteAccess &&
                 !downloadTools.notEnoughSpaceWarning &&
                 !downloadTools.emptyDownloadsListWarning &&
                 !downloadTools.emptyFileNameWarning
        onClicked: tuneDialog.doOK()
    }
}
