import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../common"

BaseComboBox {
    id: root

    popupVisibleRowsCount: 7

    onActivated: apply()

    function apply()
    {
        if (currentIndex !== -1)
        {
            let index = model[currentIndex].value;
            downloadTools.selectQuality(index);
            downloadTools.fileSizeValueChanged(downloadTools.versionSelector.size(index))
        }
    }
}
