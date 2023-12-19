import QtQuick 2.12
import QtQml 2.12
import org.freedownloadmanager.fdm 1.0

Item
{
    id: root

    signal finished()

    property double downloadId: 0
    property int fileIndex: 0
    property var newNameField
    readonly property bool hasChanges: d.newName !== d.currentName
    readonly property bool alreadyExistsError: hasNewName && d.fileExists === 1
    readonly property bool canBeRenamed: hasNewName && d.fileExists === 0
    readonly property bool hasNewName: d.newName && d.newName !== d.currentName
    readonly property alias renaming: d.renaming
    readonly property alias error: d.error

    QtObject
    {
        id: d

        property bool initializing: false
        readonly property string newName: newNameField.text.trim()
        property string currentName
        property string currentPathWoName: ""
        property int fileExists: -1 // -1: not checked yet; 0 - does not exist; 1 - exists
        property string checkingIfPathExists: ""
        property bool renaming: false
        property bool needApply: true
        property string error: ""
    }

    function initialize(downloadId, fileIndex)
    {
        d.initializing = true;

        root.downloadId = downloadId;
        root.fileIndex = fileIndex;

        let info = App.downloads.infos.info(downloadId);
        let path = info.destinationPath;
        if (!path.endsWith('/'))
            path += '/';
        path += info.fileInfo(fileIndex).path;

        d.currentName = App.tools.fileNamePart(path);
        d.currentPathWoName = App.tools.filePathPart(path);
        d.fileExists = -1;
        d.checkingIfPathExists = "";

        root.newNameField.text = d.currentName;
        let title = App.tools.fileTitlePart(d.currentName);
        if (title)
            root.newNameField.select(0, title.length);
        else
            root.newNameField.selectAll();

        d.renaming = false;
        d.needApply = false;

        d.initializing = false;
    }

    Connections
    {
        target: root.newNameField
        onTextChanged: {
            if (!d.initializing)
            {
                d.error = "";
                d.fileExists = -1;
                d.needApply = false;
                checkIfFileExistsTimer.restart();
            }
        }
        onAccepted: {
            if (!root.hasChanges)
                finished();
            else
                doOK();
        }
    }

    function doOK()
    {
        if (d.fileExists == -1)
        {
            d.needApply = true;
            return;
        }
        root.apply();
    }

    Timer
    {
        id: checkIfFileExistsTimer
        interval: 500
        repeat: false
        onTriggered: {
            if (d.currentName === d.newName)
            {
                d.fileExists = -1;
                d.checkingIfPathExists = "";
                return;
            }
            d.checkingIfPathExists = d.currentPathWoName + '/' + d.newName;
            App.filesOps.checkIfPathExists(d.checkingIfPathExists);
        }
    }

    Connections
    {
        target: App.filesOps
        onPathExistsResult: function(path, exists)
        {
            if (path === d.checkingIfPathExists)
            {
                d.fileExists = exists ? 1 : 0;
                d.checkingIfPathExists = "";
                if (d.needApply)
                {
                    d.needApply = false;
                    apply();
                }
            }
        }
    }

    function apply()
    {
        if (!root.hasChanges)
        {
            finished();
            return;
        }

        if (!root.canBeRenamed || d.renaming)
            return;

        d.renaming = true;
        d.error = "";

        App.downloads.renameFilesMgr.renameFile(
                    root.downloadId,
                    root.fileIndex,
                    d.newName);
    }

    Connections
    {
        target: App.downloads.renameFilesMgr
        onFinished: function(downloadId, error)
        {
            if (d.renaming && root.downloadId == downloadId)
            {
                d.renaming = false;
                d.error = error.displayTextLong;
                if (!error)
                    finished();
            }
        }
    }
}
