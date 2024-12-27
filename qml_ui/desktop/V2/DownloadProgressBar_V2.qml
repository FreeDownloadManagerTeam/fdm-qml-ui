import QtQuick
import org.freedownloadmanager.fdm
import "../BaseElements/V2"

ProgressBar_V2
{
    value: downloadsItemTools.progress
    indeterminate: downloadsItemTools.infinityIndicator
    running: downloadsItemTools.indicatorInProgress

    text: (downloadsItemTools.performingLo ? downloadsItemTools.loUiText :
         downloadsItemTools.inCheckingFiles ? qsTr('Checking files') :
         downloadsItemTools.inMergingFiles ? qsTr('Merging media streams') :
         downloadsItemTools.inQueue ? qsTr("Queued") :
         downloadsItemTools.inWaitingForMetadata ? qsTr("Requesting info") :
         downloadsItemTools.inPause ? qsTr("Paused") : '').toLowerCase() + App.loc.emptyString

    eta: running && !indeterminate ? downloadsItemTools.estimatedTimeSec : -1
}
