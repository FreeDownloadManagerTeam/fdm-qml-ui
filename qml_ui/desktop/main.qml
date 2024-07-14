import QtQuick 2.10
import QtQuick.Window 2.10
import QtQuick.Controls 2.4
import "../common"
import "../common/Tools"
import "./Tools"
import "./Dialogs"
import "./BaseElements"
import "./Banners"
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.vmsqt 1.0
import org.freedownloadmanager.fdm.appfeatures 1.0
import org.freedownloadmanager.fdm.qtsystemtheme 1.0
import org.freedownloadmanager.fdm.dmcoresettings 1.0
import org.freedownloadmanager.fdm.abstractdownloadsui 1.0
import "./Themes"
import "../qt5compat"

ApplicationWindow {

    id: appWindow

    property bool macVersion: false
    property bool mobileVersion: false

    property alias zoom: uiSettingsTools.zoom
    property alias zoom2: uiSettingsTools.zoom2
    // commented due to QTBUG-105706
    // readonly property double fontZoom: zoom*zoom2
    // this is working instead:
    readonly property double fontZoom: uiSettingsTools.zoom*uiSettingsTools.zoom2

    property int lastOkVisibility: ApplicationWindow.Windowed

    property int mainToolbarHeight: (macVersion ? 75 : 50) * zoom

    readonly property bool createDownloadDialogOpened: (buildDownloadDlg && buildDownloadDlg.opened) ||
                                     (tuneAddDownloadDlg && tuneAddDownloadDlg.opened)
    readonly property bool nonCreateDownloadDialogOpened: aboutDlg.opened
                                    || deleteDownloadsDlg.opened || deleteDownloadsDlgSimple.opened
                                    || shutdownDlg.opened || mergeDownloadsDlg.opened || authenticationDlg.opened
                                    || movingFailedDlg.opened || fileIntegrityDlg.opened || changeUrlDlg.opened
                                    || schedulerDlg.opened || sslDlg.opened || mp3ConverterDlg.opened
                                    || antivirusSettingsDialog.opened || addTDlg.opened || stopDownloadDlg.opened
                                    || addMirrorDlg.opened || createPortableDlg.opened || importExportFailedDlg.opened
                                    || importDlg.opened || exportDownloadsDlg.opened || exportSettingsDlg.opened
                                    || deleteDownloadsFailedDlg.opened || confirmDeleteExtraneousFilesDlg.opened
                                    || customizeSoundsDlg.opened || editTagDlg.opened
                                    || mp4ConverterDlg.opened || privacyDlg.opened || reportSentDlg.opened
                                    || remoteBannerMgr.bannerOpened || renameDownloadFileDlg.opened
                                    || submitBugReportDlg.opened || pluginBannerDlg.opened
                                    || mediaFileReadyToPlayDlg.opened

    readonly property bool modalDialogOpened: createDownloadDialogOpened || nonCreateDownloadDialogOpened
    property bool supportComputerShutdown: App.features.hasFeature(AppFeatures.ComputerShutdown) &&
                                           !App.rc.client.active
    property bool updateSupported: App.features.hasFeature(AppFeatures.Updates)
    property bool btSupported: App.features.hasFeature(AppFeatures.BT)
    property alias btS: btStrings.item
    property bool ytSupported: App.features.hasFeature(AppFeatures.YT)
    property bool portableSupported: App.features.hasFeature(AppFeatures.CreatePortableVersion)
    property bool showIntegrationBanner: false
    property string integrationId: 'APPBTSETDEFTRCLIENT'

    property bool smallWindow: width < 910*zoom || height < 610*zoom
    property bool compactView: uiSettingsTools.settings.compactView || smallWindow

    property bool disableDrop: false

    signal uiReadyStateChanged
    signal newDownloadAdded
    signal appWindowStateChanged
    signal checkUpdates
    signal tumSettingsChanged
    signal openScheduler(int downloadId)
    signal stopDownload(var downloadIds)
    signal updateDlgOpened()
    signal updateDlgClosed()
    signal showAbout()
    signal nativeMenuItemTriggered()
    signal startDownload
    signal reportError(int failedId)

    LayoutMirroring.enabled: App.loc.layoutDirection == Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    width: 910
    height: 610
    minimumWidth: 200*zoom+350*fontZoom
    minimumHeight: 100*zoom+240*fontZoom
    title: App.isSelfTestMode ? App.displayName + " [Self Test Mode]" :
           (App.rc.client.active && App.asyncLoadMgr.remoteName) ? App.displayName + " [" + qsTr("Remote connection to %1").arg(App.asyncLoadMgr.remoteName) + "]" + App.loc.emptyString :
           App.displayName

    DarkTheme {id: darkTheme}
    LightTheme {id: lightTheme}
    property var systemTheme: App.systemTheme
    readonly property bool useDarkTheme: (uiSettingsTools.settings.theme === 'dark') ||
                                         (uiSettingsTools.settings.theme === 'system' && systemTheme == QtSystemTheme.Dark)
    property var theme: useDarkTheme ? darkTheme : lightTheme

    palette.highlight: theme.textHighlight
    palette.windowText: theme.foreground
    palette.window: appWindow.theme.background
    palette.base: appWindow.theme.background
    palette.text: appWindow.theme.foreground

    onShowAbout: aboutDlg.open()
    onStopDownload: downloadIds => {
        setForegroundWindow();
        stopDownloadDlg.show(downloadIds)
    }
    onActiveChanged: {
        systemTheme = App.systemTheme
        if (active)
        {
            appWindowStateSaver.scheduleCheckWindowPos();
            raiseStandaloneCreateDownloadDialogIfRequired();
        }
    }

    onNonCreateDownloadDialogOpenedChanged: raiseStandaloneCreateDownloadDialogIfRequired()

    function raiseStandaloneCreateDownloadDialogIfRequired()
    {
        if (active &&
                uiSettingsTools.settings.enableStandaloneCreateDownloadsWindows &&
                createDownloadDialogOpened && !nonCreateDownloadDialogOpened)
        {
            if (buildDownloadDlgMgr.dialog && buildDownloadDlgMgr.dialog.opened)
            {
                buildDownloadDlgMgr.hostWindow.raise();
                buildDownloadDlgMgr.hostWindow.requestActivate();
            }
            else if (tuneAddDownloadDlgMgr.dialog && tuneAddDownloadDlgMgr.dialog.opened)
            {
                tuneAddDownloadDlgMgr.hostWindow.raise();
                tuneAddDownloadDlgMgr.hostWindow.requestActivate();
            }
        }
    }

    readonly property var fonts: fonts_
    QtObject {
        id: fonts_
        readonly property int defaultSize: (appWindow.compactView ? 13 : 14)*fontZoom
    }

    KeyboardItemsFocusTools {
        anchors.fill: parent
    }

    WindowStateSaver {
        id: appWindowStateSaver
        window: appWindow
        windowName: "appWindow"
        setVisibleWhenCompleted: true
        forceHidden: App.startHidden()
    }

    UiReadyTools {
        id: uiReadyTools
        firstPageComponent: Component {
            DownloadsPage {}
        }
        waitingPageComponent: Component {
            WaitingPage {}
        }
    }

    WaStackView {
        z: 1
        id: stackView
        width: parent.width
        anchors.top: parent.top
        anchors.bottom: mainStatusBar.top
        onCurrentItemChanged: appWindowStateChanged()
    }

    Loader {
        id: nativeMenu
        Component.onCompleted: loadNativeMenu()
    }

    Connections {
        target: App.loc
        onCurrentTranslationChanged: loadNativeMenu()
    }

    function loadNativeMenu()
    {
        /*if (Qt.platform.os === "osx") {
            nativeMenu.source = "";
            nativeMenu.source = "NativeMenuBar.qml";
        }*/
    }

    MainStatusBar {
        id: mainStatusBar
        width: parent.width
        anchors.bottom: parent.bottom
    }

    ModalDimmingEffect {
        visible: appWindow.modalDialogOpened
        height: parent.height
        width: parent.width
        z: 10
    }

    onClosing: (close) => {
        waSetVisibility(Window.Hidden);
        close.accepted = false;
        if (!uiSettingsTools.settings.closeButtonHidesApp)
            App.quit();
    }

    onVisibilityChanged:
    {
        if (appWindow.waHideWindowActive)
            return;

        if (appWindow.visibility == ApplicationWindow.Windowed ||
                appWindow.visibility == ApplicationWindow.FullScreen ||
                appWindow.visibility == ApplicationWindow.Maximized)
        {
            appWindow.lastOkVisibility = appWindow.visibility;
        }
    }

    property bool waHideWindowActive: false

    function waSetVisibility(v)
    {
        if (macVersion && v == Window.Hidden && visibility == Window.FullScreen)
        {
            // WORKAROUND: https://bugreports.qt.io/browse/QTBUG-95947
            waHideWindowActive = true;
            visibility = Window.Windowed;
        }
        else
        {
            visibility = v;
        }
    }

    onWindowStateChanged: {
        if (waHideWindowActive &&
                windowState != Qt.WindowFullScreen &&
                visibility == Window.Windowed)
        {
            visibility = Window.Hidden;
            waHideWindowActive = false;
        }
    }

    function setForegroundWindow()
    {
        raise();
        requestActivate();
    }

    function showWindow(forceForeground)
    {
        visibility = lastOkVisibility;
        setForegroundWindow();
        if (forceForeground)
            App.forceSetWindowForeground(this);
    }

    function resizeWindow() {
        if (macVersion) {
            if (visibility === ApplicationWindow.Windowed) {
                showMaximized();
            } else {
                showNormal();
            }
        }
    }

    function openSettings(forceAntivirusBlock = false)
    {
        if (canShowSettingsPage()) {
            if (isCurrentPagePlugins())
                stackView.pop();
            stackView.waPush(Qt.resolvedUrl("./SettingsPage/SettingsPage.qml"), {forceAntivirusBlock: forceAntivirusBlock});
        }
    }

    function canShowSettingsPage()
    {
        return canShowPage('SettingsPage');
    }

    function openPlugins()
    {
        if (canShowPage("PluginsPage")) {
            if (isCurrentPageSettings())
                stackView.pop();
            stackView.waPush(Qt.resolvedUrl("./PluginsPage/PluginsPage.qml"));
        }
    }

    function currentPageName()
    {
        if (stackView.empty)
            return "";

        return stackView.currentItem ?
                    stackView.currentItem.pageName :
                    "";
    }

    function isCurrentPageSettings()
    {
        return currentPageName() === "SettingsPage";
    }

    function isCurrentPagePlugins()
    {
        return currentPageName() === "PluginsPage";
    }

    function canShowPage(name)
    {
        if (stackView.empty)
            return false;

        var current_page = stackView.currentItem;
        if (!current_page)
            return false;

        if ([name].indexOf(current_page.pageName) >= 0)
            return false;

        return true;
    }

    Connections
    {
        target: App
        onSetMainWindowForegroundRequested: setForegroundWindow()
        onActivateRequested: showWindow()
        onShowAboutRequested: {showWindow(); aboutDlg.open();}
        onShowQuitConfirmation: {quitConfDlg.open(message);}
    }

    Loader {
        id: aboutDlg
        active: false
        source: "Dialogs/AboutDialog.qml"
        anchors.centerIn: parent
        property bool opened: active && item.opened
        function open() {
            active = true;
            item.open();
        }
    }

    Loader {
        id: linux_2023_09_13_Case_Dialog
        active: false
        source: "Dialogs/Linux_2023_09_13_Case_Dialog.qml"
        anchors.centerIn: parent
        Component.onCompleted: {
            if (App.app_Linux_2023_09_13_Case_isPositive())
                active = true;
                uiReadyTools.onReady(function(){
                    linux_2023_09_13_Case_Dialog.item.open();
                });
        }
    }

    Loader {
        id: selfTestDlg
        active: App.isSelfTestMode
        source: "Dialogs/SelfTestDialog.qml"
        anchors.centerIn: parent
        width: parent.width - 200
        height: parent.height - 200
        Component.onCompleted: {
            if (App.isSelfTestMode) {
                item.width = Qt.binding(()=>{return selfTestDlg.width;});
                item.height = Qt.binding(()=>{return selfTestDlg.height;});
                uiReadyTools.onReady(function(){selfTestDlg.item.open();});
            }
        }
    }

    Loader {
        id: addTDlg
        active: btSupported
        source: "../bt/desktop/AddTDialog.qml"
        anchors.centerIn: parent
        property bool opened: active && item.opened
        function open(ids) {
            active = true;
            item.showDialog(ids);
        }
    }

    Loader {
        id: btTools
        active: btSupported
        source: "../bt/Tools.qml"
    }

    Loader {
        id: btStrings
        active: btSupported
        source: "../bt/BtStrings.qml"
    }

    Loader {
        id: createPortableDlg
        active: portableSupported
        source: "Dialogs/CreatePortableDialog.qml"
        anchors.centerIn: parent
        property bool opened: active && item.opened
        function open() {
            active = true;
            item.open();
        }
    }

    Loader {
        id: connectToRemoteAppDlg
        active: App.features.hasFeature(AppFeatures.RemoteControlClient)
        source: "Dialogs/ConnectToRemoteAppDialog.qml"
        anchors.centerIn: parent
        property bool opened: active && item.opened
        function open() {
            active = true;
            item.open();
        }
    }

    Loader {
        id: privacyDlg
        source: "Dialogs/PrivacyDialog.qml"
        active: false
        anchors.centerIn: parent
        property bool opened: active && item.opened
        function open(failedId) {
            if (uiSettingsTools.settings.reportProblemAccept) {
                App.downloads.errorsReportsMgr.reportError(failedId);
                appWindow.reportError(failedId);
            } else {
                active = true;
                if (!item.opened) {
                    item.showDialog(failedId);
                }
            }
        }
    }

    Loader {
        id: reportSentDlg
        source: "Dialogs/ReportSentDialog.qml"
        active: false
        anchors.centerIn: parent
        property bool opened: active && item.opened
        function open(error) {
            active = true;
            if (!item.opened) {
                item.errorMessage = error;
                item.open();
            }
        }
    }

    Loader {
        id: quitConfDlg
        active: false
        source: "Dialogs/QuitConfirmationDialog.qml"
        anchors.centerIn: parent
        function open(message) {
            active = true;
            item.message = message;
            item.open();
        }
    }

    DeleteDownloadsDialog {
        id: deleteDownloadsDlg
    }

    DeleteDownloadsDialogSimple {
        id: deleteDownloadsDlgSimple
    }

    DeleteDownloadsFailedDialog {
        id: deleteDownloadsFailedDlg
    }

    ConfirmDeleteExtraneousFilesDialog {
        id: confirmDeleteExtraneousFilesDlg
    }

    AntivirusSettingsDialog {
        id: antivirusSettingsDialog
    }

    MovingFailedDialog {
        id: movingFailedDlg
    }

    FileIntegrityDialog {
        id: fileIntegrityDlg
    }

    ChangeUrlDialog {
        id: changeUrlDlg
    }

    AddMirrorDialog {
        id: addMirrorDlg
    }

    MovingFolderDialog {
        id: movingFolderDlg
    }

    ExportSettingsDialog {
        id: exportSettingsDlg
    }

    ImportDialog {
        id: importDlg
    }

    ImportExportFailedDialog {
        id: importExportFailedDlg
    }

    ExportDownloadsDialog {
        id: exportDownloadsDlg
    }

    SubmitBugReportDialog {
        id: submitBugReportDlg
    }

    PluginBannerDialog {
        id: pluginBannerDlg
    }    
    PluginsBannersManager {}

    ShutdownTools {
        id: shutdownTools
    }

    ShutdownDialog {
        id: shutdownDlg
    }

    RenameDownloadFileDialog {
        id: renameDownloadFileDlg
        onClosed: appWindowStateChanged()
    }

    MediaFileReadyToPlayDialog {
        id: mediaFileReadyToPlayDlg
        onClosed: appWindowStateChanged()
        MediaFileReadyToPlayTools {
            dlg: mediaFileReadyToPlayDlg
            onReadyToShowDialog: {
                openDialog();
                showWindow(true);
            }
        }
    }

    Loader {
        id: editTagDlg
        active: false
        source: "Dialogs/EditTagDialog.qml"
        anchors.centerIn: parent
        property bool opened: active && item.opened
        function open() {
            active = true;
            item.open();
        }
    }

    SelectedDownloadsTools {
        id: selectedDownloadsTools
    }

    SortTools {
        id: sortTools
    }

    BottomPanelTools {
        id: bottomPanelTools
    }

    UiSettingsTools {
        id: uiSettingsTools
    }

    DownloadsViewTools {
        id: downloadsViewTools
    }

    DownloadsWithMissingFilesTools {
        id: downloadsWithMissingFilesTools
    }

    StandaloneCapableDialogManager {
        id: buildDownloadDlgMgr
        standalone: uiSettingsTools.settings.enableStandaloneCreateDownloadsWindows
        componentSource: Qt.resolvedUrl("Dialogs/BuildDownloadDialog.qml")
    }
    property alias buildDownloadDlg: buildDownloadDlgMgr.dialog

    StandaloneCapableDialogManager {
        id: tuneAddDownloadDlgMgr
        standalone: uiSettingsTools.settings.enableStandaloneCreateDownloadsWindows
        componentSource: Qt.resolvedUrl("Dialogs/TuneAndAddDownloadDialog.qml")
    }
    property alias tuneAddDownloadDlg: tuneAddDownloadDlgMgr.dialog

    AuthenticationDialog {
        id: authenticationDlg
    }

    SslDialog {
        id: sslDlg
    }

    SchedulerDialog {
        id: schedulerDlg
    }

    Loader {
        id: mp3ConverterDlg
        active: false
        source: "Dialogs/Mp3ConverterDialog.qml"
        anchors.centerIn: parent
        property bool opened: active && item.opened
        function open(downloadsIds, filesIndices) {
            active = true;
            if (!item.opened) {
                item.showDialog(downloadsIds, filesIndices);
            }
        }
    }

    Loader {
        id: mp4ConverterDlg
        active: false
        source: "Dialogs/Mp4ConverterDialog.qml"
        anchors.centerIn: parent
        property bool opened: active && item.opened
        function open(downloadsIds, filesIndices) {
            active = true;
            if (!item.opened) {
                item.showDialog(downloadsIds, filesIndices);
            }
        }
    }

    DownloadsInterceptionTools {
        id: interceptionTools
        onHasDownloadRequests: checkNewDownloadRequests(false)
        onNewDownloadRequests: checkNewDownloadRequests(true)
        onHasMergeRequests: onMergeRequest(false)
        onNewMergeRequests: onMergeRequest(true)
        onNewAuthenticationRequest: onAuthenticationRequest()
        onNewSslRequest: onSslRequest()
        onHasMovingFailedDownloads: onMovingFailed(downloadId, error)
    }

    MergeDownloadsDialog {
        id: mergeDownloadsDlg
    }

    StopDownloadDialog {
        id: stopDownloadDlg
    }

    Loader {
        id: customizeSoundsDlg
        active: false
        source: "Dialogs/CustomizeSoundsDialog.qml"
        anchors.centerIn: parent
        property bool opened: active && item.opened
        function open() {
            active = true;
            item.open();
        }
    }

    Loader {
        id: remoteResourceChangedDlg
        active: false
        source: "Dialogs/RemoteResourceChangedDialog.qml"
        anchors.centerIn: parent
        property bool opened: active && item.opened
        function open(id) {
            active = true;
            item.remoteResourceChanged(id);
            if (!item.opened) {
                item.open();
            }
        }
    }

    EnvTools {
        id: envTools
    }

    TagsTools {
        id: tagsTools
    }

    Connections {
        target: appWindow
        onOpenScheduler: {
            selectedDownloadsTools.openSchedulerDialog([downloadId])
        }
    }

    function canShowCreateDownloadDialog(force)
    {
        var page = stackView.get(0);
        if (!page) {
            return false;
        }
        var page_name = page.pageName;
        if (['WaitingPage'].indexOf(page_name) >= 0) {
            return false;
        }

        if (/*!force && */(buildDownloadDlg.opened || tuneAddDownloadDlg.opened
            || mergeDownloadsDlg.opened || authenticationDlg.opened || sslDlg.opened)) {
            return false;
        }
        return true;
    }

    function canShowMergeAuthSslDialog(isAuth)
    {
        if (mergeDownloadsDlg.opened || authenticationDlg.opened || sslDlg.opened)
            return false;

        // show auth dialog in "connecting to remote FDM" page
        if (!isAuth || !App.rc.client.active)
        {
            var page = stackView.get(0);
            if (!page) {
                return false;
            }
            var page_name = page.pageName;
            if (['WaitingPage'].indexOf(page_name) >= 0) {
                return false;
            }
        }

        return true;
    }

    function checkNewDownloadRequests(force)
    {
        if (!App.asyncLoadMgr.ready)
            return;

        if (buildDownloadDlg.opened && !buildDownloadDlg.isBusy()) {
            buildDownloadDlg.close();
            return;
        }

        var isShowingDlg = false;

        if (canShowCreateDownloadDialog(force))
        {
            var uiNewDownloadRequest = interceptionTools.getDownloadRequest();
            if (uiNewDownloadRequest)
            {
                buildDownloadDlg.newDownloadByRequest(uiNewDownloadRequest);
                isShowingDlg = true;
            }
        }
        else
        {
            isShowingDlg = true;
        }

        if (isShowingDlg)
        {
            if (!buildDownloadDlgMgr.standalone)
                appWindow.showWindow(true);
        }
    }

    onAppWindowStateChanged: checkNewDownloadRequests()
    onUiReadyStateChanged: checkNewDownloadRequests()

    function onMergeRequest(force)
    {
        appWindow.showWindow(true);
        if (canShowMergeAuthSslDialog(false)) {
            var mergeRequestId = interceptionTools.getMergeRequestId();
            if (mergeRequestId) {
                var existingRequestId = interceptionTools.getExistingRequestId(mergeRequestId);
                mergeDownloadsDlg.newMergeByRequest(mergeRequestId, existingRequestId);
            }
        }
    }

    function onAuthenticationRequest() {
        appWindow.showWindow(true);
        if (canShowMergeAuthSslDialog(true)) {
            var request = interceptionTools.getAuthRequest();
            if (request) {
                authenticationDlg.newAuthenticationRequest(request);
            }
        }
    }

    function onSslRequest() {
        appWindow.showWindow(true);
        if (canShowMergeAuthSslDialog(false)) {
            var request = interceptionTools.getSslRequest();
            if (request) {
                sslDlg.newSslRequest(request);
            }
        }
    }

    function onMovingFailed(downloadId, error) {
        appWindow.showWindow(true);
        error = error !== '' ? error : getDownloadMovingError(downloadId);

        if (!movingFailedDlg.opened) {
            movingFailedDlg.movingFailedAction(downloadId, error);
        }
    }

    function getDownloadMovingError(downloadId) {
        return App.downloads.infos.info(downloadId).loError.displayTextShort;
    }

    function updateMacVersionWorkaround()
    {
        macVersion = Qt.platform.os === "osx"
    }

    Component.onCompleted: {
        if (Qt.platform.os === "osx")
            flags |= Qt.WindowFullscreenButtonHint;
        uiReadyTools.onReady(updateMacVersionWorkaround);

        App.useDarkTheme = Qt.binding(function(){ return useDarkTheme;});

        uiReadyTools.onReady(function()
        {
            let r = App.downloads.filesExistsActionsMgr.pendingRequest();
            if (r)
            {
                filesExistsDlg.open(r.downloadId, r.fileIndex, r.files);
                showWindow(true);
            }
        });
    }

    Connections {
        target: App.jsonRequests
        onReceived: {
            //arguments: id, json, isRequest
            var request_data = JSON.parse(json);
            if (request_data && request_data.type === 'optionsClick') {
                appWindow.showWindow(true);
                if (!App.rc.client.active)
                   uiReadyTools.onReady(appWindow.openSettings);
            }
        }
    }

    Connections
    {
        target: App.powerManagement
        onShutdownConfirmationRequired: {shutdownDlg.open();}
    }

    Loader
    {
        id: mainUiMgr
        source: Qt.resolvedUrl("MainUiManager.qml")
        active: App.asyncLoadMgr.ready
    }

    Connections {
        target: App.downloads.tracker
        onRemoteResourceChanged: {
            if (!App.settings.toBool(App.settings.dmcore.value(DmCoreSettings.AutoRestartFinishedDownloadIfRemoteResourceChanged))) {
                remoteResourceChangedDlg.open(id);
            }
        }
    }

    Loader {
        id: filesExistsDlg
        active: false
        source: "Dialogs/FilesExistsDialog.qml"
        anchors.centerIn: parent
        property bool opened: active && item.opened
        function open(downloadId, fileIndex, files) {
            active = true;
            item.downloadId = downloadId;
            item.fileIndex = fileIndex;
            item.files = files;
            if (!item.opened) {
                item.open();
            }
        }
        function closeFor(downloadId, fileIndex) {
            if (item.opened && item.downloadId === downloadId && item.fileIndex === fileIndex)
                item.close();
        }
    }

    Connections {
        target: App.downloads.filesExistsActionsMgr
        onActionRequired: (downloadId, fileIndex, files) => {
            filesExistsDlg.open(downloadId, fileIndex, files);
            showWindow(true);
        }
        onActionApplied: (downloadId, fileIndex) => {
            filesExistsDlg.closeFor(downloadId, fileIndex);
        }
    }

    Connections
    {
        target: App.downloads.errorsReportsMgr
        onReportFinished: reportSentDlg.open(error.displayTextLong)
    }

    property double currentTime: 0
    Timer {
        interval: 1000
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: currentTime = Date.now()
    }

    Connections {
        target: appWindow
        onNewDownloadAdded: downloadsViewTools.resetAllFilters()
    }

    signal doDownloadUpdate()
    WhatsNewDialog {
        id: whatsnew
        width: Math.min(500*appWindow.zoom, appWindow.width - 100*appWindow.zoom)
        height: Math.min(250*appWindow.zoom, appWindow.height - 100*appWindow.zoom)
        onUpdateClicked: doDownloadUpdate()
    }
    function openWhatsNewDialog(version, changelog)
    {
        whatsnew.version = version;
        whatsnew.changelog = changelog;
        whatsnew.open();
    }

    DownloadExpiredDialog {
        id: downloadExpiredDlg
        width: Math.min(500*appWindow.zoom, appWindow.width - 100*appWindow.zoom)
        onClosed: {
            App.downloads.expiredDownloads.onExpiredDownloadNotificationFinished(downloadId);
            openDownloadExpiredDialogForNextDownload();
        }
    }
    function openDownloadExpiredDialog(downloadId)
    {
        downloadExpiredDlg.downloadId = downloadId;
        downloadExpiredDlg.open();
    }
    function openDownloadExpiredDialogForNextDownload()
    {
        if (!downloadExpiredDlg.opened &&
                App.downloads.expiredDownloads.hasNewExpiredDownloads)
        {
            openDownloadExpiredDialog(App.downloads.expiredDownloads.nextNewExpiredDownloadId());
        }
    }
    Connections {
        target: App.downloads.expiredDownloads
        onHasNewExpiredDownloadsChanged: openDownloadExpiredDialogForNextDownload()
        onNotExpiredAnymore: {
            if (downloadExpiredDlg.opened && downloadExpiredDlg.downloadId == id)
                downloadExpiredDlg.close();
        }
    }

    Loader
    {
        source: Qt.resolvedUrl("PluginsPage/PluginsUpdateUiManager.qml")
        active: App.features.hasFeature(AppFeatures.Plugins)
    }

    ConvertFilesFailedDialog
    {
        id: convertFilesFailedDialog
        width: Math.min(appWindow.width - 50*appWindow.zoom, recommendedWidth)
        height: Math.min(appWindow.height - 100*appWindow.zoom, recommendedHeight)
    }

    ConvertDestinationFilesExistsDialog
    {
        id: convertDestinationFilesExistsDialog

        width: Math.min(appWindow.width - 50*appWindow.zoom, recommendedWidth)
        height: Math.min(appWindow.height - 100*appWindow.zoom, recommendedHeight)

        onClosed: {
            if (requests.length)
                onGotRequest();
        }

        property var requests: []

        function onGotRequest()
        {
            if (opened || !requests.length)
                return;

            var r = requests.shift();

            taskId = r.taskId;
            files = r.files;

            open();
        }
    }

    Connections
    {
        target: App.downloads.mgr

        onConvertDestinationFilesExists: function(taskId, files)
        {
            convertDestinationFilesExistsDialog.requests.push(
                        {
                            taskId: taskId,
                            files: files
                        });

            convertDestinationFilesExistsDialog.onGotRequest();
        }

        onConvertTaskFinished: function(taskId, failedFiles)
        {
            if (convertDestinationFilesExistsDialog.opened &&
                    convertDestinationFilesExistsDialog.taskId == taskId)
            {
                convertDestinationFilesExistsDialog.close();
            }

            if (failedFiles.length > 0)
            {
                if (convertFilesFailedDialog.opened)
                {
                    var arr = convertFilesFailedDialog.files;
                    arr.push(...failedFiles);
                    convertFilesFailedDialog.files = arr;
                }
                else
                {
                    convertFilesFailedDialog.files = failedFiles;
                    convertFilesFailedDialog.open();
                }
            }
        }
    }

    RemoteBannerManager
    {
        id: remoteBannerMgr
        settings: uiSettingsTools.settings
    }

    Connections
    {
        target: App.commands
        onShowConnectToRemoteAppUi: function(remoteId)
        {
            connectToRemoteAppDlg.item.setRemoteId(remoteId);
            if (!connectToRemoteAppDlg.opened)
                connectToRemoteAppDlg.open();
            showWindow(true);
        }
    }

    QTBUG {
        id: qtbug
    }
}
