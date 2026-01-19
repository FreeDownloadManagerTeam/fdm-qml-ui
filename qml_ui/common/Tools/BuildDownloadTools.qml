import QtQuick
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.abstractdownloadsui 
import org.freedownloadmanager.fdm.abstractdownloadoption

Item {

    id: root

    signal createDownloadBeforeRequest()
    signal createRequestSuccess(double id)
    signal createDownloadFromDialog()
    signal createSilentDownload()
    signal modulesChanged(var modulesUids, var urlDescriptions)
    signal checkFilePathFinished()

    signal finished(double id, bool added)
    signal reject()

    property double requestId: -1

    property bool checkingIfAcceptableUrl: false
    property bool buildingDownload: false
    property bool buildingDownloadFinished: false
    property string statusText: ""
    property bool statusWarning: false

    property var lastError: null
    property bool allowedToReportLastError: false
    property double lastFailedRequestId: -1
    property string urlText
    property bool disableAcceptableUrlCheck: false

    property string filePath
    property string fileName
    property bool forceOverwriteFile: false
    property int filesCount
    property double fileSize
    property double freeDiskSpace
    property bool hasWriteAccess: true
    property string previewUrl

    property string modulesUrl
    property string modulesSelectedUid

    readonly property int defaultPreferredVideoHeight: 1080
    property int preferredVideoHeight: 0
    property bool preferredVideoHeightChangedByUser: false
    property int preferredFileType: 0
    property bool preferredFileTypeChangedByUser: false
    readonly property string defaultPreferredLanguage: ""
    property bool preferredLanguageEnabled: false
    property string preferredLanguage: ""
    property bool preferredLanguageChangedByUser: false
    property var originFilesTypes
    property bool addDateToFileNameEnabled: false
    property bool emptyDownloadsListWarning
    property bool notEnoughSpaceWarning: freeDiskSpace != -1 && fileSize > 0 && fileSize > freeDiskSpace
    property bool wrongFilePathWarning: false
    property bool wrongFileNameWarning: false
    property bool emptyFileNameWarning: false

    property var versionSelector: null
    property int versionCount: versionSelector ? versionSelector.versionCount : 0

    property string authRealm
    property string authProxyText
    property var authRequest: null

    property string sslHost
    property string sslAlg
    property string sslSha1Fingerprint
    property string sslSha256Fingerprint
    property var sslErrorsStrings: null
    property bool sslHostIsUnknownErr: false
    property var sslRequest: null

    property bool batchDownload: false
    property int batchDownloadMaxUrlsCount: uiSettingsTools.settings.batchDownloadMaxUrlsCount
    property bool batchDownloadLimitWarning

    property int resumeSupport: AbstractDownloadsUi.DownloadResumeSupportUnknown

    property bool subtitlesEnabled: false
    property int subtitlesCount: 0
    property var subtitlesList
    property var preferredSubtitlesLanguagesCodes: []
    property bool preferredSubtitlesLanguagesCodesChangedByUser: false
    property bool needDownloadSubtitles
    property bool needDownloadSubtitlesChangedByUser: false

    property var relatedTag: null

    property var defaultSubtitlesList: [{languageCode: "af", languageName: "Afrikaans"},{languageCode: "sq", languageName: "Albanian"},{languageCode: "am", languageName: "Amharic"},{languageCode: "ar", languageName: "Arabic"},{languageCode: "hy", languageName: "Armenian"},{languageCode: "az", languageName: "Azerbaijani"},{languageCode: "bn", languageName: "Bangla"},{languageCode: "eu", languageName: "Basque"},{languageCode: "be", languageName: "Belarusian"},{languageCode: "bs", languageName: "Bosnian"},{languageCode: "bg", languageName: "Bulgarian"},{languageCode: "my", languageName: "Burmese"},{languageCode: "ca", languageName: "Catalan"},{languageCode: "ceb", languageName: "Cebuano"},{languageCode: "zh-Hans", languageName: "Chinese (Simplified)"},{languageCode: "zh-Hant", languageName: "Chinese (Traditional)"},{languageCode: "co", languageName: "Corsican"},{languageCode: "hr", languageName: "Croatian"},{languageCode: "cs", languageName: "Czech"},{languageCode: "da", languageName: "Danish"},{languageCode: "nl", languageName: "Dutch"},{languageCode: "en", languageName: "English"},{languageCode: "eo", languageName: "Esperanto"},{languageCode: "et", languageName: "Estonian"},{languageCode: "fil", languageName: "Filipino"},{languageCode: "fi", languageName: "Finnish"},{languageCode: "fr", languageName: "French"},{languageCode: "gl", languageName: "Galician"},{languageCode: "ka", languageName: "Georgian"},{languageCode: "de", languageName: "German"},{languageCode: "el", languageName: "Greek"},{languageCode: "gu", languageName: "Gujarati"},{languageCode: "ht", languageName: "Haitian Creole"},{languageCode: "ha", languageName: "Hausa"},{languageCode: "haw", languageName: "Hawaiian"},{languageCode: "iw", languageName: "Hebrew"},{languageCode: "hi", languageName: "Hindi"},{languageCode: "hmn", languageName: "Hmong"},{languageCode: "hu", languageName: "Hungarian"},{languageCode: "is", languageName: "Icelandic"},{languageCode: "ig", languageName: "Igbo"},{languageCode: "id", languageName: "Indonesian"},{languageCode: "ga", languageName: "Irish"},{languageCode: "it", languageName: "Italian"},{languageCode: "ja", languageName: "Japanese"},{languageCode: "jv", languageName: "Javanese"},{languageCode: "kn", languageName: "Kannada"},{languageCode: "kk", languageName: "Kazakh"},{languageCode: "km", languageName: "Khmer"},{languageCode: "rw", languageName: "Kinyarwanda"},{languageCode: "ko", languageName: "Korean"},{languageCode: "ku", languageName: "Kurdish"},{languageCode: "ky", languageName: "Kyrgyz"},{languageCode: "lo", languageName: "Lao"},{languageCode: "la", languageName: "Latin"},{languageCode: "lv", languageName: "Latvian"},{languageCode: "lt", languageName: "Lithuanian"},{languageCode: "lb", languageName: "Luxembourgish"},{languageCode: "mk", languageName: "Macedonian"},{languageCode: "mg", languageName: "Malagasy"},{languageCode: "ms", languageName: "Malay"},{languageCode: "ml", languageName: "Malayalam"},{languageCode: "mt", languageName: "Maltese"},{languageCode: "mi", languageName: "Maori"},{languageCode: "mr", languageName: "Marathi"},{languageCode: "mn", languageName: "Mongolian"},{languageCode: "ne", languageName: "Nepali"},{languageCode: "no", languageName: "Norwegian"},{languageCode: "ny", languageName: "Nyanja"},{languageCode: "or", languageName: "Odia"},{languageCode: "ps", languageName: "Pashto"},{languageCode: "fa", languageName: "Persian"},{languageCode: "pl", languageName: "Polish"},{languageCode: "pt", languageName: "Portuguese"},{languageCode: "pa", languageName: "Punjabi"},{languageCode: "ro", languageName: "Romanian"},{languageCode: "ru", languageName: "Russian"},{languageCode: "sm", languageName: "Samoan"},{languageCode: "gd", languageName: "Scottish Gaelic"},{languageCode: "sr", languageName: "Serbian"},{languageCode: "sn", languageName: "Shona"},{languageCode: "sd", languageName: "Sindhi"},{languageCode: "si", languageName: "Sinhala"},{languageCode: "sk", languageName: "Slovak"},{languageCode: "sl", languageName: "Slovenian"},{languageCode: "so", languageName: "Somali"},{languageCode: "st", languageName: "Southern Sotho"},{languageCode: "es", languageName: "Spanish"},{languageCode: "su", languageName: "Sundanese"},{languageCode: "sw", languageName: "Swahili"},{languageCode: "sv", languageName: "Swedish"},{languageCode: "tg", languageName: "Tajik"},{languageCode: "ta", languageName: "Tamil"},{languageCode: "tt", languageName: "Tatar"},{languageCode: "te", languageName: "Telugu"},{languageCode: "th", languageName: "Thai"},{languageCode: "tr", languageName: "Turkish"},{languageCode: "tk", languageName: "Turkmen"},{languageCode: "uk", languageName: "Ukrainian"},{languageCode: "ur", languageName: "Urdu"},{languageCode: "ug", languageName: "Uyghur"},{languageCode: "uz", languageName: "Uzbek"},{languageCode: "vi", languageName: "Vietnamese"},{languageCode: "cy", languageName: "Welsh"},{languageCode: "fy", languageName: "Western Frisian"},{languageCode: "xh", languageName: "Xhosa"},{languageCode: "yi", languageName: "Yiddish"},{languageCode: "yo", languageName: "Yoruba"},{languageCode: "zu", languageName: "Zulu"}]

    onCreateDownloadFromDialog: appWindow.startDownload()
    onCreateDownloadBeforeRequest: appWindow.startDownload()
    onCreateSilentDownload: appWindow.startDownload()

    function buildAuthenticationDialog(request)
    {
        if (request) {
            authRequest = request;
            authProxyText = authRequest.scope.proxy
                        ? qsTr("The proxy %1 requires a username and password.").arg(authRequest.scope.rootUrl)
                        : qsTr("%1 is requesting your username and password.").arg(authRequest.scope.rootUrl);
            authRealm = authRequest.scope.realm;
        }
    }

    function doAuth(username, pass, remember)
    {
        authRequest.record.user = username.trim();
        authRequest.record.password = pass.trim();
        App.networkAuth.submit(authRequest, false, remember);
    }

    function rejectAuth()
    {
        App.networkAuth.submit(authRequest, true, false);
        root.reject();
    }

    function buildSslDialog(request)
    {
        if (request) {
            sslRequest = request;
            if (sslRequest.cert)
            {
                sslSha1Fingerprint = sslRequest.cert.sha1Fingerprint();
                sslSha256Fingerprint = sslRequest.cert.sha256Fingerprint();
                sslErrorsStrings = sslRequest.errorsStrings;
                sslHost = sslRequest.url.url;
                sslHostIsUnknownErr = false;
                sslAlg = "";
            }
            else
            {
                sslSha1Fingerprint = sslRequest.sslHost.sha1Fingerprint();
                sslSha256Fingerprint = sslRequest.sslHost.sha256Fingerprint();
                sslErrorsStrings = null;
                sslHost = sslRequest.sslHost.hostAndPort();
                sslHostIsUnknownErr = true;
                sslAlg = sslRequest.sslHost.algorithm();
            }
        }
    }

    function acceptSsl()
    {
        App.ignoreSslCertsErrs.submit(sslRequest, true);
    }

    function rejectSsl()
    {
        App.ignoreSslCertsErrs.submit(sslRequest, false);
        root.reject();
    }

    function setPreviewUrl()
    {
        var request = App.downloads.creator.downloadInfo(requestId, 0);
        previewUrl = request.remotePreviewImgUrl ? request.remotePreviewImgUrl.toString() : '';
    }

    function setPreferredVideoHeight(val, byUser)
    {
        preferredVideoHeight = val;
        if (byUser)
            preferredVideoHeightChangedByUser = true;
    }

    function setPreferredFileType(val, byUser)
    {
        preferredFileType = val;
        if (byUser)
            preferredFileTypeChangedByUser = true;
    }

    function setPreferredLanguage(val, byUser)
    {
        preferredLanguage = val;
        preferredLanguageEnabled = true;
        if (byUser)
            preferredLanguageChangedByUser = true;
    }

    function setOriginFilesTypes(arr)
    {
        originFilesTypes = arr.length > 1 ? arr : [];
    }

    function setAddDateToFileNameEnabled(val)
    {
        addDateToFileNameEnabled = val;
    }

    function setSubtitlesEnabled(val)
    {
        subtitlesEnabled = val;
    }

    function saveBatchDownloadOptions(addDateOptionVal, addDateOptionValChangedByUser)
    {
        if (batchDownload)
        {
            for (var i = 0; i < App.downloads.creator.downloadCount(requestId); i++)
            {
                if (preferredVideoHeightChangedByUser)
                {
                    App.downloads.creator.setDownloadOption(
                                requestId,
                                i,
                                AbstractDownloadOption.PreferredVideoHeight,
                                preferredVideoHeight);
                }

                if (preferredFileTypeChangedByUser)
                {
                    App.downloads.creator.setDownloadOption(
                            requestId,
                            i, AbstractDownloadOption.PreferredFileType,
                            preferredFileType);
                }

                if (preferredLanguageChangedByUser)
                {
                    App.downloads.creator.setDownloadOption(
                            requestId,
                            i, AbstractDownloadOption.PreferredLanguageCode,
                            preferredLanguage);
                }

                if (addDateOptionValChangedByUser)
                {
                    App.downloads.creator.setDownloadOption(
                                requestId,
                                i,
                                AbstractDownloadOption.AddDateToFileName,
                                addDateOptionVal);
                }

                if (needDownloadSubtitlesChangedByUser)
                {
                    App.downloads.creator.setDownloadOption(
                            requestId,
                            i,
                            AbstractDownloadOption.DownloadSubtitles,
                            needDownloadSubtitles);
                }

                if (preferredSubtitlesLanguagesCodesChangedByUser &&
                        needDownloadSubtitles)
                {
                    App.downloads.creator.setDownloadOption(
                                requestId,
                                i,
                                AbstractDownloadOption.PreferredSubtitlesLanguagesCodes,
                                preferredSubtitlesLanguagesCodes);
                }
            }
        }
    }

    function canRetrieveMoreDownloads() {
        return App.downloads.creator.canRetrieveMoreDownloads(requestId);
    }

    function retrieveMoreDownloads() {
        App.downloads.creator.retrieveMoreDownloads(requestId);
    }

    function newDownloadByRequest(request)
    {
        reset();
        requestId = request.id;
        var uiDownloadInfo = request.downloadInfo(0);
        var url = uiDownloadInfo.resourceUrl;
        if (typeof url === 'object')
            url = String(url);

        checkingIfAcceptableUrl = true;

        checkIfAcceptableUrl(url, function(acceptable, modulesUids, urlDescriptions, downloadsTypes)
        {
            checkingIfAcceptableUrl = false;

            setAcceptableUrl(url);
            modulesSelectedUid = "";

            if (acceptable) {

                for (var i = 0; i < downloadsTypes.length; i++) {
                    if (request.preferredDownloadType & downloadsTypes[i]) {
                        modulesSelectedUid = modulesUids[i];
                    }
                }

                updateModules(url, modulesUids, urlDescriptions);
            }

            request.setDownloadModuleUid(0, modulesSelectedUid);
            App.downloads.creator.create(request);
            buildingDownload = true;
            updateState();
        });
    }

    function reset()
    {
        requestId = -1;
        checkingIfAcceptableUrl = false;
        buildingDownload = false;
        buildingDownloadFinished = false;
        lastError = null;
        urlText = "";
        modulesUrl = "";
        modulesSelectedUid = "";
        updateState();
    }

    function resetTuneParams() {
        hasWriteAccess = true;
        previewUrl = "";
        preferredVideoHeight = 0;
        preferredVideoHeightChangedByUser = false;
        originFilesTypes = [];
        addDateToFileNameEnabled = false;
        preferredFileType = 0;
        preferredFileTypeChangedByUser = false;
        preferredLanguageEnabled = false;
        preferredLanguage = "";
        preferredLanguageChangedByUser = false;
        emptyDownloadsListWarning = false;
        batchDownloadLimitWarning = false;
        wrongFileNameWarning = false;
        emptyFileNameWarning = false;
        wrongFilePathWarning = false;
        setSubtitlesEnabled(false);
        needDownloadSubtitles = false;
        needDownloadSubtitlesChangedByUser = false;
        preferredSubtitlesLanguagesCodesChangedByUser = false;
    }

    function getUrlFromClipboard()
    {
        var text = App.clipboard.text.trim();

        if (text)
            text = text.split(/[\r\n]/)[0];

        if (checkIfAcceptableUrl(text, function(acceptable, modulesUids, urlDescriptions, downloadsTypes){
            if (acceptable) {
                setAcceptableUrl(text);
                updateModules(text, modulesUids, urlDescriptions);
            }
        }));
    }

    function checkIfAcceptableUrl(text, callback)
    {
        urlTools.checkIfAcceptableUrl(text, function(acceptable, modulesUids, urlDescriptions, downloadsTypes){
            callback(acceptable, modulesUids, urlDescriptions, downloadsTypes);
        });
    }

    function setBatchDownloadLimitWarning(val)
    {
        batchDownloadLimitWarning = val == batchDownloadMaxUrlsCount;
    }

    function setEmptyDownloadsListWarning(val)
    {
        emptyDownloadsListWarning = val;
    }

    function setAcceptableUrl(text)
    {
        disableAcceptableUrlCheck = true;
        urlText = text;
        disableAcceptableUrlCheck = false;
    }

    //not needed for modulesUids
    function silentDownload(text)
    {
        urlTools.checkIfAcceptableUrl(text, function(acceptable, modulesUids, urlDescriptions, downloadsTypes){
            if (acceptable) {
                var urlTools = App.tools.url(text)
                if (urlTools.correctUserInput()) {
                    text = urlTools.url
                }
                var req = App.downloads.newDownloadsRequests.createRequest(
                            text, "");
                requestId = req.id;
                App.downloads.creator.create(req);
                App.downloads.creator.add(requestId);
                root.createSilentDownload();
            }
        });
    }

    function updateState()
    {
        if (buildingDownload) {
            statusText = qsTr("Querying info. Please wait...");
            statusWarning = false;
        }
        else {
            statusText = "";
            statusWarning = false;
        }
    }

    function failed()
    {
        return lastError !== null;
    }

    function canIgnoreError()
    {
        return lastError.isUnwantedBehaviorError;
    }

    function cleanUpLastError()
    {
        lastError = null;
    }

    function onUrlTextChanged(new_text)
    {
        urlText = new_text;
        cleanUpLastError();
        updateState();

        if (!disableAcceptableUrlCheck &&
                urlText.length > 0)
        {
            checkIfAcceptableUrl(new_text, function(acceptable, modulesUids, urlDescriptions, downloadsTypes)
            {
                if (acceptable) {
                    updateModules(new_text, modulesUids, urlDescriptions);
                }
            });
        }
    }

    function updateModules(text, modulesUids, urlDescriptions) {
        if (urlText == text) {
            modulesUrl = text;
            modulesChanged(modulesUids, urlDescriptions);
        }
    }

    function selectModule(uid) {
        modulesSelectedUid = uid;
    }

    function addDownloadBeforeRequest()
    {
        App.downloads.creator.add(requestId);
        root.createDownloadBeforeRequest();
    }

    function createRequest()
    {
        var modeleUid = (urlText == modulesUrl)  ? modulesSelectedUid : "";
        urlText = urlText.trim();
        var user_input = urlText.trim();
        var urlTools = App.tools.url(user_input)
        if (urlTools.correctUserInput()) {
            user_input = urlTools.url
        }
        var req = App.downloads.newDownloadsRequests.createRequest(
                    user_input, modeleUid);
        requestId = req.id;
        App.downloads.creator.create(req);
        buildingDownload = true;
        updateState();
    }

    function doOK()
    {
        let unhbeherr = lastError && lastError.isUnwantedBehaviorError;

        cleanUpLastError();

        if (unhbeherr)
        {
            requestId = lastFailedRequestId;
            lastFailedRequestId = -1;
            buildingDownload = true;
            updateState();
            App.downloads.creator.ignoreUnwantedBehErrorAndContinueToBuild(requestId);
        }
        else if (downloadTools.buildingDownload && requestId !== -1)
        {
            addDownloadBeforeRequest();
        }
        else
        {
            createRequest();
        }
    }

    function doReject()
    {
        if (requestId !== -1)
            App.downloads.creator.abort(requestId, AbstractDownloadsUi.AbortedByUser);
        root.reject();
    }

    function doRejectLastFailedRequestId()
    {
        if (lastFailedRequestId !== -1)
            App.downloads.creator.abort(lastFailedRequestId, AbstractDownloadsUi.AbortedByUser);
        lastFailedRequestId = -1;
    }

    property var __singleDownloadFileInfo: null
    property var __singleDownloadFileInfoPathChangedSlotFn: null

    function connectToPathChangedSignal()
    {
        if (__singleDownloadFileInfo)
            return;
        if (App.downloads.creator.downloadCount(requestId) == 1)
        {
            let info = App.downloads.creator.downloadInfo(requestId, 0);
            if (info.filesCount)
            {
                __singleDownloadFileInfo = info.fileInfo(0);
                let id = requestId;
                __singleDownloadFileInfoPathChangedSlotFn = () => {
                    if (id === requestId)
                    getNameAndPath();
                };
                __singleDownloadFileInfo.pathChanged.connect(__singleDownloadFileInfoPathChangedSlotFn);
            }
        }
    }

    function disconnectFromPathChangedSignal()
    {
        if (__singleDownloadFileInfo)
        {
            __singleDownloadFileInfo.pathChanged.disconnect(__singleDownloadFileInfoPathChangedSlotFn);
            __singleDownloadFileInfoPathChangedSlotFn = null;
            __singleDownloadFileInfo = null;
        }
    }

    onRequestIdChanged: {
        disconnectFromPathChangedSignal();
        connectToPathChangedSignal();
    }

    Connections
    {
        target: App.downloads.creator

        onBuilt: (id) => {
            if (id === requestId) {
                buildingDownload = false;
                buildingDownloadFinished = true;
                disconnectFromPathChangedSignal();
                connectToPathChangedSignal();
                root.createRequestSuccess(requestId);
            }
        }

        onFailed: (id, error, allowedToReport) => {
            if (id === requestId)
            {
                buildingDownload = false;
                buildingDownloadFinished = false;
                disconnectFromPathChangedSignal();
                lastError = error.clone();
                allowedToReportLastError = allowedToReport;
                lastFailedRequestId = requestId;
                requestId = -1;
                updateState();
            }
        }

        onAborted: disconnectFromPathChangedSignal()

        onAdded: disconnectFromPathChangedSignal()

        onTagIdChanged: id => {
            var tagId = App.downloads.creator.tagId(id);
            relatedTag = tagId > 0 ? App.downloads.tags.tag(tagId) : null;
        }
    }

    // add download dialog
    function getNameAndPath()
    {
        var info = App.downloads.creator.downloadInfo(requestId, 0);

        var tagId = App.downloads.creator.tagId(requestId);
        relatedTag = tagId > 0 ? App.downloads.tags.tag(tagId) : null;

        if (batchDownload) {
            fileName = info.title;
            forceOverwriteFile = false;
            filePath = info.destinationPath;
            filesCount = 0;
            fileSize = -1;
            subtitlesList = App.knownLanguagesModel;
        } else {
            fileName = info.fileInfo(0).path;
            forceOverwriteFile = false;
            filePath = info.destinationPath;
            filesCount = info.filesCount;
            fileSize = info.selectedSize;
            subtitlesList = info.subtitlesModel();
            setSubtitlesEnabled(subtitlesList.rowCount() > 0);
            addDateToFileNameEnabled = (info.supportedOptions & AbstractDownloadOption.AddDateToFileName) != 0;
        }

        return info.id;
    }

    function initSubtitlesDefaults()
    {
        preferredSubtitlesLanguagesCodes = App.settings.downloadOptions.value(
                    AbstractDownloadOption.PreferredSubtitlesLanguagesCodes) || [];

        needDownloadSubtitles = App.settings.downloadOptions.value(
                    AbstractDownloadOption.DownloadSubtitles) || false;
    }

    function setPreferredSubtitlesLanguagesCodes(languageCode, byUser) {
        var i = preferredSubtitlesLanguagesCodes.indexOf(languageCode);
        if (i === -1) {
            preferredSubtitlesLanguagesCodes.push(languageCode);
        } else {
            preferredSubtitlesLanguagesCodes = preferredSubtitlesLanguagesCodes.filter(function(value, index, arr){ return index !== i;});
        }
        if (byUser)
            preferredSubtitlesLanguagesCodesChangedByUser = true;
    }

    function onFileNameTextChanged(new_text)
    {
        wrongFileNameWarning = false;
        emptyFileNameWarning = false;
        fileName = new_text;
        if (batchDownload && !fileName)
            emptyFileNameWarning = true;
    }

    function fileSizeValueChanged(new_size)
    {
        if (new_size >= 0) {
            fileSize = new_size;
        }
    }

    function onFilePathTextChanged(new_text)
    {
        filePath = new_text;
    }

    function isBatchDownload(id) {
        return App.downloads.creator.downloadCount(id) > 1;
    }

    function getResumeSupport(id) {

        let info = App.downloads.creator.downloadInfo(id, 0);
        return info ? info.resumeSupport : AbstractDownloadsUi.DownloadResumeSupportUnknown;
    }

    function addDownloadFromDialog()
    {
        var info = App.downloads.creator.downloadInfo(requestId, 0);
        if (info.filesCount === 1) {
            info.fileInfo(0).path = fileName;
            if (forceOverwriteFile)
                info.existingFileReaction = AbstractDownloadsUi.DefrOverwrite;
        }
        if (batchDownload)
        {
            info.title = fileName;
        }
        else
        {
            if (needDownloadSubtitlesChangedByUser)
            {
                App.downloads.creator.setDownloadOption(
                            requestId,
                            0,
                            AbstractDownloadOption.DownloadSubtitles,
                            needDownloadSubtitles);
            }

            if (preferredSubtitlesLanguagesCodesChangedByUser &&
                    needDownloadSubtitles)
            {
                App.downloads.creator.setDownloadOption(
                            requestId,
                            0,
                            AbstractDownloadOption.PreferredSubtitlesLanguagesCodes,
                            preferredSubtitlesLanguagesCodes);
            }
        }

        info.destinationPath = filePath;
        console.log("adding request id: ", requestId, " (downloadId: ", info.id, ")");
        App.downloads.creator.add(requestId);
        createDownloadFromDialog();
    }

    AcceptableUrlTool {
        id: urlTools
    }

    function selectQuality(index) {
        App.downloads.creator.resourceVersionSelector(requestId, 0).selectedVersion = index;
    }

    Connections {
        target: versionSelector
        onSelectedVersionChanged: {
            getNameAndPath();
        }
    }

    function selectBatchQuality(value) {
        App.downloads.creator.resourceVersionSelector(requestId, 0).selectedVersion = index;
    }

    function checkFilePathAsync() {
        App.storages.isValidAbsoluteFilePath(filePath);
    }

    function isBusy()
    {
        return requestId !== -1 &&
                (checkingIfAcceptableUrl || buildingDownload);
    }

    Connections
    {
        target: App.storages
        onIsValidAbsoluteFilePathResult: function(path, result) {
            if (path === filePath)
            {
                wrongFilePathWarning = !result;
                checkFilePathFinished();
            }
        }
    }
}
