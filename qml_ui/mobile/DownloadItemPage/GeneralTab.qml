import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.impl 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.4
import "../../qt5compat"
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.appfeatures 1.0
import "../../common/Tools"

import "../"
import "../BaseElements"
import "../../common"

Flickable {
    id: root
    anchors.fill: parent
    anchors.margins: 14

    flickableDirection: Flickable.VerticalFlick
    ScrollIndicator.vertical: ScrollIndicator { }
    boundsBehavior: Flickable.StopAtBounds

    contentHeight: myLoader.heightOccupiedAbove + myLoader.progressHeight

    property var downloadModel: downloadsItemTools.item


    Item {
        anchors.fill: parent

        anchors.leftMargin: appWindow.showBordersInDownloadsList ? parent.width * 0.1 : 0
        anchors.rightMargin: appWindow.showBordersInDownloadsList ? parent.width * 0.1 : 0

        Column {
            id: topColumn
            anchors.top: parent.top
            width: parent.width

            spacing: 10

            Rectangle {

                width: parent.width
                height: forImg.height
                color: "transparent"

                DownloadIcon {
                    id: forImg
                    anchors.top: parent.top
                }

                Column {
                    id: titleAndProgress
                    spacing: 7
                    anchors.top: parent.top
                    anchors.left: forImg.right
                    anchors.right: parent.right
                    anchors.rightMargin: 20
                    anchors.leftMargin: 20

                    BaseLabel {
                        width: parent.width
                        text: downloadsItemTools.tplTitle
                        elide: Text.ElideRight
                        font.pixelSize: 16
                        font.family: "Roboto"
                        font.weight: Font.Medium
                    }

                    Rectangle {
                        id: downloadStatus
                        width: parent.width
                        height: 20//Math.max(perscentText.height, statusCompleted.height)
                        color: "transparent"

                        function getProgressValue() {
                            var value = 0;
                            if (downloadsItemTools.performingLo) {
                                value = downloadsItemTools.loProgress !== -1 ? downloadsItemTools.loProgress : 0;
                            } else if (downloadModel.selectedSize !== -1) {
                                value = JsTools.progress(downloadModel.selectedBytesDownloaded, downloadModel.selectedSize);
                            }
                            return value;
                        }

                        ProgressIndicator {
                            id: progressbar_rect
                            //visible: downloadsItemTools.showProgressIndicator
                            visible: downloadsItemTools.selectedSize !== -1 || downloadsItemTools.performingLo
                            anchors.verticalCenter: parent.verticalCenter
                            small: false
                            progress: downloadsItemTools.progress
                            infinityIndicator: downloadsItemTools.infinityIndicator
                            inProgress: downloadsItemTools.indicatorInProgress
                            progressColor: downloadsItemTools.indicatorInProgress ? appWindow.theme.progressRunning :
                                           downloadsItemTools.inError ? appWindow.theme.progressError :
                                           downloadsItemTools.finished ? appWindow.theme.progressDone : appWindow.theme.progressPaused
                        }

                        ActionButton {
                            locked: downloadsItemTools.locked || downloadsItemTools.stopping
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: progressbar_rect.right
                        }
                    }
                }
            }

            RowLayout {
                visible: downloadsItemTools.inError
                width: parent.width
                spacing: 3
                Image {
                    id: img
                    sourceSize.width: 16
                    sourceSize.height: 16
                    source: Qt.resolvedUrl("../../images/mobile/error.svg")
                    layer {
                        effect: ColorOverlay {
                            color: appWindow.theme.errorMessage
                        }
                        enabled: true
                    }
                }
                BaseLabel {
                    Layout.fillWidth: true
                    clip: true
                    elide: Text.ElideRight
                    text: downloadsItemTools.errorMessage
                    color: appWindow.theme.errorMessage
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 14
                    font.weight: Font.Light
                }
            }

            Column {
                id: fakeTable
                property int columnWidth: calcColumnWidth()
                spacing: 7

                Row {
                    visible: downloadsItemTools.state.length > 0
                    BaseLabel {
                        width: fakeTable.columnWidth
                        text: qsTr("State") + ":" + App.loc.emptyString
                    }
                    BaseLabel {
                        text: downloadsItemTools.state
                    }
                }
                Row {
                    BaseLabel {
                        id: label1
                        width: fakeTable.columnWidth
                        text: (downloadsItemTools.finished ? qsTr("Total size:") : qsTr("Downloaded:")) + App.loc.emptyString
                    }
                    BaseLabel {
                        text: (downloadsItemTools.finished || downloadsItemTools.unknownFileSize ? JsTools.sizeUtils.bytesAsText(downloadsItemTools.selectedBytesDownloaded) :
                              qsTr("%1 of %2").arg(JsTools.sizeUtils.bytesAsText(downloadsItemTools.selectedBytesDownloaded)).arg(JsTools.sizeUtils.bytesAsText(downloadsItemTools.selectedSize))) + App.loc.emptyString
                    }
                }
                Row {
                    visible: downloadsItemTools.canUpload
                    BaseLabel {
                        width: fakeTable.columnWidth
                        text: qsTr("Uploaded") + ":" + App.loc.emptyString
                    }
                    BaseLabel {
                        text: App.bytesAsText(downloadsItemTools.bytesUploaded) +
                              " (" + qsTr("ratio") + ": " + downloadsItemTools.ratioText + ")" +
                              App.loc.emptyString
                    }
                }
                Row {
                    visible: !downloadsItemTools.finished || downloadsItemTools.showDownloadSpeed
                    BaseLabel {
                        id: label2
                        width: fakeTable.columnWidth
                        text: qsTr("Download speed:") + App.loc.emptyString
                    }
                    BaseLabel {
                        property string speed: downloadsItemTools.showDownloadSpeed ?
                            App.speedAsText(downloadsItemTools.downloadSpeed) + App.loc.emptyString : "-"
                        text: speed
                    }
                }
                Row {
                    visible: !downloadsItemTools.finished || downloadsItemTools.showUploadSpeed
                    BaseLabel {
                        id: label5
                        width: fakeTable.columnWidth
                        text: qsTr("Upload speed:") + App.loc.emptyString
                    }
                    BaseLabel {
                        property string speed: downloadsItemTools.showUploadSpeed ?
                            App.speedAsText(downloadsItemTools.uploadSpeed) + App.loc.emptyString : "-"
                        text: speed
                    }
                }
                Row {
                    visible: downloadsItemTools.host
                    BaseLabel {
                        id: label3
                        width: fakeTable.columnWidth
                        text: qsTr("Domain:") + App.loc.emptyString
                    }
                    BaseLabel {
                        text: downloadsItemTools.host
                    }
                }
                Row {
                    BaseLabel {
                        id: label4
                        width: fakeTable.columnWidth
                        text: qsTr("Added:") + App.loc.emptyString
                    }
                    BaseLabel {
                        text: App.loc.dateOrTimeToString(downloadsItemTools.added, false) + App.loc.emptyString
                    }
                }

                function calcColumnWidth() {
                    return Math.max(
                                label1.implicitWidth,
                                label2.implicitWidth,
                                label3.implicitWidth,
                                label4.implicitWidth
                            ) + 5
                }
            }

            Rectangle {
                visible: downloadsItemTools.destinationPath
                width: parent.width
                height: folderPath.height
                color: "transparent"

                Image {
                    id: folderImg
                    width: folderPath.height
                    height: folderPath.height
                    anchors.verticalCenter: parent.verticalCenter
                    fillMode: Image.PreserveAspectFit
                    source: App.features.hasFeature(AppFeatures.OpenFolder) ? "../../images/mobile/open_folder.svg" :
                                                                              "../../images/mobile/folder.svg"
                    layer {
                        effect: ColorOverlay {
                            color: appWindow.theme.foreground
                        }
                        enabled: true
                    }
                    MouseArea
                    {
                        anchors.fill: parent
                        enabled: App.features.hasFeature(AppFeatures.OpenFolder)
                        onClicked: App.downloads.mgr.openDownloadFolder(downloadsItemTools.itemId, -1)
                    }
                }

                BaseLabel {
                    id: folderPath
                    anchors.leftMargin: 5
                    anchors.left: folderImg.right
                    anchors.right: parent.right
                    clip: true
                    elide: Text.ElideMiddle
                    text: downloadsItemTools.destinationPath
                }
            }

            BaseLabel {
                visible: downloadsItemTools.webPageUrl.length > 0 && downloadsItemTools.webPageUrl != downloadsItemTools.resourceUrl
                clip: true
                elide: Text.ElideMiddle
                width: parent.width
                text: "<a href='" + downloadsItemTools.webPageUrl + "'>" + downloadsItemTools.webPageUrl + "</a>"
                color: linkColor
                onLinkActivated: App.openDownloadUrl(downloadsItemTools.webPageUrl)
            }

            BaseLabel {
                clip: true
                elide: Text.ElideMiddle
                width: parent.width
                text: "<a href='" + downloadsItemTools.resourceUrl + "'>" + downloadsItemTools.resourceUrl + "</a>"
                color: linkColor
                onLinkActivated: App.openDownloadUrl(downloadsItemTools.resourceUrl)
            }

            /*
            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right

                height: logButton.height

                SchedulerButton {
                    id: schedulerButton
                    anchors.left: parent.left
                    anchors.leftMargin: -18
                    anchors.top: parent.top
                    anchors.topMargin: -12
                    onClicked: stackView.push(Qt.resolvedUrl("../../mobile/Sheduler.qml"))
                }

                Button {
                    id: logButton
                    anchors.right: parent.right
                    anchors.top: parent.top
                    text: qsTr("Log") + App.loc.emptyString
                    flat: true
                    font.capitalization: Font.Capitalize
                    padding: 8

                    Material.background: "#EEEEEE"
    /*
                    background: Rectangle {
                        //color: Material.hintTextColor
                        opacity: 0.5
                        height: 24
                        implicitHeight: 24
                    }
    *

                    onClicked: stackView.push("LogPage.qml");
                }
            }
            */
        }

        Rectangle {
            id: progessRect
            visible: !downloadsItemTools.finished
            width: parent.width
            anchors.top: topColumn.bottom
            anchors.topMargin: 10
            anchors.bottom: parent.bottom
            color: "transparent"

            BaseLabel {
                id: progressLabel
                clip: true
                elide: Text.ElideMiddle
                text: qsTr("Progress:") + App.loc.emptyString
            }

            Rectangle {
                id: progressWraper
                color: "transparent"
                width: parent.width
                anchors.top: progressLabel.bottom
                anchors.bottom: parent.bottom
                anchors.topMargin: 5
                Loader {
                   id: myLoader
                   anchors.fill: parent
                   asynchronous: true
                   sourceComponent: ProgressMap {
                        downloadId: downloadsItemTools.itemId
                   }

                   property int heightOccupiedAbove: topColumn.height +
                        progressLabel.height + progressWraper.anchors.topMargin + 5 + 10
                   property int progressAvailHeight: root.height - myLoader.heightOccupiedAbove
                   property int progressHeightMin: 100
                   property int progressHeight: (myLoader.progressAvailHeight > myLoader.progressHeightMin) ?
                        myLoader.progressAvailHeight : myLoader.progressHeightMin
                }
            }


        }
    }
}
