import QtQuick 2.0
import QtQuick.Layouts 1.3
import "../../../common/Tools"
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.abstractdownloadsui 1.0
import "../../BaseElements"

ColumnLayout {
    visible: downloadTools.versionCount > 1

    BaseLabel {
        Layout.topMargin: 6*appWindow.zoom
        text: qsTr("Quality:") + App.loc.emptyString
    }

    DownloadQualityCombobox {
        id: combo
    }

    function initialization() {
        downloadTools.versionSelector = App.downloads.creator.resourceVersionSelector(requestId, 0);
        if (downloadTools.versionSelector.versionCount > 1) {
            var m = [];
            var index = combo.currentIndex;
            for (var i = 0; i < downloadTools.versionSelector.versionCount; i++) {
                if (i == downloadTools.versionSelector.selectedVersion) {
                    index = i;
                }
                var v = ( downloadTools.versionSelector.fileType(i) == AbstractDownloadsUi.AudioFile ? 'Audio ' : '' )
                        + downloadTools.versionSelector.format(i).toUpperCase() + ' '
                        + downloadTools.versionSelector.quality(i);
                var size = downloadTools.versionSelector.size(i);
                if (size > 0)
                    v += ' ' + App.bytesAsText(downloadTools.versionSelector.size(i));
                m.push({'text': v, value: i});
            }
            downloadTools.fileSizeValueChanged(downloadTools.versionSelector.size(index));
            combo.model = m;
            combo.currentIndex = index;
        }
        else
        {
            combo.model = [];
            combo.currentIndex = -1;
        }
    }
}
