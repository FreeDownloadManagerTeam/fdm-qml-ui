import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.abstractdownloadsui 1.0
import "../../common"

ComboBox {
    id: root

    rightPadding: 5*appWindow.zoom
    leftPadding: 5*appWindow.zoom

    property int visibleRowsCount: model.length

    model: [
        {text: qsTr("MD5"), algorithm: AbstractDownloadsUi.Md5, hash: ""},
        {text: qsTr("SHA-1"), algorithm: AbstractDownloadsUi.Sha1, hash: ""},
        {text: qsTr("SHA-256"), algorithm: AbstractDownloadsUi.Sha256, hash: ""},
        {text: qsTr("SHA-512"), algorithm: AbstractDownloadsUi.Sha512, hash: ""}
    ]

    textRole: "text"

    onActivated: fileIntegrityTools.calculateHash(model[index].algorithm, model[index].hash)

    delegate: Rectangle {
        property bool hover: false
        color: hover ? appWindow.theme.menuHighlight : "transparent"
        height: 30*appWindow.zoom
        width: parent.width
        BaseLabel {
            anchors.left: parent.left
            leftPadding: qtbug.leftPadding(6*appWindow.zoom, 0)
            rightPadding: qtbug.rightPadding(6*appWindow.zoom, 0)
            anchors.verticalCenter: parent.verticalCenter
            text: modelData.text
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: parent.hover = true
            onExited: parent.hover = false
            onClicked: {
                root.currentIndex = index
                root.popup.close();
                fileIntegrityTools.calculateHash(root.model[index].algorithm, root.model[index].hash)
            }
        }
    }

    background: Rectangle {
        color: appWindow.theme.background
        border.color: appWindow.theme.border
        border.width: 1*appWindow.zoom
    }

    contentItem: BaseLabel {
        verticalAlignment: Label.AlignVCenter
        text: root.displayText
    }

    indicator: Rectangle {
        x: LayoutMirroring.enabled ? 0 : root.width - width
        y: root.topPadding + (root.availableHeight - height) / 2
        width: height - 1*appWindow.zoom
        height: root.height
        color: "transparent"
        border.width: 1*appWindow.zoom
        border.color: appWindow.theme.border
        Rectangle {
            width: 9*appWindow.zoom
            height: 8*appWindow.zoom
            color: "transparent"
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            clip: true
            WaSvgImage {
                source: appWindow.theme.elementsIcons
                zoom: appWindow.zoom
                x: 0
                y: -448*zoom
            }
        }
    }

    popup: Popup {
        y: root.height - 1
        width: root.width
        height: visibleRowsCount * 30*appWindow.zoom + 2*appWindow.zoom
        padding: 1*appWindow.zoom

        background: Rectangle {
            color: appWindow.theme.background
            border.color: appWindow.theme.border
            border.width: 1*appWindow.zoom
        }

        contentItem: Item {
            ListView {
                clip: true
                anchors.fill: parent
                model: root.model
                currentIndex: root.highlightedIndex
                delegate: root.delegate
            }
        }
    }
}
