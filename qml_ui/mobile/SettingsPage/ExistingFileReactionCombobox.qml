import QtQuick 2.10
import QtQuick.Controls 2.4
import "../../qt5compat"
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.appsettings 1.0
import org.freedownloadmanager.fdm.dmcoresettings 1.0
import org.freedownloadmanager.fdm.abstractdownloadsui 1.0
import "../BaseElements"

Item
{
    implicitHeight: combo.implicitHeight
    implicitWidth: combo.implicitWidth

    property int existingFileReaction: App.settings.dmcore.value(DmCoreSettings.ExistingFileReaction)

    ComboBox
    {
        id: combo
        anchors.fill: parent
        model: []
        displayText: currentText
        textRole: "text"
        font.pixelSize: 16
        anchors.leftMargin: 20
        implicitWidth: 200
        indicator: Image {
            id: img2
            opacity: enabled ? 1 : 0.5
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            source: Qt.resolvedUrl("../../images/arrow_drop_down.svg")
            sourceSize.width: 24
            sourceSize.height: 24
            layer {
                effect: ColorOverlay {
                    color: appWindow.theme.foreground
                }
                enabled: true
            }
        }
        contentItem: Text {
            text: combo.displayText
            color: appWindow.theme.foreground
            leftPadding: qtbug.leftPadding(10, 0)
            rightPadding: qtbug.rightPadding(10, 0)
            font: combo.font
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            opacity: enabled ? 1 : 0.5
        }
        delegate: Rectangle {
            height: 35
            width: combo.width
            color: appWindow.theme.background
            Label {
                id: label
                leftPadding: qtbug.leftPadding(10, 0)
                rightPadding: qtbug.rightPadding(10, 0)
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                text: modelData.text
                font.pixelSize: 16
                width: parent.width
                elide: Text.ElideRight
                color: appWindow.theme.foreground
                horizontalAlignment: Text.AlignLeft
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    combo.currentIndex = index;
                    combo.popup.close();
                    App.settings.dmcore.setValue(DmCoreSettings.ExistingFileReaction, modelData.value);
                }
            }
        }

        function reloadCombo() {
            combo.model = [
                        {text: qsTr("Rename"), value: AbstractDownloadsUi.DefrRename},
                        {text: qsTr("Overwrite"), value: AbstractDownloadsUi.DefrOverwrite},
                        {text: qsTr("Always ask"), value: AbstractDownloadsUi.DefrAsk},
                    ];
            combo.currentIndex = combo.model.findIndex(e => e.value === existingFileReaction);
        }
    }

    Component.onCompleted: combo.reloadCombo()

    Connections {
        target: App.loc
        onCurrentTranslationChanged: combo.reloadCombo()
    }
}
