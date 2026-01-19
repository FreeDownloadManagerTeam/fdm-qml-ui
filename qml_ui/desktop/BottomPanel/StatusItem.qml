import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../common"
import "../../common/Tools"
import org.freedownloadmanager.fdm
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
            property bool smallWidth: parent.width < 400*appWindow.zoom

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

            BaseErrorLabel {
                visible: downloadsItemTools.inError
                error: downloadsItemTools.error
                shortVersion: false
            }
        }
    }
}
