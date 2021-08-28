/* ListView.itemAtIndex was added only in Qt 5.13.
 * We use Qt 5.12, so we can't calculate using information provided by delegates.
 * So we have to use C++ model tracker instead.
*/

import QtQuick 2.12
import org.freedownloadmanager.fdm 1.0

Item
{
    property var header: null

    property bool downloadsViewSpeedColumnHovered: false
    property int  downloadsViewSpeedColumnHoveredWidth: 0
    property double downloadsViewSpeedColumnNotHoveredSinceTime: 0
    property bool downloadsViewShowingCompleteMsg: false

    QtObject
    {
        id: d
        property int speedColumnHoveredWidth: 0
    }

    FontMetrics {
        id: fm9_11
        font.pixelSize: appWindow.compactView ? 9 : 11
        font.family: Qt.platform.os === "osx" ? font.family : "Arial"
    }

    FontMetrics {
        id: fm11_12
        font.pixelSize: appWindow.compactView ? 11 : 12
        font.family: Qt.platform.os === "osx" ? font.family : "Arial"
    }

    FontMetrics {
        id: fmDefSize
        font.pixelSize: appWindow.fonts.defaultSize
        font.family: Qt.platform.os === "osx" ? font.family : "Arial"
    }

    Component.onCompleted: calc()

    Connections {
        target: App.loc
        onCurrentTranslationChanged: calc()
    }

    Connections
    {
        target: appWindow
        onCurrentTimeChanged: updateSpeedColumnHoveredWidth()
    }
    onDownloadsViewSpeedColumnHoveredChanged: updateSpeedColumnHoveredWidth()
    onDownloadsViewSpeedColumnHoveredWidthChanged: updateSpeedColumnHoveredWidth()
    onDownloadsViewSpeedColumnNotHoveredSinceTimeChanged: updateSpeedColumnHoveredWidth()

    function updateSpeedColumnHoveredWidth()
    {
        // keep hovered width at max recent value + 30 minutes after leaving hovered state
        var w = downloadsViewSpeedColumnHovered ?
                    Math.max(d.speedColumnHoveredWidth, downloadsViewSpeedColumnHoveredWidth) :
                    (appWindow.currentTime - downloadsViewSpeedColumnNotHoveredSinceTime < 30*60*1000) ? d.speedColumnHoveredWidth :
                    0;
        if (w != d.speedColumnHoveredWidth)
            d.speedColumnHoveredWidth = w;
    }

    function calc()
    {
        const p = 7*2; // padding

        const nameColumnMaxWidth = 188;
        const statusColumnMaxWidth = 150;
        const speedColumnMaxWidth = 150;
        const sizeColumnMaxWidth = 108;
        const dateColumnMaxWidth = 85;

        header.nameColumnWidth = Qt.binding(function() {
            return Math.min(fmDefSize.advanceWidth(
                                App.downloads.modelTracker.longestTitle) + p + fmDefSize.font.pixelSize*0,
                            nameColumnMaxWidth);
        });

        header.statusColumnWidth = Qt.binding(function() {
            if (App.downloads.modelTracker.lockedOperations.length > 0 ||
                    downloadsViewShowingCompleteMsg ||
                    App.downloads.modelTracker.hasMergingFiles)
            {
                return statusColumnMaxWidth;
            }
            else
            {
                var minw = 0;
                if (App.downloads.modelTracker.hasNonFinishedDownloadsWoError)
                {
                    const pausedStr = qsTr("Paused");
                    var w = fm11_12.advanceWidth(pausedStr+" 100%");
                    if (!appWindow.compactView)
                        w += 15;
                    minw = Math.max(minw, w + p + fm11_12.font.pixelSize*0);
                }
                var err = App.downloads.modelTracker.longestError;
                if (App.downloads.modelTracker.hasMissingFiles)
                {
                    const missingFilesStr = qsTr("File is missing");
                    if (missingFilesStr.length > err.length)
                        err = missingFilesStr;
                }
                if (App.downloads.modelTracker.hasMissingStorage)
                {
                    const missingStorageStr = qsTr("Disk is missing");
                    if (missingStorageStr.length > err.length)
                        err = missingStorageStr;
                }
                if (err.length > 0)
                    minw = Math.max(minw, fmDefSize.advanceWidth(err) + 17 + 3 + fmDefSize.font.pixelSize*0); // 17 - error icon width
                return Math.min(minw + p, statusColumnMaxWidth);
            }
        });

        header.speedColumnWidth = Qt.binding(function() {
            if (App.downloads.modelTracker.speedValuesCount > 1)
                return speedColumnMaxWidth;
            var w = 0;
            if (appWindow.btSupported)
            {
                w = 16 + 5 + fm9_11.advanceWidth(appWindow.btS.speedHoverLongestText() + App.loc.emptyString) +
                        fm9_11.font.pixelSize*0 + 10 + p;
            }
            if (App.downloads.modelTracker.hasDisabledPostFinishedTasks)
            {
                const uploadPausedStr = qsTr("Upload paused");
                var ww = fm9_11.advanceWidth(uploadPausedStr) + fm9_11.font.pixelSize*0;
                w = Math.max(w, Math.min(ww+20+p, speedColumnMaxWidth*2/3)); // force two lines of text if the width is too big
            }
            if (App.downloads.modelTracker.speedValuesCount > 0)
                w = Math.max(w, speedColumnMaxWidth/2);
            return Math.min(w, speedColumnMaxWidth);
        });

        header.sizeColumnWidth = Qt.binding(function() {
            return App.downloads.modelTracker.hasNonFinishedDownloads ?
                        sizeColumnMaxWidth :
                        sizeColumnMaxWidth/2+p/2;
        });

        header.dateColumnWidth = dateColumnMaxWidth;
    }
}
