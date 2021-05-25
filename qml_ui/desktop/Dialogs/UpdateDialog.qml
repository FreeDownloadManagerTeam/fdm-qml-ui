import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3
import QtGraphicalEffects 1.0
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.qtupdate 1.0
import "../BaseElements"

Item {
    id: root
    visible: updateTools.showDialog
    height: 100
    width: 300

    MouseArea {
        anchors.fill: parent
    }

    Rectangle {
        clip: true
        color: "transparent"
        width: 10
        height: 5
//        anchors.left: appWindow.macVersion ? parent.left : undefined
        anchors.horizontalCenter: parent.horizontalCenter//!appWindow.macVersion ? parent.horizontalCenter : undefined
        anchors.leftMargin: 25
        z: 10

        Canvas {
            width: parent.width
            height: parent.height
            onPaint: {
                var ctx = getContext("2d")
                ctx.lineWidth = 1
                ctx.strokeStyle = appWindow.theme.background
                ctx.fillStyle = appWindow.theme.background
                ctx.beginPath()
                ctx.moveTo(width / 2,0)
                ctx.lineTo(width,height)
                ctx.lineTo(0,height)
                ctx.lineTo(width / 2,0)
                ctx.closePath()
                ctx.fill()
                ctx.stroke()
            }
        }
    }

    Rectangle {
        id: dlg
//        anchors.left: parent.left
//        anchors.horizontalCenter: parent.horizontalCenter
//        anchors.fill: parent
//        anchors.topMargin: 5
        width: parent.width
        height: parent.height
        x: -20
        y: 5
        color: appWindow.theme.background
        radius: 5
        clip: true

        ColumnLayout {
            visible: updateTools.stage == QtUpdate.CheckUpdates
            anchors.margins: 10
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.fill: parent
            spacing: 5

//            CustomButton {
//                visible: updateTools.state == QtUpdate.Ready
//                Layout.alignment: Qt.AlignHCenter | Qt.AlignCenter
//                text: qsTr("Check for updates") + App.loc.emptyString
//                blueBtn: true
//                onClicked: {
//                    appWindow.updateDlgClosed()
//                }
//            }
            BaseLabel {
                visible: updateTools.state == QtUpdate.Ready || updateTools.state == QtUpdate.InProgress
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                text: qsTr("Checking for updates...") + App.loc.emptyString
            }
            DownloadsItemProgressIndicator {
                visible: updateTools.state == QtUpdate.Ready || updateTools.state == QtUpdate.InProgress
                infinityIndicator: updateTools.progress === -1
                percent: updateTools.progress
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter | Qt.AlignCenter
            }

            BaseLabel {
                visible: updateTools.state == QtUpdate.Failed
                Layout.alignment: Qt.AlignLeft
                color: appWindow.theme.errorMessage
                text: qsTr("Error:") + App.loc.emptyString
            }
            BaseLabel {
                visible: updateTools.state == QtUpdate.Failed
                Layout.alignment: Qt.AlignLeft
                color: appWindow.theme.errorMessage
                text: updateTools.lastErrorDescription
            }
            Row {
                visible: updateTools.state == QtUpdate.Failed
                Layout.alignment: Qt.AlignHCenter | Qt.AlignCenter
                spacing: 10

                CustomButton {
                    text: qsTr("Retry") + App.loc.emptyString
                    blueBtn: true
                    smallBtn: true
                    onClicked: updateTools.checkForUpdates()
                }
                CustomButton {
                    text: qsTr("Cancel") + App.loc.emptyString
                    smallBtn: true
                    onClicked: updateTools.cancel()
                }
            }

            BaseLabel {
                visible: updateTools.state == QtUpdate.Finished && updateTools.updatesAvailable
                Layout.alignment: Qt.AlignLeft
                text: qsTr("New version is available") + App.loc.emptyString
            }
            CustomButton {
                visible: updateTools.state == QtUpdate.Finished && updateTools.updatesAvailable
                Layout.alignment: Qt.AlignHCenter | Qt.AlignCenter
                text: qsTr("Update") + App.loc.emptyString
                blueBtn: true
                smallBtn: true
                onClicked: updateTools.updater.downloadUpdates()
            }

            BaseLabel {
                visible: updateTools.state == QtUpdate.Finished && !updateTools.updatesAvailable
                Layout.alignment: Qt.AlignLeft
                text: qsTr("%1 is up to date").arg(App.shortDisplayName) + App.loc.emptyString
            }
            CustomButton {
                visible: updateTools.state == QtUpdate.Finished && !updateTools.updatesAvailable
                Layout.alignment: Qt.AlignHCenter | Qt.AlignCenter
                text: qsTr("OK") + App.loc.emptyString
                blueBtn: true
                smallBtn: true
                onClicked: updateTools.ok()
            }
        }

        ColumnLayout {
            visible: updateTools.stage == QtUpdate.DownloadUpdates
            anchors.margins: 10
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.fill: parent

            BaseLabel {
                visible: updateTools.state == QtUpdate.Ready || updateTools.state == QtUpdate.InProgress || updateTools.state == QtUpdate.Finished
                Layout.alignment: Qt.AlignLeft
                text: qsTr("Downloading update") + App.loc.emptyString
            }
            DownloadsItemProgressIndicator {
                visible: updateTools.state == QtUpdate.Ready || updateTools.state == QtUpdate.InProgress || updateTools.state == QtUpdate.Finished
                infinityIndicator: updateTools.progress === -1
                percent: updateTools.progress
                Layout.fillWidth: true
            }
            CustomButton {
                visible: updateTools.state == QtUpdate.Ready || updateTools.state == QtUpdate.InProgress || updateTools.state == QtUpdate.Finished
                Layout.alignment: Qt.AlignHCenter | Qt.AlignCenter
                text: qsTr("Cancel") + App.loc.emptyString
                smallBtn: true
                onClicked: updateTools.cancel()
            }
            BaseLabel {
                visible: updateTools.state == QtUpdate.Failed
                Layout.alignment: Qt.AlignLeft
                color: appWindow.theme.errorMessage
                text: qsTr("Error downloading update:") + App.loc.emptyString
            }
            BaseLabel {
                visible: updateTools.state == QtUpdate.Failed
                Layout.alignment: Qt.AlignLeft
                color: appWindow.theme.errorMessage
                text: updateTools.lastErrorDescription
            }
            Row {
                visible: updateTools.state == QtUpdate.Failed
                Layout.alignment: Qt.AlignHCenter | Qt.AlignCenter
                spacing: 10

                CustomButton {
                    text: qsTr("Retry") + App.loc.emptyString
                    blueBtn: true
                    smallBtn: true
                    onClicked: updateTools.checkForUpdates()
                }
                CustomButton {
                    text: qsTr("Cancel") + App.loc.emptyString
                    smallBtn: true
                    onClicked: updateTools.cancel()
                }
            }
        }

        ColumnLayout {
            visible: updateTools.stage == QtUpdate.PostDownloadCheck
            anchors.margins: 10
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.fill: parent

            BaseLabel {
                visible: updateTools.state == QtUpdate.Ready || updateTools.state == QtUpdate.InProgress
                Layout.alignment: Qt.AlignLeft
                text: qsTr("Checking...") + App.loc.emptyString
            }
            DownloadsItemProgressIndicator {
                visible: updateTools.state == QtUpdate.Ready || updateTools.state == QtUpdate.InProgress
                infinityIndicator: updateTools.progress === -1
                percent: updateTools.progress
                Layout.fillWidth: true
            }
            CustomButton {
                visible: updateTools.state == QtUpdate.Ready || updateTools.state == QtUpdate.InProgress
                Layout.alignment: Qt.AlignHCenter | Qt.AlignCenter
                text: qsTr("Cancel") + App.loc.emptyString
                smallBtn: true
                onClicked: updateTools.cancel()
            }
            BaseLabel {
                visible: updateTools.state == QtUpdate.Failed
                Layout.alignment: Qt.AlignLeft
                color: appWindow.theme.errorMessage
                text: qsTr("Error:") + App.loc.emptyString
            }
            BaseLabel {
                visible: updateTools.state == QtUpdate.Failed
                Layout.alignment: Qt.AlignLeft
                color: appWindow.theme.errorMessage
                text: updateTools.lastErrorDescription
            }
            Row {
                visible: updateTools.state == QtUpdate.Failed
                Layout.alignment: Qt.AlignHCenter | Qt.AlignCenter
                spacing: 10

                CustomButton {
                    text: qsTr("Retry") + App.loc.emptyString
                    blueBtn: true
                    smallBtn: true
                    onClicked: updateTools.checkForUpdates()
                }
                CustomButton {
                    text: qsTr("Cancel") + App.loc.emptyString
                    smallBtn: true
                    onClicked: updateTools.cancel()
                }
            }
            BaseLabel {
                visible: updateTools.state == QtUpdate.Finished && updateTools.updater.initiator == QtUpdate.InitiatorAutomatic
                Layout.alignment: Qt.AlignLeft
                text: qsTr("Update downloaded") + App.loc.emptyString
            }
            Row {
                visible: updateTools.state == QtUpdate.Finished && updateTools.updater.initiator == QtUpdate.InitiatorAutomatic
                Layout.alignment: Qt.AlignHCenter | Qt.AlignCenter
                spacing: 10

                CustomButton {
                    text: qsTr("Install update") + App.loc.emptyString
                    blueBtn: true
                    smallBtn: true
                    onClicked: updateTools.updater.installUpdates()
                }
                CustomButton {
                    text: qsTr("Cancel") + App.loc.emptyString
                    smallBtn: true
                    onClicked: updateTools.cancel()
                }
            }
        }

        ColumnLayout {
            visible: updateTools.stage == QtUpdate.PreInstallCheck
            anchors.margins: 10
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.fill: parent

            BaseLabel {
                visible: updateTools.state == QtUpdate.Ready || updateTools.state == QtUpdate.InProgress || updateTools.state == QtUpdate.Finished
                Layout.alignment: Qt.AlignLeft
                text: qsTr("Installing updates") + App.loc.emptyString
            }
            DownloadsItemProgressIndicator {
                visible: updateTools.state == QtUpdate.Ready || updateTools.state == QtUpdate.InProgress || updateTools.state == QtUpdate.Finished
                infinityIndicator: updateTools.progress === -1
                percent: updateTools.progress
                Layout.fillWidth: true
            }
            BaseLabel {
                visible: updateTools.state == QtUpdate.Failed
                Layout.alignment: Qt.AlignLeft
                color: appWindow.theme.errorMessage
                text: qsTr("Error occurred during installation:") + App.loc.emptyString
            }
            BaseLabel {
                visible: updateTools.state == QtUpdate.Failed
                Layout.alignment: Qt.AlignLeft
                color: appWindow.theme.errorMessage
                text: updateTools.lastErrorDescription
            }
            Row {
                visible: updateTools.state == QtUpdate.Failed
                Layout.alignment: Qt.AlignHCenter | Qt.AlignCenter
                spacing: 10

                CustomButton {
                    text: qsTr("Retry") + App.loc.emptyString
                    blueBtn: true
                    smallBtn: true
                    onClicked: updateTools.checkForUpdates()
                }
                CustomButton {
                    text: qsTr("Cancel") + App.loc.emptyString
                    smallBtn: true
                    onClicked: updateTools.cancel()
                }
            }
        }

        ColumnLayout {
            visible: updateTools.stage == QtUpdate.InstallUpdates
            anchors.margins: 10
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.fill: parent

            BaseLabel {
                visible: updateTools.state == QtUpdate.Ready || updateTools.state == QtUpdate.InProgress
                Layout.alignment: Qt.AlignLeft
                text: qsTr("Installing updates") + App.loc.emptyString
            }
            DownloadsItemProgressIndicator {
                visible: updateTools.state == QtUpdate.Ready || updateTools.state == QtUpdate.InProgress
                infinityIndicator: updateTools.progress === -1
                percent: updateTools.progress
                Layout.fillWidth: true
            }
            BaseLabel {
                visible: updateTools.state == QtUpdate.Failed
                Layout.alignment: Qt.AlignLeft
                color: appWindow.theme.errorMessage
                text: qsTr("Error occurred during installation:") + App.loc.emptyString
            }
            BaseLabel {
                visible: updateTools.state == QtUpdate.Failed
                Layout.alignment: Qt.AlignLeft
                color: appWindow.theme.errorMessage
                text: updateTools.lastErrorDescription
            }
            Row {
                visible: updateTools.state == QtUpdate.Failed
                Layout.alignment: Qt.AlignHCenter | Qt.AlignCenter
                spacing: 10

                CustomButton {
                    text: qsTr("Retry") + App.loc.emptyString
                    blueBtn: true
                    smallBtn: true
                    onClicked: updateTools.checkForUpdates()
                }
                CustomButton {
                    text: qsTr("Cancel") + App.loc.emptyString
                    smallBtn: true
                    onClicked: updateTools.cancel()
                }
            }
            BaseLabel {
                visible: updateTools.state == QtUpdate.Finished && updateTools.restartRequired
                Layout.alignment: Qt.AlignLeft
                text: qsTr("Relaunch %1 to update").arg(App.shortDisplayName) + App.loc.emptyString
            }
            Row {
                visible: updateTools.state == QtUpdate.Finished && updateTools.restartRequired
                Layout.alignment: Qt.AlignHCenter | Qt.AlignCenter
                spacing: 10

                CustomButton {
                    text: qsTr("Relaunch") + App.loc.emptyString
                    blueBtn: true
                    smallBtn: true
                    onClicked: {
                        updateTools.relaunch();
                    }
                }

                CustomButton {
                    text: qsTr("Later") + App.loc.emptyString
                    smallBtn: true
                    onClicked: {
                        appWindow.updateDlgClosed()
                    }
                }
            }
            BaseLabel {
                visible: updateTools.state == QtUpdate.Finished && !updateTools.restartRequired
                Layout.alignment: Qt.AlignLeft
                text: qsTr("%1 is up to date").arg(App.shortDisplayName) + App.loc.emptyString
            }
            CustomButton {
                visible: updateTools.state == QtUpdate.Finished && !updateTools.restartRequired
                Layout.alignment: Qt.AlignHCenter | Qt.AlignCenter
                text: qsTr("Check for updates") + App.loc.emptyString
                blueBtn: true
                smallBtn: true
                onClicked: updateTools.checkForUpdates()
            }
        }
    }

    DropShadow {
        anchors.fill: dlg
        horizontalOffset: 0
        verticalOffset: 0
        radius: 8.0
        samples: 17
        color: appWindow.theme.shadow
        source: dlg
    }

}
