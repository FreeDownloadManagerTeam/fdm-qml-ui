import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
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
