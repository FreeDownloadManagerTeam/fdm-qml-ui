import QtQuick
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import "../../BaseElements"

ColumnLayout
{
    visible: downloadTools.preferredLanguageEnabled

    BaseLabel {
        Layout.topMargin: 6*appWindow.zoom
        text: qsTr("Language") + ':' + App.loc.emptyString
        dialogLabel: true
    }

    BaseComboBox {
        id: combo

        popupVisibleRowsCount: 7

        Layout.minimumWidth: 200*appWindow.zoom

        model: {
            let m = App.knownLanguagesModel.toQmlModel();
            m.unshift({"languageName": "—", "languageCode": ""});
            return m;
        }

        textRole: "languageName"

        onActivated: index => downloadTools.setPreferredLanguage(combo.model[index].languageCode, true)

        onVisibleChanged: {
            if (visible)
                updateState();
        }

        function updateState()
        {
            for (let i = 0; i < model.length; ++i)
            {
                if (model[i].languageCode === downloadTools.preferredLanguage)
                {
                    combo.currentIndex = i;
                    break;
                }
            }
        }
    }
}
