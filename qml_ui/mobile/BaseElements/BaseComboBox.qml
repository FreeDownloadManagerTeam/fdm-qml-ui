import QtQuick
import QtQuick.Controls
import "../../qt5compat"

ComboBox
{
    id: combo

    property int fontSize: 16
    property int comboMinimumWidth: 0

    FontMetrics {
        id: fm
        font.pixelSize: combo.fontSize
    }

    model: []
    textRole: "text"

    implicitHeight: Math.max(fm.height, img.implicitHeight) + 24

    implicitWidth: {
        let h = 0;
        for (let i = 0; i < model.length; ++i)
            h = Math.max(h, fm.advanceWidth(model[i].text));
        return Math.max(comboMinimumWidth, h + 40 + combo.fontSize*0);
    }

    indicator: Image {
        id: img
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

    contentItem: BaseLabel {
        text: combo.displayText
        color: appWindow.theme.foreground
        leftPadding: qtbug.leftPadding(10, 0)
        rightPadding: qtbug.rightPadding(10, 0)
        font.pixelSize: combo.fontSize
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter
        opacity: enabled ? 1 : 0.5
    }

    delegate: BaseLabel {
        id: label
        width: combo.width
        leftPadding: qtbug.leftPadding(10, 0)
        rightPadding: qtbug.rightPadding(10, 0)
        topPadding: 3
        bottomPadding: topPadding
        text: modelData.text
        font.pixelSize: combo.fontSize
        font.weight: index === currentIndex ? Font.DemiBold : Font.Normal
        elide: Text.ElideRight
        color: appWindow.theme.foreground

        MouseArea {
            anchors.fill: parent
            onClicked: {
                combo.currentIndex = index;
                combo.popup.close();
                combo.activated(index);
            }
        }
    }

    Component.onCompleted: {
        //////////////////////////////////////////////////////////////////////
        // QTBUG-139694 workaround
        popup.topMargin = Qt.binding(() => appWindow.SafeArea.margins.top);
        popup.leftMargin = Qt.binding(() => appWindow.SafeArea.margins.left);
        popup.bottomMargin = Qt.binding(() => appWindow.SafeArea.margins.bottom);
        popup.rightMargin = Qt.binding(() => appWindow.SafeArea.margins.right);
        //////////////////////////////////////////////////////////////////////
    }
}
