import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.abstractdownloadsui 
import org.freedownloadmanager.fdm.abstractdownloadoption
import "../../BaseElements"
import "../../BaseElements/V2"
import "../../../common"

ColumnLayout {
    visible: downloadTools.batchDownload
    Layout.topMargin: 8*appWindow.zoom
    Layout.fillWidth: true
    Layout.preferredHeight: Math.min(list.count * 26*appWindow.fontZoom + 35*appWindow.zoom, Math.max(130*appWindow.fontZoom, ((appWindow.height <= 680*appWindow.zoom) ? appWindow.height - 480*appWindow.zoom : (appWindow.height > 680*appWindow.zoom && appWindow.height < 810*appWindow.zoom ? 200*appWindow.zoom : appWindow.height - 610*appWindow.zoom))))
    spacing: 5*appWindow.zoom

    property bool showAgeCol
    property bool showMediaDurationCol

    readonly property var ignoredDownloads: {
        let arr = [];
        if (App.downloads.creator.ignoredDuplicateDownloadsCount(requestId))
            arr.push(qsTr("duplicates (%1)").arg(App.downloads.creator.ignoredDuplicateDownloadsCount(requestId)) + App.loc.emptyString);
        if (App.downloads.creator.ignoredInvalidDownloadsCount(requestId))
            arr.push(qsTr("invalid (%1)").arg(App.downloads.creator.ignoredInvalidDownloadsCount(requestId)) + App.loc.emptyString);
        if (App.downloads.creator.ignoredUnsupportedDownloadsCount(requestId))
            arr.push(qsTr("unsupported (%1)").arg(App.downloads.creator.ignoredUnsupportedDownloadsCount(requestId)) + App.loc.emptyString);
        return arr;
    }

    RowLayout {
        visible: ignoredDownloads.length

        SvgImage_V2 {
            source: Qt.resolvedUrl("V2/alert.svg")
            imageColor: appWindow.theme_v2.primary
        }

        BaseLabel {
            text: qsTr("Skipped downloads") + ": " + ignoredDownloads.join(", ") + App.loc.emptyString
            color: appWindow.theme_v2.primary
        }
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 20*appWindow.zoom
        color: "transparent"

        BaseLabel {
            text: qsTr("Download links (%1 selected)").arg(list.checkedUrlsCount) + App.loc.emptyString
            anchors.left: parent.left
        }

        BaseLabel {
            text: qsTr("Select all") + App.loc.emptyString
            color: appWindow.uiver === 1 ? linkColor : appWindow.theme_v2.primary
            anchors.right: selectNone.left
            anchors.rightMargin: 20*appWindow.zoom
            MouseArea {
                anchors.fill: parent
                cursorShape: appWindow.uiver === 1 ? Qt.ArrowCursor : Qt.PointingHandCursor
                onClicked: {
                    setAllFilesToDownload(true);
                    list.positionViewAtBeginning();
                }
            }
        }

        BaseLabel {
            id: selectNone
            text: qsTr("Select none") + App.loc.emptyString
            color: appWindow.uiver === 1 ? linkColor : appWindow.theme_v2.primary
            anchors.right: parent.right
            MouseArea {
                anchors.fill: parent
                cursorShape: appWindow.uiver === 1 ? Qt.ArrowCursor : Qt.PointingHandCursor
                onClicked: setAllFilesToDownload(false)
            }
        }
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.fillHeight: true
        border.color: appWindow.uiver === 1 ?
                          appWindow.theme.border :
                          "transparent"
        border.width: appWindow.uiver === 1 ?
                          1*appWindow.zoom :
                          0
        color: appWindow.uiver === 1 ?
                   appWindow.theme.background :
                   appWindow.theme_v2.bgColor

        ButtonGroup {
            id: downloadsListGroup
            exclusive: false
            onCheckStateChanged: downloadTools.setEmptyDownloadsListWarning(checkState === Qt.Unchecked)
        }

        ListView {
            id: list
            anchors.fill: parent
            spacing: 10*appWindow.zoom
            clip: true
            anchors.topMargin: 5*appWindow.zoom
            anchors.bottomMargin: 5*appWindow.zoom

            flickableDirection: Flickable.VerticalFlick
            ScrollBar.vertical: BaseScrollBar_V2 {
                id: lvsb
                minimumSize: 0.2*appWindow.zoom

                onVisualPositionChanged: {
                    if (visualPosition + visualSize == 1) {
                        tryToRetrieveMoreDownloads();
                    }
                }
            }
            boundsBehavior: Flickable.StopAtBounds

            property int checkedUrlsCount

            onFlickEnded: {
                if (list.atYEnd /*&& list.count < downloadTools.batchDownloadMaxUrlsCount*/) {
                    tryToRetrieveMoreDownloads();
                }
            }

            model: ListModel {}

            delegate: RowLayout {
                width: parent.width - lvsb.myWrapSize
                spacing: 10*appWindow.zoom

                BaseCheckBox {
                    id: label
                    text: (index + 1) + ". " + title
                    checkBoxStyle: "black"
                    fontSize: 13*appWindow.fontZoom
                    Layout.fillWidth: true
                    textColor: checked ? appWindow.theme.foreground : "#737373"
                    checked: !excluded
                    onCheckedChanged: markDownloadAsExcluded(index, checked);
                    ButtonGroup.group: downloadsListGroup
                    enabled: checked || list.checkedUrlsCount < downloadTools.batchDownloadMaxUrlsCount

                    MouseArea {
                        id: mouseAreaLabel
                        propagateComposedEvents: true
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: function (mouse) {mouse.accepted = false;}
                        onPressed: function (mouse) {mouse.accepted = false;}

                        BaseToolTip {
                            text: title
                            visible: label.truncated && mouseAreaLabel.containsMouse
                            width: 250*appWindow.zoom
                            onVisibleChanged: {
                                if (visible) {
                                    x = mouseAreaLabel.mouseX
                                    y = mouseAreaLabel.mouseY + 20*appWindow.zoom
                                }
                            }
                        }

                        Popup {
                            visible: remotePreviewImgUrl && mouseAreaLabel.containsMouse && !list.flicking
                            parent: tuneDialog.overlay
                            x: label.x + 27*appWindow.zoom
                            y: label.y - 115*appWindow.zoom
                            contentItem: Image {
                                source: remotePreviewImgUrl
                                sourceSize.width: 200*appWindow.zoom
                                sourceSize.height: 100*appWindow.zoom
                            }
                        }
                    }
                }

                BaseLabel {
                    id: ageHrLabel
                    visible: showAgeCol
                    text: ageHr
                    Layout.preferredWidth: 90*appWindow.zoom
                    elide: Label.ElideRight
                    font.pixelSize: 13*appWindow.fontZoom

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true

                        BaseToolTip {
                            text: ageHrLabel.text
                            visible: ageHrLabel.truncated && parent.containsMouse
                        }
                    }
                }

                BaseLabel {
                    visible: showMediaDurationCol
                    text: "[" + mediaDurationHr + "]"
                    Layout.preferredWidth: 80*appWindow.zoom
                    elide: Label.ElideRight
                    horizontalAlignment: Text.AlignRight
                    font.pixelSize: 13*appWindow.fontZoom
                }
            }

            footer: BusyIndicator {
                visible: false
                running: visible
                height: visible ? undefined : 0
            }
        }
    }

    function tryToRetrieveMoreDownloads() {
        if (downloadTools.canRetrieveMoreDownloads()) {
            list.footerItem.visible = true;
            downloadTools.retrieveMoreDownloads();
        }
    }

    function setAllFilesToDownload(value) {
        if (value && list.model.count > downloadTools.batchDownloadMaxUrlsCount) {
            setAllFilesToDownload(false);
        }

        for (var i = 0; i < list.model.count; i++) {
            markDownloadAsExcluded(i, value);
        }
    }

    function markDownloadAsExcluded(index, value) {
        var item = list.model.get(index);
        if (item.excluded !== !value) {
            if (value && list.checkedUrlsCount >= downloadTools.batchDownloadMaxUrlsCount) {
                return;
            }
            list.checkedUrlsCount += value ? 1 : -1;
            downloadTools.setBatchDownloadLimitWarning(list.checkedUrlsCount);
        }
        list.model.setProperty(index, 'excluded', !value);
        var fileIndex = list.model.get(index).fileIndex;
        App.downloads.creator.markDownloadAsExcluded(downloadTools.requestId, fileIndex, !value);
    }

    function initialization() {
        list.model.clear();
        list.checkedUrlsCount = 0;
        showAgeCol = false;
        showMediaDurationCol = false;
        loadRows();
    }

    function loadRows() {
        var request;
        var preferredVideoHeightEnabled = false;
        var preferredLanguageEnabled = false;
        var preferredFileTypeEnabled = false;
        var originFilesTypes = [];
        var addDateToFileNameEnabled = false;
        var subtitlesEnabled = false;
        var allDownloadsExcluded = true;
        var excluded;

        var firstIndex = list.count ? list.count : 0;

        for (var i = firstIndex; i < App.downloads.creator.downloadCount(requestId) - 1; i++) {
            request = App.downloads.creator.downloadInfo(requestId, (i + 1));

            if (!firstIndex) {
                if (request.mediaDurationHr) {
                    showMediaDurationCol = true;
                }
                if (request.ageHr) {
                    showAgeCol = true;
                }

                preferredVideoHeightEnabled = preferredVideoHeightEnabled || (request.supportedOptions & AbstractDownloadOption.PreferredVideoHeight) != 0;
                preferredLanguageEnabled = preferredLanguageEnabled || (request.supportedOptions & AbstractDownloadOption.PreferredLanguageCode) != 0;
                preferredFileTypeEnabled = preferredFileTypeEnabled || (request.supportedOptions & AbstractDownloadOption.PreferredFileType) != 0;
                addDateToFileNameEnabled = addDateToFileNameEnabled || (request.supportedOptions & AbstractDownloadOption.AddDateToFileName) != 0;
                subtitlesEnabled = subtitlesEnabled || (request.supportedOptions & AbstractDownloadOption.DownloadSubtitles) != 0;

                if (request.supportedOptions & AbstractDownloadOption.PreferredFileType) {
                    for (var j = 0; j < request.originFilesTypes.length; j++) {
                        if (request.originFilesTypes[j] != AbstractDownloadsUi.UnknownFile && originFilesTypes.indexOf(request.originFilesTypes[j]) === -1) {
                            originFilesTypes.push(request.originFilesTypes[j]);
                        }
                    }
                }
            }

            excluded = App.downloads.creator.isDownloadMarkedAsExcluded(requestId, i+1);
            allDownloadsExcluded = allDownloadsExcluded && excluded;
            list.checkedUrlsCount += excluded ? 0 : 1;
            downloadTools.setBatchDownloadLimitWarning(list.checkedUrlsCount);

            list.model.insert(i, {'title': request.title, 'fileIndex': (i + 1), 'excluded': excluded, 'mediaDurationHr': request.mediaDurationHr, 'ageHr': request.ageHr, 'remotePreviewImgUrl': request.remotePreviewImgUrl.toString()});
        }

        if (!firstIndex) {
            if (preferredVideoHeightEnabled)
                downloadTools.setPreferredVideoHeight(App.settings.downloadOptions.value(AbstractDownloadOption.PreferredVideoHeight) || downloadTools.defaultPreferredVideoHeight);
            if (preferredLanguageEnabled)
                downloadTools.setPreferredLanguage(App.settings.downloadOptions.value(AbstractDownloadOption.PreferredLanguageCode) || downloadTools.defaultPreferredLanguage);
            if (preferredFileTypeEnabled)
                downloadTools.setPreferredFileType(App.settings.downloadOptions.value(AbstractDownloadOption.PreferredFileType) || AbstractDownloadsUi.VideoFile);
            downloadTools.setOriginFilesTypes(originFilesTypes);
            downloadTools.setAddDateToFileNameEnabled(addDateToFileNameEnabled);
            downloadTools.setSubtitlesEnabled(subtitlesEnabled);
            downloadTools.setEmptyDownloadsListWarning(allDownloadsExcluded);
        }
    }

    Connections {
        target: App.downloads.creator
        onFinishedRetrievingMoreDownloads: {
            if (id == requestId) {
                list.footerItem.visible = false;
                loadRows();
            }
        }
    }
}
