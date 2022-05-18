import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0
import "../../common/Tools"
import "../BaseElements"
import "TuneDialogElements"

BaseDialog {
    id: tuneDialog

    property int preferredWidth: downloadTools.batchDownload || filesTree.visible ? 685 : 542
    property int dialogMargins: 20
    property int dialogTitleHeight: 36

    topMargin: 20

    y: Math.round((parent.height - implicitHeight) / 2)

    property double requestId: -1
    signal doOK
    signal gotPreview(string url)
    onDoOK: accept()

    contentItem: BaseDialogItem {
        titleText: qsTr("New download") + App.loc.emptyString
        Keys.onEscapePressed: downloadTools.doReject()
        onCloseClick: downloadTools.doReject()
        spacing: 0

        height: dlgContent.implicitHeight + dialogTitleHeight

        Flickable
        {
            id: dlgContent
            Layout.fillWidth: true
            Layout.fillHeight: true
            flickableDirection: Flickable.VerticalFlick
            implicitHeight: mainLayout.implicitHeight
            contentHeight: implicitHeight
            clip: true
            boundsBehavior: Flickable.StopAtBounds
            ScrollBar.vertical: ScrollBar { visible: height < mainLayout.implicitHeight; policy: ScrollBar.AlwaysOn; }

            ColumnLayout {
                id: mainLayout

                width: dlgContent.width - 20
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 10
                spacing: 2

                Title {}

                SaveTo {
                    id: saveTo
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
                    Layout.preferredHeight: fileType.visible || batchVideoQuality.visible ? 70 : 0
                    color: "transparent"

                    FileType { id: fileType}

                    BatchVideoQuality {id: batchVideoQuality}
                }

                Subtitles {}

                AddDateToFileName {
                    id: addDate
                }

                Rectangle {//40
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40
                    color: "transparent"

                    DiskSpace {
                        saveToPath: App.fromNativeSeparators(saveTo.path)
                    }

                    SchedulerCheckbox {
                        id: schedulerCheckbox
                    }
                }

                SchedulerBlock {
                    id: schedulerBlock
                    visible: schedulerCheckbox.checked
                    Layout.preferredHeight: visible ? 84 : 0
                }

                ButtonsBlock {}
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

        open();
        forceActiveFocus();
    }

    function accept() {
        downloadTools.onFilePathTextChanged(App.fromNativeSeparators(saveTo.path));

        if (downloadTools.checkFilePath() && downloadTools.checkFileName()) {
            downloadTools.saveBatchDownloadOptions(addDate.checked, addDate.changedByUser);
            downloadTools.addDownloadFromDialog();
            schedulerBlock.complete();
            schedulerTools.doOK();
        }
    }
}
