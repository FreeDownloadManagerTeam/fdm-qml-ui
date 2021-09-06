import QtQuick 2.10
import QtQuick.Window 2.10
import QtQuick.Controls 2.4
import "../common"
import "../common/Tools"
import "./Tools"
import "./Dialogs"
import "./BaseElements"
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.vmsqt 1.0
import org.freedownloadmanager.fdm.appfeatures 1.0
import org.freedownloadmanager.fdm.qtsystemtheme 1.0
import org.freedownloadmanager.fdm.dmcoresettings 1.0
import org.freedownloadmanager.fdm.abstractdownloadsui 1.0
import "./Themes"

ApplicationWindow {

    id: appWindow

    property bool macVersion: false
    property bool mobileVersion: false

    property int lastOkVisibility: ApplicationWindow.Windowed

    property int mainToolbarHeight: macVersion ? 75 : 50
    property bool modalDialogOpened: buildDownloadDlg.opened || tuneAddDownloadDlg.opened || aboutDlg.opened
                                    || deleteDownloadsDlg.opened || deleteDownloadsDlgSimple.opened
                                    || shutdownDlg.opened || mergeDownloadsDlg.opened || authenticationDlg.opened
                                    || movingFailedDlg.opened || fileIntegrityDlg.opened || changeUrlDlg.opened
                                    || schedulerDlg.opened || sslDlg.opened || mp3ConverterDlg.opened
                                    || antivirusSettingsDialog.opened || addTDlg.opened || stopDownloadDlg.opened
                                    || addMirrorDlg.opened || createPortableDlg.opened || importExportFailedDlg.opened
                                    || importDlg.opened || exportDownloadsDlg.opened || exportSettingsDlg.opened
                                    || deleteDownloadsFailedDlg.opened || customizeSoundsDlg.opened || editTagDlg.opened
                                    || mp4ConverterDlg.opened || privacyDlg.opened || reportSentDlg.opened
    property bool supportComputerShutdown: App.features.hasFeature(AppFeatures.ComputerShutdown)
    property bool updateSupported: App.features.hasFeature(AppFeatures.Updates)
    property bool btSupported: App.features.hasFeature(AppFeatures.BT)
    property alias btS: btStrings.item
    property bool ytSupported: App.features.hasFeature(AppFeatures.YT)
    property bool portableSupported: App.features.hasFeature(AppFeatures.CreatePortableVersion)
    property bool showIntegrationBanner: false
    property string integrationId: 'APPBTSETDEFTRCLIENT'

    property bool smallWindow: width < 910 || height < 610
    property bool compactView: uiSettingsTools.settings.compactView || smallWindow

    property bool forceWindowVisibility: false
    property int forceWindowVisibilityTo: Window.Windowed

    signal uiReadyStateChanged
    signal newDownloadAdded
    signal globalFocusLost
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

    width: 910
    height: 610
    minimumWidth: 550//Math.min(910, screen.desktopAvailableWidth - 50)
    minimumHeight: 340//Math.min(610, screen.desktopAvailableHeight - 50)
    title: App.isSelfTestMode ? App.displayName + " [Self Test Mode]" : App.displayName

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
    onStopDownload: {
        setForegroundWindow();
        stopDownloadDlg.show(downloadIds)
    }
    onActiveChanged: {
        systemTheme = App.systemTheme
    }

    readonly property var fonts: fonts_
    QtObject {
        id: fonts_
        readonly property int defaultSize: appWindow.compactView ? 13 : 14
    }

    KeyboardItemsFocusTools {
        anchors.fill: parent
    }

    WindowStateSaver {
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

    onClosing:
    {
        waSetVisibility(Window.Hidden);
        close.accepted = false;
    }

    onVisibilityChanged:
    {
        if (waHideWindowActive)
            return;

        if (visibility == ApplicationWindow.Windowed ||
                visibility == ApplicationWindow.FullScreen ||
                visibility == ApplicationWindow.Maximized)
        {
            lastOkVisibility = visibility;
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
            App.forceSetAppForeground();
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
            stackView.waPush(Qt.resolvedUrl("./SettingsPage/SettingsPage.qml"), {forceAntivirusBlock: forceAntivirusBlock});
        }
    }

    function canShowSettingsPage()
    {
        if (stackView.depth === 0) {
            return false;
        }

        var current_page = stackView.currentItem;

        if (['SettingsPage'].indexOf(current_page.pageName) >= 0) {
            return false;
        }

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
        id: selfTestDlg
        active: App.isSelfTestMode
        source: "Dialogs/SelfTestDialog.qml"
        anchors.centerIn: parent
        width: parent.width - 200
        height: parent.height - 200
        Component.onCompleted: {
            if (App.isSelfTestMode)
                uiReadyTools.onReady(function(){selfTestDlg.item.open();});
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

    ShutdownTools {
        id: shutdownTools
    }

    ShutdownDialog {
        id: shutdownDlg
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

    BuildDownloadDialog {
        id: buildDownloadDlg
    }

    TuneAndAddDownloadDialog {
        id: tuneAddDownloadDlg
    }

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

    function canShowMergeAuthSslDialog()
    {
        var page = stackView.get(0);
        if (!page) {
            return false;
        }
        var page_name = page.pageName;
        if (['WaitingPage'].indexOf(page_name) >= 0) {
            return false;
        }
        if (mergeDownloadsDlg.opened || authenticationDlg.opened || sslDlg.opened) {
            return false;
        }
        return true;
    }

    function checkNewDownloadRequests(force)
    {
        if (!App.ready)
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
            if (uiSettingsTools.settings.autoHideWhenFinishedAddingDownloads &&
                    !appWindow.active)
            {
                appWindow.forceWindowVisibility = true;
                appWindow.forceWindowVisibilityTo = visibility == Window.Minimized ? Window.Minimized :
                            appWindow.visible && !appWindow.macVersion ? Window.Minimized :
                            Window.Hidden;
            }

            appWindow.showWindow(true);
        }
        else
        {
            if (appWindow.forceWindowVisibility)
            {
                appWindow.forceWindowVisibility = false;
                waSetVisibility(appWindow.forceWindowVisibilityTo);
            }
        }
    }

    onAppWindowStateChanged: checkNewDownloadRequests()
    onUiReadyStateChanged: checkNewDownloadRequests()

    function onMergeRequest(force)
    {
        appWindow.showWindow(true);
        if (canShowMergeAuthSslDialog(force)) {
            var mergeRequestId = interceptionTools.getMergeRequestId();
            if (mergeRequestId) {
                var existingRequestId = interceptionTools.getExistingRequestId(mergeRequestId);
                mergeDownloadsDlg.newMergeByRequest(mergeRequestId, existingRequestId);
            }
        }
    }

    function onAuthenticationRequest() {
        appWindow.showWindow(true);
        if (canShowMergeAuthSslDialog()) {
            var request = interceptionTools.getAuthRequest();
            if (request) {
                authenticationDlg.newAuthenticationRequest(request);
            }
        }
    }

    function onSslRequest() {
        appWindow.showWindow(true);
        if (canShowMergeAuthSslDialog()) {
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
        return App.downloads.infos.info(downloadId).loError;
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
    }

    Connections {
        target: App.jsonRequests
        onReceived: {
            //arguments: id, json, isRequest
            var request_data = JSON.parse(json);
            if (request_data && request_data.type === 'optionsClick') {
                appWindow.showWindow(true);
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
        active: App.ready
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
    }

    Connections {
        target: App.downloads.filesExistsActionsMgr
        onActionRequired: {
            filesExistsDlg.open(downloadId, fileIndex, files);
            showWindow(true);
        }
    }

    Connections
    {
        target: App.downloads.errorsReportsMgr
        onReportFinished: reportSentDlg.open(error)
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

    Connections {
        target: uiSettingsTools.settings
        onEnableUserDefinedOrderOfDownloadsChanged: {
            if (uiSettingsTools.settings.enableUserDefinedOrderOfDownloads)
            {
                if (sortTools.sortBy != AbstractDownloadsUi.DownloadsSortByOrder)
                    sortTools.setSortByAndAsc(AbstractDownloadsUi.DownloadsSortByOrder, false);
            }
            else
            {
                if (sortTools.sortBy == AbstractDownloadsUi.DownloadsSortByOrder)
                    sortTools.setSortByAndAsc(AbstractDownloadsUi.DownloadsSortByCreationTime, false);
            }
        }
    }

    signal doDownloadUpdate()
    WhatsNewDialog {
        id: whatsnew
        width: Math.min(500, appWindow.width - 100)
        height: Math.min(250, appWindow.height - 100)
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
        width: Math.min(500, appWindow.width - 100)
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
}
