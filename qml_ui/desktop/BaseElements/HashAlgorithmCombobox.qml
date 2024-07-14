import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.abstractdownloadsui 1.0
import "../../common"

BaseComboBox {
    id: root

    rightPadding: 5*appWindow.zoom
    leftPadding: 5*appWindow.zoom

    model: [
        {text: qsTr("MD5"), algorithm: AbstractDownloadsUi.Md5, hash: ""},
        {text: qsTr("SHA-1"), algorithm: AbstractDownloadsUi.Sha1, hash: ""},
        {text: qsTr("SHA-256"), algorithm: AbstractDownloadsUi.Sha256, hash: ""},
        {text: qsTr("SHA-512"), algorithm: AbstractDownloadsUi.Sha512, hash: ""}
    ]

    onActivated: index => fileIntegrityTools.calculateHash(model[index].algorithm, model[index].hash)
}
