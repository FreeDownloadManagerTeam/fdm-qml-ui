import QtQuick 2.0
import org.freedownloadmanager.fdm 1.0

Item {
    signal newAuthenticationRequest()
    signal newSslRequest()
    signal hasMovingFailedDownloads(var downloadId, var error)

    signal hasDownloadRequests()
    signal newDownloadRequests()

    signal hasMergeRequests()
    signal newMergeRequests(var newDownloadId, var existingDownloadId)

    function getDownloadRequest()
    {
        if (hasDownloadRequestInQueue()) {
            var uiNewDownloadRequest = App.downloads.newDownloadsRequests.nextRequest();
            return uiNewDownloadRequest;
        }
        return false;
    }

    function getDownloadRequestUrl()
    {
        var request = getDownloadRequest();
        if (request) {
            var url = request.downloadInfo(0).resourceUrl;
            if (typeof url === 'object')
                url = String(url);
            return url;
        }
        return false;
    }

    function getMergeRequestId()
    {
        if (hasMergeRequestInQueue()) {
            return App.downloads.mergeOptionsChooser.nextNewDownloadPendingId();
        }
        return false;
    }

    function getExistingRequestId(newDownloadId)
    {
        if (hasMergeRequestInQueue()) {
            return App.downloads.mergeOptionsChooser.existingDownloadId(newDownloadId);
        }
        return false;
    }

    function getAuthRequest() {
        if (hasAuthRequestInQueue()) {
            return App.networkAuth.currentPendingRequest();
        }
        return false;
    }

    function hasAuthRequestInQueue() {
        return App.networkAuth.hasPendingRequests();
    }

    function getSslRequest() {
        if (hasSslRequestInQueue()) {
            return App.ignoreSslCertsErrs.currentPendingRequest();
        }
        return false;
    }

    function hasSslRequestInQueue() {
        return App.ignoreSslCertsErrs.hasPendingRequests();
    }

    function hasDownloadRequestInQueue()
    {
        return App.downloads.newDownloadsRequests.hasRequests();
    }

    function hasMergeRequestInQueue()
    {
        return App.downloads.mergeOptionsChooser.hasPendingNewDownloadIds();
    }

    function hasMovingFailedDownloadsInQueue()
    {
        return App.downloads.moveFilesMgr.pendingDownloadsIdsWithFailedMove.length > 0
    }

    function hasPendingMovingFailedDownloads() {
        if (hasMovingFailedDownloadsInQueue()) {
            hasMovingFailedDownloads(App.downloads.moveFilesMgr.pendingDownloadsIdsWithFailedMove[0], "")
        }
    }

    function checkRequests() {
        if (hasMergeRequestInQueue()){
            hasMergeRequests();
        } else if (hasAuthRequestInQueue()) {
            newAuthenticationRequest();
        } else if (hasDownloadRequestInQueue()) {
            hasDownloadRequests();
        } else {
            hasPendingMovingFailedDownloads();
        }
    }

    Connections {
        target: App.downloads.newDownloadsRequests
        onNewRequest: newDownloadRequests();
    }

    Connections
    {
        target: App.downloads.mergeOptionsChooser
        onGotMergeRequest: (newDownloadId, existingDownloadId) => newMergeRequests(newDownloadId, existingDownloadId);
    }

    Connections
    {
        target: App.networkAuth
        onGotRequest: newAuthenticationRequest();
    }

    Connections
    {
        target: App.ignoreSslCertsErrs
        onGotRequest: newSslRequest();
    }

    Connections
    {
        target: App.downloads.moveFilesMgr
        onMoveFinished: (downloadId, error) => {
                            if (downloadId && error.hasError)
                                hasMovingFailedDownloads(downloadId, error.displayTextShort)
                        }
    }

    Connections {
        target: appWindow
        onAppWindowStateChanged: checkRequests()
    }

    Component.onCompleted: checkRequests()
}
