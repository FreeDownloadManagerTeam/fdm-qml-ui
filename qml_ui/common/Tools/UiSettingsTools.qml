import QtQuick 2.0
import Qt.labs.settings 1.0
import Qt.labs.folderlistmodel 2.11
import Qt.labs.platform 1.0 as QtLabs
import org.freedownloadmanager.fdm 1.0

Item {
    id: root
    property var settings: settings

    signal wasReset()

    Settings {
        id: settings
        fileName: App.appqSettingsIniFilePath()
        property int deleteButtonAction: 0 // 0: Always ask, 1: Delete files, 2: Remove only from download list
        property string theme: 'system'
        property bool compactView: false
        property int filePickerSortField: FolderListModel.Name
        property bool filePickerSortReversed: false
        property bool toggleBottomPanelByClickingOnDownload: true
        property bool hideIntegrationBanner: false
        property string lastMovePath: QtLabs.StandardPaths.writableLocation(QtLabs.StandardPaths.DownloadLocation)
        property string exportImportPath: App.tools.url(QtLabs.StandardPaths.writableLocation(QtLabs.StandardPaths.DownloadLocation)).toLocalFile()
        property string pluginsDistribsPath: App.tools.url(QtLabs.StandardPaths.writableLocation(QtLabs.StandardPaths.DownloadLocation)).toLocalFile()
        property int schedulerDaysEnabled: (1 | 1 << 1 | 1 << 2 | 1 << 3 | 1 << 4 | 1 << 5 | 1 << 6)
        property int schedulerStartTime: 6*60
        property int schedulerEndTime: 10*60
        property bool mp3ConverterConstantBitrateEnabled: true
        property int mp3ConverterConstantBitrate: 256
        property int mp3ConverterVariableMinBitrate: 220
        property int mp3ConverterVariableMaxBitrate: 260
        property string mp3ConverterDestinationDir: ""
        property string mp4ConverterDestinationDir: ""
        property string btAddTString: ""
        property bool bottomPanelOpenedUserValue: true
        property int bottomPanelHeigthUserValue: 210
        property string bottomPanelCurrentTabUserValue: "general"
        property bool browserIntroShown: false
        property bool menuMarkerShown: false
        property bool dontAskMobileDataUsage: false
        property int batchDownloadMaxUrlsCount: 100
        property bool enableStandaloneDownloadsWindows: false
        property bool reportProblemAccept: false
        property bool enableUserDefinedOrderOfDownloads: false
        property bool showSaveAsButton: false
        property bool autoHideWhenFinishedAddingDownloads: false
        property string lastRemoteBannerId
        property string lastRemoteAppId
        property string downloadsListColumns
    }

    property bool hasNonDefaultValues:
        settings.deleteButtonAction !== 0 ||
        settings.theme !== 'system' ||
        settings.compactView !== false ||
        settings.filePickerSortField != FolderListModel.Name ||
        settings.filePickerSortReversed !== false ||
        settings.toggleBottomPanelByClickingOnDownload !== true ||
        settings.hideIntegrationBanner !== false ||
        settings.batchDownloadMaxUrlsCount !== 100 ||
        settings.enableStandaloneDownloadsWindows !== false ||
        settings.enableUserDefinedOrderOfDownloads !== false ||
        settings.showSaveAsButton !== false ||
        settings.autoHideWhenFinishedAddingDownloads !== false ||
        settings.downloadsListColumns

    function resetToDefaults()
    {
        settings.deleteButtonAction = 0;
        settings.theme = 'system';
        settings.compactView = false;
        settings.filePickerSortField = FolderListModel.Name;
        settings.filePickerSortReversed = false;
        settings.toggleBottomPanelByClickingOnDownload = true;
        settings.hideIntegrationBanner = false;
        settings.batchDownloadMaxUrlsCount = 100;
        settings.enableStandaloneDownloadsWindows = false;
        settings.enableUserDefinedOrderOfDownloads = false;
        settings.showSaveAsButton = false;
        settings.autoHideWhenFinishedAddingDownloads = false;
        settings.downloadsListColumns = "";
        wasReset();
    }

    Connections {
        target: App.exportImport
        onImportFinished: {
            if (error.length == 0) {
                sync();
            }
        }
    }

    //TODO: remove me with Qt 5.13+
    function sync() {
        var component = Qt.createComponent(Qt.resolvedUrl("../../common/Tools/UiSettingsTools.qml"));
        var s = component.createObject(root, {});
        uiSettingsTools.settings.deleteButtonAction = s.settings.deleteButtonAction;
        uiSettingsTools.settings.theme = s.settings.theme;
        uiSettingsTools.settings.compactView = s.settings.compactView;
        uiSettingsTools.settings.filePickerSortField = s.settings.filePickerSortField;
        uiSettingsTools.settings.filePickerSortReversed = s.settings.filePickerSortReversed;
        uiSettingsTools.settings.toggleBottomPanelByClickingOnDownload = s.settings.toggleBottomPanelByClickingOnDownload;
        uiSettingsTools.settings.hideIntegrationBanner = s.settings.hideIntegrationBanner;
        uiSettingsTools.settings.lastMovePath = s.settings.lastMovePath;
        uiSettingsTools.settings.exportImportPath = s.settings.exportImportPath;
        uiSettingsTools.settings.pluginsDistribsPath = s.settings.pluginsDistribsPath;
        uiSettingsTools.settings.schedulerDaysEnabled = s.settings.schedulerDaysEnabled;
        uiSettingsTools.settings.schedulerStartTime = s.settings.schedulerStartTime;
        uiSettingsTools.settings.schedulerEndTime = s.settings.schedulerEndTime;
        uiSettingsTools.settings.mp3ConverterConstantBitrateEnabled = s.settings.mp3ConverterConstantBitrateEnabled;
        uiSettingsTools.settings.mp3ConverterConstantBitrate = s.settings.mp3ConverterConstantBitrate;
        uiSettingsTools.settings.mp3ConverterVariableMinBitrate = s.settings.mp3ConverterVariableMinBitrate;
        uiSettingsTools.settings.mp3ConverterVariableMaxBitrate = s.settings.mp3ConverterVariableMaxBitrate;
        uiSettingsTools.settings.mp3ConverterDestinationDir = s.settings.mp3ConverterDestinationDir;
        uiSettingsTools.settings.mp4ConverterDestinationDir = s.settings.mp4ConverterDestinationDir;
        uiSettingsTools.settings.btAddTString = s.settings.btAddTString;
        uiSettingsTools.settings.bottomPanelOpenedUserValue = s.settings.bottomPanelOpenedUserValue;
        uiSettingsTools.settings.bottomPanelHeigthUserValue = s.settings.bottomPanelHeigthUserValue;
        uiSettingsTools.settings.bottomPanelCurrentTabUserValue = s.settings.bottomPanelCurrentTabUserValue;
        uiSettingsTools.settings.browserIntroShown = s.settings.browserIntroShown;
        uiSettingsTools.settings.menuMarkerShown = s.settings.menuMarkerShown;
        uiSettingsTools.settings.dontAskMobileDataUsage = s.settings.dontAskMobileDataUsage;
        uiSettingsTools.settings.batchDownloadMaxUrlsCount = s.settings.batchDownloadMaxUrlsCount;
        uiSettingsTools.settings.enableStandaloneDownloadsWindows = s.settings.enableStandaloneDownloadsWindows;
        uiSettingsTools.settings.reportProblemAccept = s.settings.reportProblemAccept;
        uiSettingsTools.settings.enableUserDefinedOrderOfDownloads = s.settings.enableUserDefinedOrderOfDownloads;
        uiSettingsTools.settings.showSaveAsButton = s.settings.showSaveAsButton;
        uiSettingsTools.settings.autoHideWhenFinishedAddingDownloads = s.settings.autoHideWhenFinishedAddingDownloads;
        uiSettingsTools.settings.downloadsListColumns = s.settings.downloadsListColumns;
        s.destroy();
    }
}
