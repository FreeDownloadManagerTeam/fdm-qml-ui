import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "../../common"

BaseComboBox {
    id: root

    popupVisibleRowsCount: 7

    onActivated: index => downloadTools.selectQuality(index)
}
