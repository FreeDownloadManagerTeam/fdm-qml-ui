import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3
import "../../qt5compat"
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.qtupdate 1.0
import "../BaseElements"
import "../BaseElements/V2"

Item {
    id: root
    visible: updateTools.showDialog

    readonly property bool needMoreSpace: appWindow.uiver !== 1 &&
                                          (updateTools.state != QtUpdate.Failed ||
                                          (updateTools.state == QtUpdate.Finished && updateTools.updatesAvailable))

    height: (needMoreSpace ? 112 : 100)*appWindow.zoom
    width: (needMoreSpace ? 112 : 100)*appWindow.zoom + 200*appWindow.fontZoom

    property int arrowCenterX: width/2

    readonly property color bgColor: appWindow.uiver === 1 ?
                                         appWindow.theme.background :
                                         appWindow.theme_v2.bgColor

    readonly property int fontSize: (appWindow.uiver === 1 ? 14 : 16)*appWindow.fontZoom

    MouseArea {
        anchors.fill: parent
    }

    RectangularGlow {
        visible: appWindow.uiver !== 1 && appWindow.theme_v2.useGlow
        anchors.fill: dlg
        anchors.margins: 3*appWindow.zoom
        color: appWindow.theme_v2.glowColor
        glowRadius: 0
        spread: 0
        cornerRadius: dlg.radius
    }

    Rectangle {
        visible: appWindow.uiver === 1
        clip: true
        color: "transparent"
        width: 10*appWindow.zoom
        height: 5*appWindow.zoom
        x: arrowCenterX - width/2
        anchors.leftMargin: 25*appWindow.zoom
        z: 10

        Canvas {
            width: parent.width
            height: parent.height
            onPaint: {
                var ctx = getContext("2d")
                ctx.lineWidth = 1*appWindow.zoom
                ctx.strokeStyle = appWindow.uiver === 1 ?
                            root.bgColor :
                            appWindow.theme_v2.dialogBgColor
                ctx.fillStyle = appWindow.uiver === 1 ?
                            root.bgColor :
                            appWindow.theme_v2.dialogBgColor
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
        width: parent.width
        height: parent.height
        x: -20*appWindow.zoom
        y: appWindow.uiver === 1 ? 5*appWindow.zoom : 0
        color: root.bgColor
        radius: (appWindow.uiver === 1 ? 5 : 16)*appWindow.zoom
        border.color: appWindow.uiver === 1 ? "transparent" : appWindow.theme_v2.bg400
        border.width: appWindow.uiver === 1 ? 0 : 1*appWindow.zoom
        clip: true

        ColumnLayout {
            visible: updateTools.stage == QtUpdate.CheckUpdates
            anchors.margins: (appWindow.uiver === 1 ? 10 :  16)*appWindow.zoom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.fill: parent
            spacing: 5*appWindow.zoom

            BaseLabel {
                visible: updateTools.state == QtUpdate.Ready || updateTools.state == QtUpdate.InProgress
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                text: qsTr("Checking for updates...") + App.loc.emptyString
                font.pixelSize: root.fontSize
            }
            DownloadsItemProgressIndicator {
                visible: appWindow.uiver === 1 &&
                         (updateTools.state == QtUpdate.Ready || updateTools.state == QtUpdate.InProgress)
                infinityIndicator: updateTools.progress === -1
                percent: updateTools.progress
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter | Qt.AlignCenter
            }
            SlimProgressBar_V2 {
                visible: appWindow.uiver !== 1 &&
                         (updateTools.state == QtUpdate.Ready || updateTools.state == QtUpdate.InProgress)
                indeterminate: updateTools.progress === -1
                value: updateTools.progress
                running: updateTools.state == QtUpdate.InProgress
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter | Qt.AlignCenter
            }

            BaseLabel {
                visible: updateTools.state == QtUpdate.Failed
                Layout.alignment: Qt.AlignLeft
                color: appWindow.theme.errorMessage
                text: qsTr("Error:") + App.loc.emptyString
                font.pixelSize: root.fontSize
            }
            BaseLabel {
                visible: updateTools.state == QtUpdate.Failed
                Layout.alignment: Qt.AlignLeft
                color: appWindow.theme.errorMessage
                text: updateTools.lastErrorDescription
                font.pixelSize: root.fontSize
            }
            Row {
                visible: updateTools.state == QtUpdate.Failed
                Layout.alignment: Qt.AlignHCenter | Qt.AlignCenter
                spacing: 10*appWindow.zoom

                BaseButton {
                    text: qsTr("Retry") + App.loc.emptyString
                    blueBtn: true
                    smallBtn: true
                    onClicked: updateTools.checkForUpdates()
                }
                BaseButton {
                    text: qsTr("Cancel") + App.loc.emptyString
                    smallBtn: true
                    onClicked: updateTools.cancel()
                }
            }

            BaseLabel {
                visible: updateTools.state == QtUpdate.Finished && updateTools.updatesAvailable
                Layout.alignment: Qt.AlignLeft
                text: qsTr("New version is available") + App.loc.emptyString
                font.pixelSize: root.fontSize
            }
            BaseHandCursorLabel {
                visible: updateTools.state == QtUpdate.Finished && updateTools.updatesAvailable &&
                         updateTools.version && updateTools.changelog
                Layout.alignment: Qt.AlignLeft
                text: "<a href='#'>" + qsTr("What's new in %1").arg(updateTools.version) + App.loc.emptyString + "</a>"
                onLinkActivated: updateTools.openWhatsNewDialog()
            }
            BaseButton {
                visible: updateTools.state == QtUpdate.Finished && updateTools.updatesAvailable
                Layout.alignment: Qt.AlignHCenter | Qt.AlignCenter
                text: qsTr("Update") + App.loc.emptyString
                blueBtn: true
                smallBtn: true
                onClicked: updateTools.updater.downloadUpdates()
            }

            BaseLabel {
                visible: updateTools.state == QtUpdate.Finished && !updateTools.updatesAvailable
                Layout.alignment: appWindow.uiver === 1 ? Qt.AlignLeft : Qt.AlignHCenter
                text: qsTr("%1 is up to date").arg(App.shortDisplayName) + App.loc.emptyString
                font.pixelSize: root.fontSize
            }
            BaseButton {
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
            anchors.margins: (appWindow.uiver === 1 ? 10 :  16)*appWindow.zoom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.fill: parent

            BaseLabel {
                visible: updateTools.state == QtUpdate.Ready || updateTools.state == QtUpdate.InProgress || updateTools.state == QtUpdate.Finished
                Layout.alignment: Qt.AlignLeft
                text: qsTr("Downloading update") + App.loc.emptyString
                font.pixelSize: root.fontSize
            }
            DownloadsItemProgressIndicator {
                visible: updateTools.state == QtUpdate.Ready || updateTools.state == QtUpdate.InProgress || updateTools.state == QtUpdate.Finished
                infinityIndicator: updateTools.progress === -1
                percent: updateTools.progress
                Layout.fillWidth: true
            }
            BaseButton {
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
                font.pixelSize: root.fontSize
            }
            BaseLabel {
                visible: updateTools.state == QtUpdate.Failed
                Layout.alignment: Qt.AlignLeft
                color: appWindow.theme.errorMessage
                text: updateTools.lastErrorDescription
                font.pixelSize: root.fontSize
            }
            Row {
                visible: updateTools.state == QtUpdate.Failed
                Layout.alignment: Qt.AlignHCenter | Qt.AlignCenter
                spacing: 10*appWindow.zoom

                BaseButton {
                    text: qsTr("Retry") + App.loc.emptyString
                    blueBtn: true
                    smallBtn: true
                    onClicked: updateTools.checkForUpdates()
                }
                BaseButton {
                    text: qsTr("Cancel") + App.loc.emptyString
                    smallBtn: true
                    onClicked: updateTools.cancel()
                }
            }
        }

        ColumnLayout {
            visible: updateTools.stage == QtUpdate.PostDownloadCheck
            anchors.margins: (appWindow.uiver === 1 ? 10 :  16)*appWindow.zoom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.fill: parent

            BaseLabel {
                visible: updateTools.state == QtUpdate.Ready || updateTools.state == QtUpdate.InProgress
                Layout.alignment: Qt.AlignLeft
                text: qsTr("Checking...") + App.loc.emptyString
                font.pixelSize: root.fontSize
            }
            DownloadsItemProgressIndicator {
                visible: updateTools.state == QtUpdate.Ready || updateTools.state == QtUpdate.InProgress
                infinityIndicator: updateTools.progress === -1
                percent: updateTools.progress
                Layout.fillWidth: true
            }
            BaseButton {
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
                font.pixelSize: root.fontSize
            }
            BaseLabel {
                visible: updateTools.state == QtUpdate.Failed
                Layout.alignment: Qt.AlignLeft
                color: appWindow.theme.errorMessage
                text: updateTools.lastErrorDescription
                font.pixelSize: root.fontSize
            }
            Row {
                visible: updateTools.state == QtUpdate.Failed
                Layout.alignment: Qt.AlignHCenter | Qt.AlignCenter
                spacing: 10*appWindow.zoom

                BaseButton {
                    text: qsTr("Retry") + App.loc.emptyString
                    blueBtn: true
                    smallBtn: true
                    onClicked: updateTools.checkForUpdates()
                }
                BaseButton {
                    text: qsTr("Cancel") + App.loc.emptyString
                    smallBtn: true
                    onClicked: updateTools.cancel()
                }
            }
            BaseLabel {
                visible: updateTools.state == QtUpdate.Finished && updateTools.updater.initiator == QtUpdate.InitiatorAutomatic
                Layout.alignment: Qt.AlignLeft
                text: qsTr("Update downloaded") + App.loc.emptyString
                font.pixelSize: root.fontSize
            }
            Row {
                visible: updateTools.state == QtUpdate.Finished && updateTools.updater.initiator == QtUpdate.InitiatorAutomatic
                Layout.alignment: Qt.AlignHCenter | Qt.AlignCenter
                spacing: 10*appWindow.zoom

                BaseButton {
                    text: qsTr("Install update") + App.loc.emptyString
                    blueBtn: true
                    smallBtn: true
                    onClicked: updateTools.updater.installUpdates()
                }
                BaseButton {
                    text: qsTr("Cancel") + App.loc.emptyString
                    smallBtn: true
                    onClicked: updateTools.cancel()
                }
            }
        }

        ColumnLayout {
            visible: updateTools.stage == QtUpdate.PreInstallCheck
            anchors.margins: (appWindow.uiver === 1 ? 10 :  16)*appWindow.zoom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.fill: parent

            BaseLabel {
                visible: updateTools.state == QtUpdate.Ready || updateTools.state == QtUpdate.InProgress || updateTools.state == QtUpdate.Finished
                Layout.alignment: Qt.AlignLeft
                text: qsTr("Installing updates") + App.loc.emptyString
                font.pixelSize: root.fontSize
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
                font.pixelSize: root.fontSize
            }
            BaseLabel {
                visible: updateTools.state == QtUpdate.Failed
                Layout.alignment: Qt.AlignLeft
                color: appWindow.theme.errorMessage
                text: updateTools.lastErrorDescription
                font.pixelSize: root.fontSize
            }
            Row {
                visible: updateTools.state == QtUpdate.Failed
                Layout.alignment: Qt.AlignHCenter | Qt.AlignCenter
                spacing: 10*appWindow.zoom

                BaseButton {
                    text: qsTr("Retry") + App.loc.emptyString
                    blueBtn: true
                    smallBtn: true
                    onClicked: updateTools.checkForUpdates()
                }
                BaseButton {
                    text: qsTr("Cancel") + App.loc.emptyString
                    smallBtn: true
                    onClicked: updateTools.cancel()
                }
            }
        }

        ColumnLayout {
            visible: updateTools.stage == QtUpdate.InstallUpdates
            anchors.margins: (appWindow.uiver === 1 ? 10 :  16)*appWindow.zoom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.fill: parent

            BaseLabel {
                visible: updateTools.state == QtUpdate.Ready || updateTools.state == QtUpdate.InProgress
                Layout.alignment: Qt.AlignLeft
                text: qsTr("Installing updates") + App.loc.emptyString
                font.pixelSize: root.fontSize
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
                font.pixelSize: root.fontSize
            }
            BaseLabel {
                visible: updateTools.state == QtUpdate.Failed
                Layout.alignment: Qt.AlignLeft
                color: appWindow.theme.errorMessage
                text: updateTools.lastErrorDescription
                font.pixelSize: root.fontSize
            }
            Row {
                visible: updateTools.state == QtUpdate.Failed
                Layout.alignment: Qt.AlignHCenter | Qt.AlignCenter
                spacing: 10*appWindow.zoom

                BaseButton {
                    text: qsTr("Retry") + App.loc.emptyString
                    blueBtn: true
                    smallBtn: true
                    onClicked: updateTools.checkForUpdates()
                }
                BaseButton {
                    text: qsTr("Cancel") + App.loc.emptyString
                    smallBtn: true
                    onClicked: updateTools.cancel()
                }
            }
            BaseLabel {
                visible: updateTools.state == QtUpdate.Finished && updateTools.restartRequired
                Layout.alignment: Qt.AlignLeft
                text: qsTr("Relaunch %1 to update").arg(App.shortDisplayName) + App.loc.emptyString
                font.pixelSize: root.fontSize
            }
            Row {
                visible: updateTools.state == QtUpdate.Finished && updateTools.restartRequired
                Layout.alignment: Qt.AlignHCenter | Qt.AlignCenter
                spacing: 10*appWindow.zoom

                BaseButton {
                    text: qsTr("Relaunch") + App.loc.emptyString
                    blueBtn: true
                    smallBtn: true
                    onClicked: {
                        updateTools.relaunch();
                    }
                }

                BaseButton {
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
                font.pixelSize: root.fontSize
            }
            BaseButton {
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
        visible: appWindow.uiver === 1
        anchors.fill: dlg
        horizontalOffset: 0
        verticalOffset: 0
        radius: 8.0*appWindow.zoom
        samples: 17
        color: appWindow.theme.shadow
        source: dlg
    }
}
