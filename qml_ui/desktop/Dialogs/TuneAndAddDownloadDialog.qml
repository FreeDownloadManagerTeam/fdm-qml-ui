import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12
import org.freedownloadmanager.fdm 1.0
import "../../common/Tools"
import "../BaseElements"
import "TuneDialogElements"

BaseStandaloneCapableDialog {
    id: tuneDialog

    property int preferredWidth: Math.max(dlgContent.implicitWidth+20*appWindow.zoom, ((downloadTools.batchDownload || filesTree.visible) ? 685 : 542)*appWindow.zoom)
    property int dialogMargins: 20*appWindow.zoom
    property int dialogTitleHeight: 36*appWindow.zoom

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

    contentItem: BaseDialogItem {
        titleText: qsTr("New download") + App.loc.emptyString
        showCloseButton: !root.standalone
        Keys.onEscapePressed: downloadTools.doReject()
        onCloseClick: downloadTools.doReject()
        spacing: 0

        Flickable
        {
            id: dlgContent
            Layout.fillWidth: true
            Layout.fillHeight: true
            flickableDirection: Flickable.VerticalFlick
            implicitHeight: mainLayout.implicitHeight
            implicitWidth: mainLayout.implicitWidth
            contentHeight: implicitHeight
            clip: true
            boundsBehavior: Flickable.StopAtBounds
            ScrollBar.vertical: ScrollBar { visible: dlgContent.height < mainLayout.implicitHeight; policy: ScrollBar.AlwaysOn; }

            ColumnLayout {
                id: mainLayout

                anchors.fill: parent
                anchors.margins: 10*appWindow.zoom
                spacing: 2*appWindow.zoom

                Title {}

                SaveTo {
                    id: saveTo
                    enabled: !d.accepting
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
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: (fileType.visible || batchVideoQuality.visible) ? 70*appWindow.zoom : 0
                    color: "transparent"

                    FileType { id: fileType}

                    BatchVideoQuality {id: batchVideoQuality}
                }

                Subtitles {}

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
                        Layout.fillWidth: true
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

                ButtonsBlock {forceDisableOK: d.accepting}
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
        var downloadId = downloadTools.getNameAndPath();
        saveTo.initialization();
        videoQuality.initialization();
        schedulerTools.buildScheduler([downloadId]);
        schedulerBlock.initialization();
        filesTree.initialization(requestId);

        if (downloadTools.batchDownload) {
            downloadTools.setPreviewUrl();
            downloadsList.initialization();
        }
        d.accepting = false;

        open();
        forceActiveFocus();
    }

    function accept() {
        if (d.accepting)
            return;
        d.accepting = true;
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
