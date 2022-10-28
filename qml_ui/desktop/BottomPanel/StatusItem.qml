import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "../../common"
import "../../common/Tools"
import org.freedownloadmanager.fdm 1.0
import "../BaseElements"

Item
{
    height: contentItem.height

    property bool showingCompletedState: downloadsItemTools.finished && !downloadsItemTools.performingLo

    ColumnLayout {
        id: contentItem
        width: parent.width

        GridLayout
        {
            property bool smallWidth: parent.width < 400/appWindow.zoom

            width: parent.width
            visible: downloadsItemTools.showProgressIndicator
            columns: !smallWidth ? 2 : 1
            rows: smallWidth ? 1 : 2

            DownloadsItemProgressIndicator {
                Layout.preferredWidth: 230*appWindow.zoom
                small: false
                percent: downloadsItemTools.progress
                infinityIndicator: downloadsItemTools.infinityIndicator
                inProgress: downloadsItemTools.indicatorInProgress
                Layout.alignment: Qt.AlignLeft
            }

            RowLayout {
                Layout.fillWidth: true

                BaseLabel {
                    visible: downloadsItemTools.performingLo
                             || downloadsItemTools.inCheckingFiles
                             || downloadsItemTools.inMergingFiles
                             || downloadsItemTools.progress > 0 && !downloadsItemTools.unknownFileSize && !downloadsItemTools.inQueue && !downloadsItemTools.inCheckingFiles && !downloadsItemTools.inMergingFiles && !downloadsItemTools.performingLo
                    text: (downloadsItemTools.progress > 0 ? downloadsItemTools.progress : 0) + "%"
                    Layout.alignment: Qt.AlignLeft
                }

                BaseLabel {
                    visible: downloadsItemTools.indicatorInProgress && !downloadsItemTools.unknownFileSize && !downloadsItemTools.inCheckingFiles && !downloadsItemTools.inMergingFiles && !downloadsItemTools.performingLo
                    property string remainingTime: JsTools.timeUtils.remainingTime(downloadsItemTools.estimatedTimeSec)
                    text: remainingTime.length ? "(" + remainingTime + ")" : ""
                    Layout.fillWidth: true
                }

                BaseLabel {
                    text: downloadsItemTools.performingLo ? downloadsItemTools.loUiText :
                         (downloadsItemTools.inCheckingFiles ? qsTr('Checking files') :
                         (downloadsItemTools.inMergingFiles ? qsTr('Merging media streams') :
                         (downloadsItemTools.inQueue ? qsTr("Queued") :
                         (downloadsItemTools.inWaitingForMetadata ? qsTr("Requesting info") :
                         (downloadsItemTools.inUnknownFileSize ? qsTr("Unknown file size") :
                         (downloadsItemTools.inPause ? qsTr("Paused") : '')))))) + App.loc.emptyString

                    visible: text.length > 0
                    wrapMode: Label.Wrap
                    Layout.fillWidth: true
                }
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignVCenter
            spacing: 3*appWindow.zoom
            width: parent.width

            RowLayout {
                visible: showingCompletedState
                Layout.fillWidth: true
                BaseLabel {
                    text: qsTr("Completed") + App.loc.emptyString
                }
            }

            RowLayout {
                visible: downloadsItemTools.inError
                width: parent.width
                spacing: 3*appWindow.zoom
                Rectangle {
                    clip: true
                    width: 17*appWindow.zoom
                    height: 15*appWindow.zoom
                    color: "transparent"
                    WaSvgImage {
                        zoom: appWindow.zoom
                        x: -41*zoom
                        y: -269*zoom
                        source: appWindow.theme.elementsIcons
                    }
                }
                BaseLabel {
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                    text: downloadsItemTools.errorMessage
                    color: appWindow.theme.errorMessage
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }
}
