import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.4
import "../qt5compat"
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.appfeatures 1.0
import "../common/Tools"

import "../common"
import "BaseElements"

Rectangle {
    id: fileinfo_and_downloadstatus

    height: 80
    color: "transparent"

    signal circleAnimationStart(real xPosition, real yPosition)
    signal circleAnimationStop()

    function clickMouseArea(mouse) {
        fileinfo_and_downloadstatus_mouse_area.clicked(mouse)
    }

    function pressAndHoldMouseArea(mouse) {
        fileinfo_and_downloadstatus_mouse_area.pressAndHold(mouse)
    }

    MouseArea
    {
        id: fileinfo_and_downloadstatus_mouse_area
        anchors.fill: parent
        onClicked: {
            if (!appWindow.selectMode) {
                if (!App.rc.client.active && model.finished && !downloadsItemTools.isFolder) {
                    App.downloads.mgr.openDownload(downloadsItemTools.itemId, -1)
                } else if (!App.rc.client.active && model.finished && App.features.hasFeature(AppFeatures.OpenFolder) && downloadsItemTools.isFolder) {
                    App.downloads.mgr.openDownloadFolder(downloadsItemTools.itemId, -1);
                } else {
                    stackView.waPush(Qt.resolvedUrl("DownloadItemPage/Page.qml"), {downloadItemId:downloadsItemTools.itemId});
                }
            } else {
                if (model.checked) {
                    model.checked = false;
                    root.downloadUnselected()
                } else {
                    model.checked = true;
                    root.downloadSelected(downloadsItemTools.itemId);
                }
            }
        }

        onPressAndHold: function (mouse) {
            //circleAnimationStart(mouse.x, mouse.y);
            model.checked = true;
            root.downloadSelected(downloadsItemTools.itemId);
        }

        onPressed: function (mouse) {
            circleAnimationStart(mouse.x, mouse.y);
        }

        onReleased: {} //circleAnimationStop();
        onPositionChanged: {} //circleAnimationStop();
    }

    state: appWindow.smallScreen ? "smallScreenDesign" : "bigScreenDesign"

    states: [
        State {
            name: "smallScreenDesign"
            StateChangeScript {
                script: {
                    infoBlock.width = undefined
                    infoBlock.anchors.verticalCenter = undefined
                    infoBlock.anchors.bottom = fileinfo_and_downloadstatus.bottom
                    infoBlock.anchors.left = fileinfo_and_downloadstatus.left
                    infoBlock.anchors.right = fileinfo_and_downloadstatus.right
                    infoBlock.height = 50

                    titleLabel.anchors.verticalCenter = undefined
                    titleLabel.anchors.top = fileinfo_and_downloadstatus.top
                    titleLabel.anchors.topMargin = 10
                    titleLabel.anchors.left = fileinfo_and_downloadstatus.left
                    titleLabel.anchors.right = infoBlock.right
                    titleLabel.anchors.rightMargin = 0
                }
            }
        },
        State {
            name: "bigScreenDesign"
            StateChangeScript {
                script: {
                    infoBlock.anchors.bottom = undefined
                    infoBlock.anchors.left = undefined
                    infoBlock.anchors.verticalCenter = fileinfo_and_downloadstatus.verticalCenter
                    infoBlock.anchors.right = fileinfo_and_downloadstatus.right
                    infoBlock.width = 230
                    infoBlock.height = 50

                    titleLabel.anchors.topMargin = undefined
                    titleLabel.anchors.top = undefined
                    titleLabel.anchors.verticalCenter = fileinfo_and_downloadstatus.verticalCenter
                    titleLabel.anchors.left = fileinfo_and_downloadstatus.left
                    titleLabel.anchors.right = infoBlock.left
                    titleLabel.anchors.rightMargin = 20
                }
            }
        }
    ]

    //file name
    Label {
        id: titleLabel
        text: downloadsItemTools.tplTitle
        anchors.left: parent.left
        anchors.leftMargin: 5
        horizontalAlignment: Text.AlignLeft
        elide: Text.ElideRight
        font.pixelSize: 16
        font.weight: Font.Medium
        opacity: downloadsItemTools.itemOpacity
    }

    Rectangle {
        id: infoBlock
        color: "transparent"
        anchors.leftMargin: 5

        //speed
        Row {
            id: speed
            spacing: 3
            anchors.left: !model.finished? parent.left : undefined
            anchors.right: model.finished ? progressbar_rect.right : undefined
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 27

            Rectangle {
                id: downloadSpeed
                color: "transparent"
                width: downloadSpeedText.width + downArrow.width
                height: downloadSpeedText.height
                visible: downloadsItemTools.showDownloadSpeed

                Image {
                    id: downArrow
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    source: Qt.resolvedUrl("../images/mobile/arrow_down.svg")
                    sourceSize.width: 10
                    sourceSize.height: 10
                    layer {
                        effect: ColorOverlay {
                            color: appWindow.theme.foreground
                        }
                        enabled: true
                    }
                }

                Label {
                    id: downloadSpeedText
                    anchors.left: downArrow.right
                    anchors.verticalCenter: parent.verticalCenter
                    horizontalAlignment: Text.AlignRight
                    text: App.speedAsText(downloadsItemTools.downloadSpeed) + App.loc.emptyString
                    font.pixelSize: 12
                    font.weight: Font.Light
                }
            }

            Rectangle {
                width: 1
                height: downloadSpeedText.height
                color: appWindow.theme.border
                visible: downloadSpeed.visible && uploadSpeed.visible
            }

            Rectangle {
                id: uploadSpeed
                color: "transparent"
                width: uploadSpeedText.width + upArrow.width
                height: uploadSpeedText.height
                visible: downloadsItemTools.showUploadSpeed

                Image {
                    id: upArrow
                    anchors.left: uploadSpeedText.right
                    anchors.verticalCenter: parent.verticalCenter
                    source: Qt.resolvedUrl("../images/mobile/arrow_up.svg")
                    sourceSize.width: 10
                    sourceSize.height: 10
                    layer {
                        effect: ColorOverlay {
                            color: appWindow.theme.foreground
                        }
                        enabled: true
                    }
                }

                Label {
                    id: uploadSpeedText
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    horizontalAlignment: Text.AlignRight
                    text: App.speedAsText(downloadsItemTools.uploadSpeed) + App.loc.emptyString
                    font.pixelSize: 12
                    font.weight: Font.Light
                }
            }
        }

        Row {
            id: complete_message
            visible: !downloadsItemTools.inError && model.finished && !progressbar_rect.visible
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 29
            width: parent.width - progressbar_rect.width - 5
            height: 12
            spacing: 4
            Image {
                y: 2
                sourceSize.width: 12
                sourceSize.height: 12
                source: Qt.resolvedUrl("../images/mobile/checkbox.svg")
                layer {
                    effect: ColorOverlay {
                        color: appWindow.theme.foreground
                    }
                    enabled: true
                }
            }
            Label
            {
                text: qsTr("Download complete") + App.loc.emptyString
                horizontalAlignment: Text.AlignLeft
                font.pixelSize: 12
                font.weight: Font.Light
                elide: Text.ElideRight
                clip: true
            }
        }

        // Error message
        Row {
            id: error_message
            visible: downloadsItemTools.inError
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20
            width: parent.width - progressbar_rect.width - 5
            height: 21
            spacing: 4
            Image {
                id: img
                sourceSize.width: 16
                sourceSize.height: 16
                source: Qt.resolvedUrl("../images/mobile/error.svg")
                layer {
                    effect: ColorOverlay {
                        color: appWindow.theme.errorMessage
                    }
                    enabled: true
                }
            }
            Label
            {
                text: downloadsItemTools.errorMessage
                horizontalAlignment: Text.AlignLeft
                color: appWindow.theme.errorMessage
                font.pixelSize: 12
                font.weight: Font.Light
                elide: Text.ElideRight
                clip: true
            }
        }

        // Download size
        Label {
            id: size_or_pause
            text: (model.finished ?
                       (model.selectedSize !== -1 ? App.bytesAsText(model.selectedSize) : "") :
                       App.bytesProgressAsText(model.selectedBytesDownloaded, model.selectedSize, false)) + App.loc.emptyString
            visible: model.selectedSize !== -1
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 5
            font.pixelSize: 12
            font.weight: Font.Light
        }

        // time left
        Label {
            id: time_left
            visible: (!model.finished && !downloadsItemTools.inError) || downloadsItemTools.performingLo
            anchors.right: progressbar_rect.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 27
            font.pixelSize: 12
            font.weight: Font.Light
            property string estimatedtime: JsTools.timeUtils.remainingTime(downloadsItemTools.estimatedTimeSec)

            text: (downloadsItemTools.performingLo ? downloadsItemTools.loUiTextWithProgress :
                 downloadsItemTools.inCheckingFiles ? qsTr('Checking files...') :
                 downloadsItemTools.inMergingFiles ? qsTr('Merging media streams...') :
                 downloadsItemTools.inWaitingForMetadata ? qsTr("Requesting info...") :
                 downloadsItemTools.inQueue ? qsTr("Queued") :
                 downloadsItemTools.inPause ? qsTr("Paused") :
                 downloadsItemTools.inUnknownFileSize ? qsTr("Unknown file size") :
                 downloadsItemTools.indicatorInProgress && time_left.estimatedtime.length > 0 ? /*qsTr("%1 left").arg(*/JsTools.timeUtils.remainingTime(downloadsItemTools.estimatedTimeSec)/*)*/ :
                 "") + App.loc.emptyString
        }

        //progress
        ProgressIndicator {
            id: progressbar_rect
            visible: (!model.finished && model.selectedSize !== -1) || downloadsItemTools.performingLo
            anchors.right: parent.right
            anchors.rightMargin: 5
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 5
            progress: downloadsItemTools.progress
            infinityIndicator: downloadsItemTools.infinityIndicator
            inProgress: downloadsItemTools.indicatorInProgress
            progressColor: downloadsItemTools.indicatorInProgress ? appWindow.theme.progressRunning :
                           (downloadsItemTools.inError ? appWindow.theme.progressError :
                           (model.finished ? appWindow.theme.progressDone : appWindow.theme.progressPaused))
        }
    }

    Connections {
        target: downloadsItemTools
        onFinishedChanged: {
            if (model.finished) {
                speed.anchors.left = undefined
                speed.anchors.right = progressbar_rect.right
            } else {
                speed.anchors.left = infoBlock.left
                speed.anchors.right = undefined
            }
        }
    }
}
