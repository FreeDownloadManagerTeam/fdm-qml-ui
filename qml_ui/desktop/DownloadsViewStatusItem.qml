/* Displays "status" column content */

import QtQuick 2.12
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "../common/Tools"
import org.freedownloadmanager.fdm 1.0
import "./BaseElements"

Item {
    property bool isEmpty: !progressBlock.visible && !completeMsg.visible && !errorBlock.visible

    signal showingCompleteMessage(bool isShowing)

    ColumnLayout {
        id: progressBlock
        visible: downloadsItemTools.showProgressIndicator
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width

        RowLayout {
            Layout.preferredWidth: parent.width

            BaseLabel {
                visible: downloadsItemTools.performingLo && appWindow.compactView
                         || downloadsItemTools.inCheckingFiles && appWindow.compactView
                         || downloadsItemTools.inMergingFiles && appWindow.compactView
                         || downloadsItemTools.progress >= 0 && !downloadsItemTools.unknownFileSize && !downloadsItemTools.inQueue && !downloadsItemTools.inCheckingFiles && !downloadsItemTools.inMergingFiles && !downloadsItemTools.performingLo
                font.pixelSize: appWindow.compactView ? 9 : 11
                text: (downloadsItemTools.performingLo && appWindow.compactView ? (downloadsItemTools.loProgress !== -1 ? downloadsItemTools.loProgress : 0) :
                      (downloadsItemTools.inCheckingFiles && appWindow.compactView ? (downloadsItemTools.checkingFilesProgress > 0 ? downloadsItemTools.checkingFilesProgress : 0) :
                      (downloadsItemTools.inMergingFiles && appWindow.compactView ? (downloadsItemTools.mergingFilesProgress > 0 ? downloadsItemTools.mergingFilesProgress : 0) :
                       downloadsItemTools.progress))) + "%"
                Layout.alignment: Qt.AlignLeft
                opacity: downloadsItemTools.itemOpacity
            }

            BaseLabel {
                id: statusMessage

                text: downloadsItemTools.performingLo ? downloadsItemTools.loUiText :
                     (downloadsItemTools.inCheckingFiles ? qsTr('Checking files') :
                     (downloadsItemTools.inMergingFiles ? qsTr('Merging media streams') :
                     (downloadsItemTools.inQueue ? qsTr("Queued") :
                     (downloadsItemTools.inWaitingForMetadata ? qsTr("Requesting info") :
                     (downloadsItemTools.inUnknownFileSize ? qsTr("Unknown file size") :
                     (downloadsItemTools.inPause ? qsTr("Paused") : '')))))) + App.loc.emptyString

                visible: text.length > 0
                font.pixelSize: appWindow.compactView ? 9 : 11
                color: appWindow.theme.foreground
                Layout.fillWidth: true
                clip: true
                elide: Text.ElideRight
                horizontalAlignment: Text.AlignRight
                padding: 0

                MouseArea {
                    enabled: parent.truncated
                    propagateComposedEvents: true
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked : function (mouse) {mouse.accepted = false;}
                    onPressed: function (mouse) {mouse.accepted = false;}

                    BaseToolTip {
                        text: statusMessage.text
                        visible: parent.containsMouse
                    }
                }
            }

            BaseLabel {
                visible: downloadsItemTools.indicatorInProgress && !downloadsItemTools.unknownFileSize && !downloadsItemTools.inCheckingFiles && !downloadsItemTools.inMergingFiles && !downloadsItemTools.performingLo
                font.pixelSize: appWindow.compactView ? 9 : 11
                text: JsTools.timeUtils.remainingTime(downloadsItemTools.estimatedTimeSec)
                Layout.alignment: Qt.AlignRight
            }
        }

        DownloadsItemProgressIndicator {
            visible: !appWindow.compactView
            Layout.fillWidth: true
            percent: downloadsItemTools.progress
            infinityIndicator: downloadsItemTools.infinityIndicator
            inProgress: downloadsItemTools.indicatorInProgress
        }
    }

    RowLayout {
        id: completeMsg
        anchors.verticalCenter: parent.verticalCenter
        visible: opacity > 0
        width: parent.width
        spacing: 3
        opacity: 0
        OpacityAnimator on opacity {
            id: completeAnimation
            from: 1;
            to: 0;
            duration: 2000
            running: false
            onStarted: showingCompleteMessage(true);
            onStopped: showingCompleteMessage(false);
        }
        Connections {
            target: App.downloads.tracker
            onDownloadFinished: {
                if (id == downloadsItemTools.itemId) {
                    completeMsg.opacity = 1;
                    completeAnimation.restart();
                }
            }
        }
        Rectangle {
            clip: true
            width: 12
            height: 15
            color: "transparent"
            Image {
                x: 0
                y: -120
                source: appWindow.theme.elementsIcons
                sourceSize.width: 93
                sourceSize.height: 456
            }
        }
        BaseLabel {
            Layout.fillWidth: true
            clip: true
            elide: Text.ElideRight
            text: qsTr("Complete") + App.loc.emptyString
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: appWindow.compactView ? 9 : 11
        }
    }

    RowLayout {
        id: errorBlock
        anchors.verticalCenter: parent.verticalCenter
        visible: downloadsItemTools.inError
        width: parent.width
        spacing: 3
        Rectangle {
            clip: true
            width: 17
            height: 15
            color: "transparent"
            Image {
                x: -41
                y: -269
                source: appWindow.theme.elementsIcons
                sourceSize.width: 93
                sourceSize.height: 456
            }
        }
        BaseLabel {
            Layout.fillWidth: true
            clip: true
            elide: Text.ElideRight
            text: downloadsItemTools.errorMessage
            color: "#bc3737"
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: appWindow.compactView ? 12 : 13

            MouseArea {
                enabled: parent.truncated
                propagateComposedEvents: true
                anchors.fill: parent
                hoverEnabled: true
                onClicked : function (mouse) {mouse.accepted = false;}
                onPressed: function (mouse) {mouse.accepted = false;}

                BaseToolTip {
                    text: downloadsItemTools.errorMessage
                    visible: parent.containsMouse
                }
            }
        }
    }
}
