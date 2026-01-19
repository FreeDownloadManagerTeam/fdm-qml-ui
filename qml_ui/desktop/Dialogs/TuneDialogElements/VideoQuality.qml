import QtQuick
import QtQuick.Layouts
import "../../../common/Tools"
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.abstractdownloadsui 
import "../../BaseElements"

ColumnLayout {
    visible: downloadTools.versionCount > 1

    property string lngFilter

    BaseLabel {
        Layout.topMargin: 6*appWindow.zoom
        text: qsTr("Quality:") + App.loc.emptyString
        dialogLabel: true
    }

    DownloadQualityCombobox {
        id: combo
    }

    function initialization()
    {
        if (downloadTools.versionSelector.versionCount > 1)
        {
            let m = [];
            let selectedIndex = -1;
            const sv = downloadTools.versionSelector.selectedVersion;

            for (let i = 0; i < downloadTools.versionSelector.versionCount; i++)
            {
                let lng = downloadTools.versionSelector.language(i);
                if (lngFilter && lng != lngFilter)
                    continue;

                if (i === sv)
                {
                    selectedIndex = m.length;
                }
                else if (selectedIndex === -1)
                {
                    if (downloadTools.versionSelector.fileType(i) == downloadTools.versionSelector.fileType(sv) &&
                            downloadTools.versionSelector.format(i) == downloadTools.versionSelector.format(sv) &&
                            downloadTools.versionSelector.quality(i) == downloadTools.versionSelector.quality(sv))
                    {
                        selectedIndex = m.length;
                    }
                }

                let v = ( downloadTools.versionSelector.fileType(i) == AbstractDownloadsUi.AudioFile ? 'Audio ' : '' )
                        + downloadTools.versionSelector.format(i).toUpperCase() + ' '
                        + downloadTools.versionSelector.quality(i);

                let size = downloadTools.versionSelector.size(i);
                if (size > 0)
                    v += ' ' + App.bytesAsText(downloadTools.versionSelector.size(i));

                m.push({'text': v, value: i});
            }

            if (selectedIndex === -1 && m.length)
                selectedIndex = 0;

            combo.model = m;
            combo.currentIndex = selectedIndex;
            combo.apply();
        }
        else
        {
            combo.model = [];
            combo.currentIndex = -1;
        }
    }

    onLngFilterChanged: initialization()
}
