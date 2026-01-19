import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.abstractdownloadsui 
import "../../common"

BaseComboBox {
    id: root

    model: [
        {text: qsTr("MD5"), algorithm: AbstractDownloadsUi.Md5, hash: ""},
        {text: qsTr("SHA-1"), algorithm: AbstractDownloadsUi.Sha1, hash: ""},
        {text: qsTr("SHA-256"), algorithm: AbstractDownloadsUi.Sha256, hash: ""},
        {text: qsTr("SHA-512"), algorithm: AbstractDownloadsUi.Sha512, hash: ""}
    ]

    onActivated: index => fileIntegrityTools.calculateHash(model[index].algorithm, model[index].hash)
}
