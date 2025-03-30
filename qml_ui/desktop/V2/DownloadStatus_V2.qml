import QtQuick
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.abstractdownloadsui
import "../BaseElements"
import "../BaseElements/V2"
import "../../common/Tools"

Item
{
    id: root

    readonly property bool running: downloadsItemTools.indicatorInProgress
    readonly property bool unkSize: downloadsItemTools.infinityIndicator

    readonly property string runningStatusText:
        (downloadsItemTools.performingLo ? downloadsItemTools.loUiText :
        downloadsItemTools.inCheckingFiles ? qsTr('Checking files') :
        downloadsItemTools.inMergingFiles ? qsTr('Merging media streams') :
        downloadsItemTools.inWaitingForMetadata ? qsTr("Requesting info") : "") + App.loc.emptyString

    readonly property bool absolutelyFinished: downloadsItemTools.finished && !runningStatusText

    readonly property string n_a: qsTr("n/a") + App.loc.emptyString

    readonly property int eta: running && !unkSize ?
                                   downloadsItemTools.estimatedTimeSec :
                                   -1

    implicitWidth: p.visible ? p.implicitWidth : e.implicitWidth
    implicitHeight: p.visible ? p.implicitHeight : e.implicitHeight

    Error_V2
    {
        id: e
        visible: downloadsItemTools.inError && !runningStatusText
        error: downloadsItemTools.error
        anchors.fill: parent
    }

    RowLayout
    {
        id: p

        visible: !e.visible

        anchors.fill: parent

        spacing: 8*appWindow.zoom

        SlimProgressBar_V2
        {
            visible: !absolutelyFinished
            value: downloadsItemTools.progress
            indeterminate: unkSize
            running: root.running
            bgColor: appWindow.theme_v2.bg300
            progressColor: appWindow.theme_v2.primary
            Layout.fillWidth: true
            Layout.preferredHeight: 16*appWindow.zoom
            radius: 4*appWindow.zoom
        }

        BaseLabel
        {
            visible: !absolutelyFinished && text
            text: unkSize ? n_a : downloadsItemTools.progress + "%"
        }

        BaseLabel
        {
            visible: text
            text: {
                if (runningStatusText)
                    return runningStatusText;

                if (downloadsItemTools.inQueue)
                    return qsTr("Queued") + App.loc.emptyString;

                if (downloadsItemTools.finished)
                    return qsTr("Completed") + App.loc.emptyString;

                return "";
            }
        }

        BaseLabel
        {
            visible: text
            text: root.eta >= 0 ?
                      "(" + JsTools.timeUtils.remainingTime(root.eta) + ")" + App.loc.emptyString :
                      ""
        }
    }
}
