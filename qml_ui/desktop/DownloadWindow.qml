import QtQml 2.12
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12
import "../common"
import "../common/Tools"
import "./BaseElements"
import CppControls 1.0 as CppControls
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.abstractdownloadsui 1.0
import org.freedownloadmanager.fdm.appfeatures 1.0

ApplicationWindow
{
    id: root

    property double downloadId: -1
    property var theme: appWindow.theme

    //////////////////////////////////////////////////////////////////
    //TODO: move the color properties to themes
    readonly property color goodStateColor: "#007700"
    readonly property color badStateColor: "#770000"
    readonly property color warningStateColor: "#777700"
    //////////////////////////////////////////////////////////////////

    LayoutMirroring.enabled: appWindow.LayoutMirroring.enabled
    LayoutMirroring.childrenInherit: appWindow.LayoutMirroring.childrenInherit

    width:  content.prefWidth
    height: content.prefHeight

    visible: true

    palette.highlight: theme.textHighlight
    palette.windowText: theme.foreground
    palette.window: theme.background
    palette.base: theme.background
    palette.text: theme.foreground

    //flags: Qt.Window | Qt.WindowTitleHint | Qt.WindowMinMaxButtonsHint | Qt.WindowCloseButtonHint

    //: [50%] - myfile.txt
    title: downloadsItemTools.progress !== -1 ?
               qsTr("[%1%] - %2").arg(downloadsItemTools.progress).arg(downloadsItemTools.title) + App.loc.emptyString :
               downloadsItemTools.title

    Component.onCompleted: {
        setX(Screen.width / 2 - width / 2);
        setY(Screen.height / 2 - height / 2);
    }

    CppControls.WindowProgress
    {
        progress : downloadsItemTools.progress
    }

    QtObject
    {
        id: d
        // Qt bug workaround: complex expression is not working
        // so we devide it here into the several properties
        property bool isResumeSupported: downloadsItemTools.resumeSupport == AbstractDownloadsUi.DownloadResumeSupportPresent
        property bool isResumeNotSupported: downloadsItemTools.resumeSupport == AbstractDownloadsUi.DownloadResumeSupportAbsent
    }

    ColumnLayout
    {
        id: content

        readonly property int prefWidth: Math.max(closeWhenStopped.implicitWidth + 50*appWindow.zoom,
                                                  bottomButtons.implicitWidth + 50*appWindow.zoom,
                                                  500*appWindow.zoom)
        readonly property int prefHeight: implicitHeight + 15*appWindow.zoom
        readonly property int myMargins: 5*appWindow.zoom

        x: myMargins
        width: parent.width - myMargins*2
        y: myMargins
        height: (downloadsItemTools.unknownFileSize ? prefHeight : parent.height) - myMargins*2

        GridLayout
        {
            columns: 2
            Layout.leftMargin: qtbug.leftMargin(6*appWindow.zoom, 0)
            Layout.rightMargin: qtbug.rightMargin(6*appWindow.zoom, 0)

            BaseLabel {
                visible: downloadsItemTools.needToShowWebPageUrl
                text: qsTr("Web page:") + App.loc.emptyString
            }
            BaseLabel {
                id: webPageUrl
                visible: downloadsItemTools.needToShowWebPageUrl
                text: "<a href='" + downloadsItemTools.webPageUrl + "'>" + downloadsItemTools.webPageUrl + "</a>"
                elide: Text.ElideMiddle
                Layout.fillWidth: true
                color: linkColor
                onLinkActivated: App.openDownloadUrl(downloadsItemTools.webPageUrl)
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    acceptedButtons: Qt.RightButton
                    onClicked: function (mouse) {showMenu(parent, mouse, downloadsItemTools.webPageUrl);}
                    BaseToolTip {
                        text: downloadsItemTools.webPageUrl
                        visible: parent.containsMouse && webPageUrl.truncated
                        fontSize: 11*appWindow.fontZoom
                    }
                }
            }

            BaseLabel {
                visible: downloadsItemTools.needToShowResourceUrl
                text: qsTr("Resource URL:") + App.loc.emptyString
            }
            BaseLabel {
                id: resourceUrl
                visible: downloadsItemTools.needToShowResourceUrl
                text: "<a href='" + downloadsItemTools.resourceUrl + "'>" + downloadsItemTools.resourceUrl + "</a>"
                elide: Text.ElideMiddle
                Layout.fillWidth: true
                color: linkColor
                onLinkActivated: App.openDownloadUrl(downloadsItemTools.resourceUrl)
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    acceptedButtons: Qt.RightButton
                    onClicked: function (mouse) {showMenu(parent, mouse, downloadsItemTools.resourceUrl);}
                    BaseToolTip {
                        text: downloadsItemTools.resourceUrl
                        visible: parent.containsMouse && resourceUrl.truncated
                        fontSize: 11*appWindow.fontZoom
                    }
                }
            }

            BaseLabel { text: qsTr("Saved in") + ':' + App.loc.emptyString }
            Row {
                Layout.fillWidth: true

                Rectangle {
                    visible: downloadsItemTools.destinationPath
                    width: 14*appWindow.zoom
                    height: 18*appWindow.zoom
                    clip: true
                    color: "transparent"
                    anchors.verticalCenter: parent.verticalCenter
                    WaSvgImage {
                        source: appWindow.theme.elementsIcons
                        zoom: appWindow.zoom
                        x: -1*zoom
                        y: -329*zoom
                    }
                    MouseArea {
                        anchors.fill: parent
                        visible: App.features.hasFeature(AppFeatures.OpenFolder) && !App.rc.client.active
                        cursorShape: Qt.PointingHandCursor
                        onClicked: App.downloads.mgr.openDownloadFolder(downloadsItemTools.itemId, -1)
                    }
                }

                Item {
                    width: 2*appWindow.zoom
                    height: 1
                }

                ElidedLabelWithTooltip {
                    id: savedIn
                    sourceText: downloadsItemTools.tplPathAndTitle2
                    width: parent.width - 18*appWindow.zoom - parent.spacing
                }
            }

            BaseLabel {
                visible: !downloadsItemTools.unknownFileSize
                text: qsTr("File size") + ':' + App.loc.emptyString
            }
            BaseLabel {
                visible: !downloadsItemTools.unknownFileSize
                text: App.bytesAsText(downloadsItemTools.selectedSize) + App.loc.emptyString
            }

            BaseLabel { id: widest1stColumnItem; text: qsTr("Resume support") + ':' + App.loc.emptyString }
            BaseLabel {
                text: {
                    d.isResumeSupported ?
                                qsTr("Yes") + App.loc.emptyString :
                                d.isResumeNotSupported ?
                                    qsTr("No") + App.loc.emptyString :
                                    qsTr("Unknown") + App.loc.emptyString
                }
                color: d.isResumeSupported ? goodStateColor : d.isResumeNotSupported ? badStateColor : warningStateColor
            }
        }

        CppControls.ProgressMap
        {
            visible: !downloadsItemTools.unknownFileSize && !downloadsItemTools.hasChildDownloads
            property var mapObj: App.downloads.infos.info(downloadId).progressMap(columnsCount*rowsCount)
            map: mapObj.map
            filledSquareBorderColor: theme.progressMapFillBorder
            filledSquareColor: theme.progressMapFillBackground
            emptySquareBorderColor: theme.progressMapClearBorder
            emptySquareColor: theme.background
            squareSize: 8*appWindow.zoom
            squareSpacing: 3*appWindow.zoom
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumHeight: 70*appWindow.zoom
        }

        GridLayout
        {
            columns: 2
            Layout.leftMargin: qtbug.leftMargin(6*appWindow.zoom, 0)
            Layout.rightMargin: qtbug.rightMargin(6*appWindow.zoom, 0)

            BaseLabel { text: qsTr("Downloaded") + ':' + App.loc.emptyString; Layout.preferredWidth: widest1stColumnItem.width }
            BaseLabel {
                text: {
                    (downloadsItemTools.progress !== -1 ?
                                //: 50% [200 MB]
                                qsTr("%1% [%2]").arg(downloadsItemTools.progress.toString()).arg(App.bytesAsText(downloadsItemTools.selectedBytesDownloaded)) + App.loc.emptyString :
                                (downloadsItemTools.finalDownload ? App.bytesAsText(downloadsItemTools.selectedBytesDownloaded) : "")) + App.loc.emptyString
                }
            }

            BaseLabel {
                text: qsTr("Speed") + ':' + App.loc.emptyString
                visible: !downloadsItemTools.finished
            }
            BaseLabel {
                text: downloadsItemTools.showDownloadSpeed ? App.speedAsText(downloadsItemTools.downloadSpeed) + App.loc.emptyString : ""
                visible: !downloadsItemTools.finished
            }

            BaseLabel {
                text: qsTr("Time remaining") + ':' + App.loc.emptyString
                visible: !downloadsItemTools.finished && !downloadsItemTools.unknownFileSize
            }
            BaseLabel {
                text: downloadsItemTools.indicatorInProgress && !downloadsItemTools.unknownFileSize && !downloadsItemTools.inCheckingFiles && !downloadsItemTools.inMergingFiles && !downloadsItemTools.performingLo ?
                          JsTools.timeUtils.remainingTime(downloadsItemTools.estimatedTimeSec) : ""
                visible: !downloadsItemTools.finished && !downloadsItemTools.unknownFileSize
            }
        }

        BaseCheckBox
        {
            id: launchWhenFinished
            text: qsTr("Open download when it is completed") + App.loc.emptyString
        }

        BaseCheckBox
        {
            id: closeWhenStopped
            text: qsTr("Close this window when the download is completed or stopped") + App.loc.emptyString
            checked: true
        }

        RowLayout
        {
            id: bottomButtons

            Layout.alignment: Qt.AlignRight

            CustomButton
            {
                text: qsTr("Hide") + App.loc.emptyString
                onClicked: root.hide()
            }

            CustomButton
            {
                visible: !App.rc.client.active
                text: qsTr("Show In Folder") + App.loc.emptyString
                onClicked: App.downloads.mgr.openDownloadFolder(downloadId, -1)
            }

            CustomButton
            {
                visible: !App.rc.client.active
                text: qsTr("Open") + App.loc.emptyString
                onClicked: launch()
                enabled: downloadsItemTools.finished
            }

            CustomButton
            {
                text: qsTr("Stop") + App.loc.emptyString
                onClicked: downloadsItemTools.stopDownload()
                visible: downloadsItemTools.running
                enabled: !downloadsItemTools.finished
            }

            CustomButton
            {
                text: qsTr("Start") + App.loc.emptyString
                onClicked: App.downloads.mgr.startDownload(downloadId, true)
                visible: !downloadsItemTools.running
                enabled: !downloadsItemTools.finished
            }
        }
    }

    DownloadsItemTools
    {
        id: downloadsItemTools
        itemId: downloadId
    }

    function isLaunchWhenFinishedChecked()
    {
        return launchWhenFinished.checked;
    }

    function isCloseWhenStoppedChecked()
    {
        return closeWhenStopped.checked;
    }

    function launch()
    {
        App.downloads.mgr.openDownload(downloadId, -1);
    }

    function showMenu(anchor, mouse, url)
    {
        var component = Qt.createComponent("BottomPanel/CopyLinkMenu.qml");
        var menu = component.createObject(anchor, {
                                              "url": url
                                          });
        menu.x = Math.round(mouse.x);
        menu.y = Math.round(mouse.y);
        menu.open();
        menu.aboutToHide.connect(function(){
            menu.destroy();
        });
    }

    //////////////////////////////////////////////////////////////////////////
    // TODO: auto-launch-when-finished functionality should be moved to core
    Connections
    {
        target: downloadsItemTools
        onFinishedChanged: {
            if (isLaunchWhenFinishedChecked())
                launch();
        }
    }
    //////////////////////////////////////////////////////////////////////////
}
