import QtQuick 2.0

BaseContextMenu {
    Repeater {
        model: downloadTools.subtitlesList

        delegate: BaseContextMenuItem {
            text: languageName
            checkable: true
            checked: downloadTools.preferredSubtitlesLanguagesCodes.indexOf(languageCode) !== -1
            onTriggered: downloadTools.setPreferredSubtitlesLanguagesCodes(languageCode, true)
        }
    }
}
