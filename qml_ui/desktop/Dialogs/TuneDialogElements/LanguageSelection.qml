import QtQuick
import QtQuick.Layouts
import "../../../common/Tools"
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.abstractdownloadsui
import "../../BaseElements"

ColumnLayout
{
    visible: combo.count > 1

    property string selectedLanguage

    BaseLabel {
        Layout.topMargin: 6*appWindow.zoom
        text: qsTr("Language") + ':' + App.loc.emptyString
        dialogLabel: true
    }

    BaseComboBox {
        id: combo

        popupVisibleRowsCount: 7

        onActivated: apply()

        function apply()
        {
            if (currentIndex !== -1 && model.length > 1)
                selectedLanguage = model[currentIndex].value;
            else
                selectedLanguage = null;
        }
    }

    function initialization()
    {
        if (downloadTools.versionSelector.versionCount > 1)
        {
            let m = [];
            let selectedIndex = -1;
            let lngs = {};
            let selectedLng = downloadTools.versionSelector.selectedVersion >= 0 ?
                    downloadTools.versionSelector.language(downloadTools.versionSelector.selectedVersion) :
                    "" ;

            for (let i = 0; i < downloadTools.versionSelector.versionCount; i++)
            {
                let lng = downloadTools.versionSelector.language(i);

                if (lng in lngs)
                    continue;

                lngs[lng] = 1;

                if (selectedIndex === -1 && lng === selectedLng)
                    selectedIndex = m.length;

                m.push({'text': lng ? App.knownLanguagesModel.languageDisplayName(lng) : qsTr("Unknown"), value: lng});
            }

            if (selectedIndex === -1 && model.length)
                selectedIndex = 0;

            combo.model = m;
            combo.currentIndex = selectedIndex;
            combo.apply();
        }
        else
        {
            selectedLanguage = null;
            combo.model = [];
            combo.currentIndex = -1;
        }
    }
}
