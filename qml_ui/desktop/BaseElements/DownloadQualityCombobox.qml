import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "../../common"

BaseComboBox {
    id: root

    rightPadding: 5*appWindow.zoom
    leftPadding: 5*appWindow.zoom

    popupVisibleRowsCount: 7

    onActivated: index => downloadTools.selectQuality(index)
}
