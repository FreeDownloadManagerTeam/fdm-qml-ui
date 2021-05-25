import QtQuick 2.0
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.abstractdownloadsui 1.0

Item {

    id: root

    signal createDownloadBeforeRequest()
    signal createRequestSuccess(double id)
    signal createDownloadFromDialog()
    signal createSilentDownload()
    signal modulesChanged(var modulesUids, var urlDescriptions)

    signal finished(double id, bool added)
    signal reject()

    property double requestId: -1

    property bool buildingDownload: false
    property bool buildingDownloadFinished: false
    property string statusText: ""
    property bool statusWarning: false

    property string lastError: ""
    property int lastFailedRequestId: -1
    property string urlText

    property string filePath
    property string fileName
    property int filesCount
    property var fileSize
    property var freeDiskSpace
    property bool hasWriteAccess: true
    property string previewUrl

    property string modulesUrl
    property string modulesSelectedUid

    property int defaultPreferredVideoHeight: 1080
    property int preferredVideoHeight
    property int preferredFileType
    property var originFilesTypes
    property bool addDateToFileName
    property bool emptyDownloadsListWarning
    property bool notEnoughSpaceWarning: freeDiskSpace != -1 && fileSize > 0 && fileSize > freeDiskSpace
    property bool wrongFilePathWarning: false
    property bool wrongFileNameWarning: false

    property var versionSelector: null
    property int versionCount: versionSelector ? versionSelector.versionCount : 0

    property string authRealm
    property string authProxyText
    property var authRequest: null

    property string sslHost
    property string sslSha1Fingerprint
    property string sslSha256Fingerprint
    property var sslErrorsStrings: null
    property var sslRequest: null

    property bool batchDownload: false
    property int batchDownloadMaxUrlsCount: uiSettingsTools.settings.batchDownloadMaxUrlsCount
    property bool batchDownloadLimitWarning

    property bool subtitlesEnabled: false
    property int subtitlesCount: 0
    property var subtitlesList
    property var preferredSubtitlesLanguagesCodes: []
    property bool needDownloadSubtitles

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
            sslSha1Fingerprint = sslRequest.cert.sha1Fingerprint();
            sslSha256Fingerprint = sslRequest.cert.sha256Fingerprint();
            sslErrorsStrings = sslRequest.errorsStrings;
            sslHost = sslRequest.url.url;
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

    function setPreferredVideoHeight(val)
    {
        preferredVideoHeight = val;
    }

    function setPreferredFileType(val)
    {
        preferredFileType = val;
    }

    function setOriginFilesTypes(arr)
    {
        originFilesTypes = arr.length > 1 ? arr : [];
    }

    function setAddDateToFileName(val)
    {
        addDateToFileName = val;
    }

    function setSubtitlesEnabled(val)
    {
        subtitlesEnabled = val;
    }

    function saveAddDateToFileName(val) {
        //todo: save
    }

    function saveBatchDownloadOptions(addDateOptionVal) {
        if (batchDownload) {
//            checkPreferredSubtitlesLanguagesCodes();
            for (var i = 1; i < App.downloads.creator.downloadCount(requestId); i++) {
                App.downloads.creator.setDownloadOption(requestId, i, AbstractDownloadsUi.PreferredVideoHeight, preferredVideoHeight);
                App.downloads.creator.setDownloadOption(requestId, i, AbstractDownloadsUi.PreferredFileType, preferredFileType);
                App.downloads.creator.setDownloadOption(requestId, i, AbstractDownloadsUi.AddDateToFileName, addDateOptionVal);
                if (needDownloadSubtitles) {
                    App.downloads.creator.setDownloadOption(requestId, i, AbstractDownloadsUi.PreferredSubtitlesLanguagesCodes, preferredSubtitlesLanguagesCodes);
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

        if (checkIfAcceptableUrl(url, function(acceptable, modulesUids, urlDescriptions, downloadsTypes){
            if (acceptable) {
                urlText = url;
                modulesSelectedUid = "";

                for (var i = 0; i < downloadsTypes.length; i++) {
                    if (request.preferredDownloadType & downloadsTypes[i]) {
                        modulesSelectedUid = modulesUids[i];
                    }
                }

                updateModules(url, modulesUids, urlDescriptions);
                request.setDownloadModuleUid(0, modulesSelectedUid);
                App.downloads.creator.create(request);
                buildingDownload = true;
                updateState();
            }
        }));
    }

    function reset()
    {
        requestId = -1;
        buildingDownload = false;
        buildingDownloadFinished = false;
        lastError = "";
        urlText = "";
        modulesUrl = "";
        modulesSelectedUid = "";
        updateState();
    }

    function resetTuneParams() {
        hasWriteAccess = true;
        previewUrl = "";
        preferredVideoHeight = 0;
        originFilesTypes = [];
        addDateToFileName = false;
        preferredFileType = 0;
        emptyDownloadsListWarning = false;
        batchDownloadLimitWarning = false;
        wrongFileNameWarning = false;
        wrongFilePathWarning = false;
        setSubtitlesEnabled(false);
        needDownloadSubtitles = false;
    }

    function getUrlFromClipboard()
    {
        var text = App.clipboard.text;

        if (checkIfAcceptableUrl(text, function(acceptable, modulesUids, urlDescriptions, downloadsTypes){
            if (acceptable) {
                urlText = text;
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
        urlText = text;
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
        else if (failed()) {
            statusText = lastError;
            statusWarning = true;
        }
        else {
            statusText = "";
            statusWarning = false;
        }
    }

    function failed()
    {
        return lastError !== "";
    }

    function cleanUpLastError()
    {
        if (failed()) {
            lastError = "";
        }
    }

    function onUrlTextChanged(new_text)
    {
        urlText = new_text;
        cleanUpLastError();
        updateState();

        if (checkIfAcceptableUrl(new_text, function(acceptable, modulesUids, urlDescriptions, downloadsTypes){
            if (acceptable) {
                updateModules(new_text, modulesUids, urlDescriptions);
            }
        }));
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
        cleanUpLastError();
        if (downloadTools.buildingDownload && requestId !== -1) {
            addDownloadBeforeRequest();
        } else {
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

    Connections
    {
        target: App.downloads.creator
        onBuilt:
        {
            if (id === requestId)
            {
                buildingDownload = false;
                buildingDownloadFinished = true;
                root.createRequestSuccess(requestId);
            }
        }
        onFailed:
        {
            if (id === requestId)
            {
//                if (requestId !== -1)
//                    App.downloads.creator.abort(requestId, AbstractDownloadsUi.AbortedByUser);
                buildingDownload = false;
                buildingDownloadFinished = false;
                lastError = error;
                lastFailedRequestId = requestId;
                requestId = -1;
                updateState();
            }
        }
    }


    // add download dialog
    function getNameAndPath()
    {
        var info = App.downloads.creator.downloadInfo(requestId, 0);

        preferredSubtitlesLanguagesCodes = uiSettingsTools.settings.preferredSubtitlesLanguagesCodes;

        var tagId = App.downloads.creator.tagId(requestId);
        relatedTag = tagId > 0 ? App.downloads.tags.tag(tagId) : null;

        if (batchDownload) {
            fileName = info.title;
            filePath = info.destinationPath;
            filesCount = 0;
            fileSize = -1;
            subtitlesList = App.knownLanguagesModel;
        } else {
            fileName = info.fileInfo(0).path;
            filePath = info.destinationPath;
            filesCount = info.filesCount;
            fileSize = info.selectedSize;
            subtitlesList = info.subtitlesModel();
            setSubtitlesEnabled(subtitlesList.rowCount() > 0);
        }

        return info.id;
    }

    function setPreferredSubtitlesLanguagesCodes(languageCode) {
        var i = preferredSubtitlesLanguagesCodes.indexOf(languageCode);
        if (i === -1) {
            preferredSubtitlesLanguagesCodes.push(languageCode);
        } else {
            preferredSubtitlesLanguagesCodes = preferredSubtitlesLanguagesCodes.filter(function(value, index, arr){ return index !== i;});
        }

        uiSettingsTools.settings.preferredSubtitlesLanguagesCodes = preferredSubtitlesLanguagesCodes;
    }

    function onFileNameTextChanged(new_text)
    {
        wrongFileNameWarning = false;
        fileName = new_text;
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

    function addDownloadFromDialog()
    {
        var info = App.downloads.creator.downloadInfo(requestId, 0);
        if (info.filesCount === 1) {
            info.fileInfo(0).path = fileName;
        }
        if (batchDownload) {
            info.title = fileName;
        } else if (needDownloadSubtitles){
//            checkPreferredSubtitlesLanguagesCodes();
            App.downloads.creator.setDownloadOption(requestId, 0, AbstractDownloadsUi.PreferredSubtitlesLanguagesCodes, preferredSubtitlesLanguagesCodes);
        }

        info.destinationPath = filePath;
        console.log("adding request id: ", requestId, " (downloadId: ", info.id, ")");
        App.downloads.creator.add(requestId);
        createDownloadFromDialog();
    }
    // add download dialog

//    function checkPreferredSubtitlesLanguagesCodes() {
//        preferredSubtitlesLanguagesCodes = preferredSubtitlesLanguagesCodes.filter(function (element) { return subtitlesList.find(obj => { return obj.languageCode == element })});
//    }

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

    Connections {
        target: App.downloads.creator
        onTagIdChanged: {
            var tagId = App.downloads.creator.tagId(id);
            relatedTag = tagId > 0 ? App.downloads.tags.tag(tagId) : null;
        }
    }

    function selectBatchQuality(value) {
        App.downloads.creator.resourceVersionSelector(requestId, 0).selectedVersion = index;
    }

    function checkFileName() {
        if (filesCount === 1 || batchDownload) {
            var str = filePath + (filePath.slice(-1) == "/" ? "" : "/") + fileName;
            if (str != App.tools.sanitizeFilePath(str, '')) {
                wrongFileNameWarning = true;
                return false;
            }
        }
        return true;
    }

    function checkFilePath() {
        if (!App.tools.isValidAbsoluteFilePath(filePath)) {
            wrongFilePathWarning = true;
            return false;
        }
        return true;
    }
}
