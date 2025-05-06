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

    property bool highlighted: false

    readonly property bool containsMouse: error.containsMouse ||
                                          statusText.containsMouse ||
                                          maProgress.containsMouse

    readonly property bool running: downloadsItemTools.indicatorInProgress
    readonly property bool unkSize: downloadsItemTools.infinityIndicator

    readonly property string runningStatusText:
        (downloadsItemTools.performingLo ? downloadsItemTools.loUiText :
        downloadsItemTools.inCheckingFiles ? qsTr('Checking files') :
        downloadsItemTools.inMergingFiles ? qsTr('Merging media streams') :
        downloadsItemTools.inWaitingForMetadata ? qsTr("Requesting info") : "") + App.loc.emptyString

    readonly property string n_a: qsTr("n/a") + App.loc.emptyString

    implicitWidth: meat.implicitWidth
    implicitHeight: meat.implicitHeight

    RowLayout
    {
        id: meat

        anchors.fill: parent

        spacing: 8*appWindow.zoom

        Error_V2
        {
            id: error
            visible: downloadsItemTools.inError && !runningStatusText
            error: downloadsItemTools.error
            Layout.fillWidth: true
        }

        BaseLabelWithTooltip
        {
            id: statusText
            visible: text && !error.visible
            text: {
                if (runningStatusText)
                    return runningStatusText;

                if (downloadsItemTools.inQueue)
                    return qsTr("Queued") + App.loc.emptyString;

                if (downloadsItemTools.finished)
                    return qsTr("Completed") + App.loc.emptyString;

                return "";
            }
            color: runningStatusText ? appWindow.theme_v2.primary :
                   downloadsItemTools.inQueue ? appWindow.theme_v2.bg1000 :
                   appWindow.theme_v2.bg500
            elide: Qt.ElideRight
            Layout.fillWidth: true
        }

        ToolbarFlatButton_V2
        {
            visible: statusText.visible &&
                     downloadsItemTools.performingLo &&
                     downloadsItemTools.loAbortable
            iconSource: Qt.resolvedUrl("abort_lo.svg")
            iconColor: appWindow.theme_v2.bg1000
            bgColor: appWindow.theme_v2.bg400
            radius: 4
            leftPadding: 4*appWindow.zoom
            rightPadding: leftPadding
            topPadding: leftPadding
            bottomPadding: leftPadding
            onClicked: downloadsItemTools.abortLo()
        }

        SlimProgressBar_V2
        {
            visible: !error.visible && !statusText.visible
            value: downloadsItemTools.progress
            indeterminate: unkSize
            running: root.running
            bgColor: highlighted ?
                         appWindow.theme_v2.bg100 :
                         (running ? appWindow.theme_v2.bg500 : appWindow.theme_v2.bg300)
            progressColor: running ? appWindow.theme_v2.primary :
                           downloadsItemTools.finished ? appWindow.theme_v2.bg500 :
                           appWindow.theme_v2.bg600
            Layout.fillWidth: true
            Layout.preferredHeight: 12*appWindow.zoom
            radius: 4*appWindow.zoom
            MouseArea
            {
                id: maProgress
                anchors.fill: parent
                hoverEnabled: true
                acceptedButtons: Qt.NoButton
            }
        }

        Item
        {
            implicitWidth: Math.max(defaultFontMetrics.advanceWidth("99%"),
                                    defaultFontMetrics.advanceWidth(n_a)) +
                           defaultFontMetrics.font.pixelSize*0
            Layout.fillHeight: true

            BaseLabel
            {
                id: progressText
                visible: (!downloadsItemTools.finished && !downloadsItemTools.canBeRestarted) ||
                         downloadsItemTools.performingLo
                text: unkSize ? n_a : downloadsItemTools.progress + "%"
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
            }

            SvgImage_V2
            {
                id: restartBtn
                visible: !progressText.visible &&
                         downloadsItemTools.canBeRestarted
                source: Qt.resolvedUrl("repeat.svg")
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                MouseAreaWithHand_V2 {
                    anchors.fill: parent
                    onClicked: App.downloads.mgr.restartDownload([model.id])
                }
            }

            ToolbarFlatButton_V2
            {
                visible: !progressText.visible &&
                         !restartBtn.visible &&
                         downloadsItemTools.finished
                iconSource: Qt.resolvedUrl("menu_dots.svg")
                iconColor: appWindow.theme_v2.bg1000
                bgColor: "transparent"
                leftPadding: 4*appWindow.zoom
                rightPadding: leftPadding
                topPadding: leftPadding
                bottomPadding: leftPadding
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                onClicked: {
                    var id = downloadsItemTools.itemId;
                    var item = downloadsItemTools.item;

                    var component = Qt.createComponent(downloadsViewTools.showingDownloadsWithMissingFilesOnly ?
                                                           "../DownloadsViewItemContextMenu2.qml" :
                                                           "../DownloadsViewItemContextMenu.qml");
                    var menu = component.createObject(root, {
                                                          "modelIds": [id],
                                                          "finished": downloadsItemTools.finished,
                                                          "filesCount": item.filesCount,
                                                          "canChangeUrl": (item.flags & AbstractDownloadsUi.AllowChangeSourceUrl) != 0,
                                                          "supportsMirror": (item.flags & AbstractDownloadsUi.SupportsMirrors) != 0,
                                                          "batchDownload": downloadsItemTools.hasChildDownloads,
                                                          "endlessStream": (item.flags & AbstractDownloadsUi.EndlessStream) != 0,
                                                          "hideDisabledItems": true
                                                      });
                    menu.open();
                    menu.aboutToHide.connect(function(){menu.destroy();});
                }
            }
        }
    }
}
