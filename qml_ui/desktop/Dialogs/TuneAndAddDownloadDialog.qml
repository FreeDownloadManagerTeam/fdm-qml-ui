import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12
import org.freedownloadmanager.fdm 1.0
import "../../common/Tools"
import "../BaseElements"
import "../BaseElements/V2"
import "TuneDialogElements"

BaseStandaloneCapableDialog {
    id: tuneDialog

    readonly property int preferredWidth: Math.max(dlgContent.implicitWidth+20*appWindow.zoom,
                                                   ((downloadTools.batchDownload || filesTree.visible) ? 685 : 542)*appWindow.zoom)

    topMargin: 20*appWindow.zoom

    property double requestId: -1
    signal doOK
    signal gotPreview(string url)
    onDoOK: accept()

    height: standalone ?
                Math.min(implicitHeight, Screen.height - 200) :
                Math.min(implicitHeight, appWindow.height - 50)
    width: standalone ?
               Math.min(preferredWidth, Screen.width - 200) :
               Math.min(preferredWidth, appWindow.width - 50)

    QtObject {
        id: d
        property bool accepting: false
    }

    title: standalone ? "" : (qsTr("New download") + App.loc.emptyString)

    onCloseClick: downloadTools.doReject()

    contentItem: BaseDialogItem {
        Keys.onEscapePressed: downloadTools.doReject()
        spacing: 0

        Item
        {
            Layout.fillWidth: true
            Layout.fillHeight: true
            implicitWidth: dlgContent.implicitWidth
            implicitHeight: dlgContent.implicitHeight

            Flickable
            {
                id: dlgContent
                width: parent.width + sbar.myWrapSize
                height: parent.height
                flickableDirection: Flickable.VerticalFlick
                implicitHeight: mainLayout.implicitHeight + mainLayout.anchors.topMargin + mainLayout.anchors.bottomMargin
                implicitWidth: mainLayout.implicitWidth + mainLayout.anchors.leftMargin + mainLayout.anchors.rightMargin
                contentHeight: implicitHeight
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                ScrollBar.vertical: BaseScrollBar_V2
                {
                    id: sbar
                    visible: dlgContent.height < mainLayout.implicitHeight
                    policy: ScrollBar.AlwaysOn
                }

                ColumnLayout {
                    id: mainLayout

                    anchors.fill: parent
                    anchors.rightMargin: sbar.myWrapSize
                    spacing: 2*appWindow.zoom

                    Title {}

                    SaveTo {
                        id: saveTo
                        enabled: !d.accepting
                        Layout.fillWidth: true
                        focus: true
                    }

                    FileName {
                        id: fileName
                        saveToControl: saveTo
                    }

                    Url {}

                    FilesTree {
                        id: filesTree
                    }

                    DownloadsList {
                        id: downloadsList
                    }

                    VideoQuality {
                        id: videoQuality
                        lngFilter: language.selectedLanguage
                    }

                    LanguageSelection {
                        id: language
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: (fileType.visible || batchVideoQuality.visible || batchLanguage.visible) ? 70*appWindow.zoom : 0

                        FileType { id: fileType}

                        BatchVideoQuality {id: batchVideoQuality}

                        BatchLanguage {id: batchLanguage}
                    }

                    Item {
                        visible: subtitlesBlock.visible || addDate.visible
                        implicitHeight: 10*appWindow.zoom
                        implicitWidth: 1
                    }

                    Subtitles {
                        id: subtitlesBlock
                    }

                    Item {
                        visible: subtitlesBlock.visible && addDate.visible
                        implicitHeight: 9*appWindow.zoom
                        implicitWidth: 1
                    }

                    AddDateToFileName {
                        id: addDate
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 40*appWindow.zoom
                        spacing: 30*appWindow.zoom

                        SchedulerCheckbox {
                            id: schedulerCheckbox
                            Layout.alignment: Qt.AlignVCenter
                            xOffset: 0
                        }

                        Item {
                            Layout.fillWidth: true
                            implicitHeight: 1
                        }

                        DiskSpace {
                            saveToPath: App.fromNativeSeparators(saveTo.path)
                            Layout.alignment: Qt.AlignVCenter
                        }
                    }

                    SchedulerBlock {
                        id: schedulerBlock
                        visible: schedulerCheckbox.checked
                        Layout.fillWidth: true
                        Layout.preferredHeight: visible ? 84*appWindow.zoom : 0
                    }

                    NoResumeSupportBlock {
                        id: noResumeSupportBlock
                        Layout.topMargin: 10*appWindow.zoom
                    }

                    PlayAsap {
                        id: playAsap
                    }

                    ButtonsBlock {id: bb; forceDisableOK: d.accepting}
                }
            }
        }
    }

    BuildDownloadTools {
        id: downloadTools
        requestId: tuneDialog.requestId
        onCreateDownloadFromDialog: {
            appWindow.newDownloadAdded();
            tuneDialog.close();
        }
        onReject: {
            tuneDialog.close();
        }
        onFilePathChanged: {
            saveTo.initialization();
            fileName.init();
        }
        onFileNameChanged: {
            fileName.init();
        }
    }

    SchedulerTools {
        id: schedulerTools
        tuneAndDownloadDialog: true
    }

    onClosed: {appWindow.appWindowStateChanged();}

    function showRequestData(id)
    {
        requestId = id;
        downloadTools.resetTuneParams();
        downloadTools.batchDownload = downloadTools.isBatchDownload(requestId);
        downloadTools.resumeSupport = downloadTools.getResumeSupport(requestId);
        downloadTools.versionSelector = App.downloads.creator.resourceVersionSelector(requestId, 0);
        var downloadId = downloadTools.getNameAndPath();
        saveTo.initialization();
        language.initialization();
        videoQuality.initialization();
        schedulerTools.buildScheduler([downloadId]);
        schedulerBlock.initialization();
        filesTree.initialization(requestId);
        noResumeSupportBlock.initialization();
        playAsap.initialization();

        if (downloadTools.batchDownload) {
            downloadTools.setPreviewUrl();
            downloadsList.initialization();
        }
        d.accepting = false;

        open();
        forceActiveFocus();
    }

    function accept() {
        if (d.accepting || !bb.downloadBtnEnabled)
            return;
        d.accepting = true;
        noResumeSupportBlock.apply();
        playAsap.apply();
        downloadTools.onFilePathTextChanged(App.fromNativeSeparators(saveTo.path));
        downloadTools.checkFilePathAsync();
    }

    Connections
    {
        target: downloadTools
        onCheckFilePathFinished: {
            if (!d.accepting)
                return;
            d.accepting = false;
            if (!downloadTools.wrongFilePathWarning)
            {
                downloadTools.saveBatchDownloadOptions(addDate.checked, addDate.changedByUser);
                downloadTools.addDownloadFromDialog();
                schedulerBlock.complete();
                schedulerTools.doOK();
            }
        }
        onReject: {
            d.accepting = false;
        }
    }
}
