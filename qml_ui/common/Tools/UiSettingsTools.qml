import QtQuick
import QtCore
import Qt.labs.folderlistmodel
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.appconstants

Item {
    id: root
    property var settings: settings

    signal wasReset()

    property alias zoom: settings.zoom
    property alias zoom2: settings.zoom2
    property alias uiVersion: settings.uiVersion

    Settings {
        id: settings
        location: App.tools.urlFromLocalFile(App.appqSettingsIniFilePath()).url
        property int deleteButtonAction: 0 // 0: Always ask, 1: Delete files, 2: Remove only from download list
        property string theme: 'system'
        property bool compactView: false
        property int filePickerSortField: FolderListModel.Name
        property bool filePickerSortReversed: false
        property bool toggleBottomPanelByClickingOnDownload: true
        property bool hideIntegrationBanner: false
        property string lastMovePath: StandardPaths.writableLocation(StandardPaths.DownloadLocation)
        property string exportImportPath: App.tools.url(StandardPaths.writableLocation(StandardPaths.DownloadLocation)).toLocalFile()
        property string pluginsDistribsPath: App.tools.url(StandardPaths.writableLocation(StandardPaths.DownloadLocation)).toLocalFile()
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
        property string lastRemoteBannerId
        property string lastRemoteAppId
        property string downloadsListColumns
        property double zoom: 1.0
        property double zoom2: 1.0 // additional zoom for fonts
        property double scheduledZoom: 0.0 // 0 means no change is scheduled
        property double scheduledZoom2: 0.0
        property bool enableStandaloneCreateDownloadsWindows: false
        property bool closeStandaloneDownloadWindowWhenStopped: true
        property var hideTags: ({})
        property bool showTroubleshootingUi: false
        property bool dontShowOsPermissionsDialog: false
        property bool closeButtonHidesApp: true
        property int uiVersion: App.uiDefaultVersion()
        property bool showUiUpdatedBanner: false
        property bool showPluginsDeveloperUi: false
        property bool pluginsDevAllowedPathsIgnoreSign: false
    }

    readonly property bool hasNonDefaultValues:
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
        settings.downloadsListColumns ||
        settings.zoom !== 1.0 ||
        settings.zoom2 !== 1.0 ||
        settings.enableStandaloneCreateDownloadsWindows !== false ||
        settings.closeStandaloneDownloadWindowWhenStopped !== true ||
        settings.dontShowOsPermissionsDialog !== false ||
        settings.closeButtonHidesApp !== true ||
        settings.uiVersion !== App.uiDefaultVersion() ||
        Object.keys(settings.hideTags).length

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
        settings.downloadsListColumns = "";
        settings.scheduledZoom = 1.0;
        settings.scheduledZoom2 = 1.0;
        settings.enableStandaloneCreateDownloadsWindows = false;
        settings.closeStandaloneDownloadWindowWhenStopped = true;
        settings.hideTags = {};
        settings.dontShowOsPermissionsDialog = false;
        settings.closeButtonHidesApp = true;
        settings.uiVersion = App.uiDefaultVersion();
        wasReset();
    }

    Connections {
        target: App.exportImport
        onImportFinished: (file, error) => {
            if (!error || !error.hasError)
                settings.sync();
        }
    }
}
