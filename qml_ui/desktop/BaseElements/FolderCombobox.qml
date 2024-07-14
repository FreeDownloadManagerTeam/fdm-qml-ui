import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0
import "../../common"
import "../../qt5compat"

BaseComboBox {
    id: root

    rightPadding: 5*appWindow.zoom
    leftPadding: 5*appWindow.zoom
    implicitHeight: 30*appWindow.zoom

    editable: true

    popupVisibleRowsCount: 7
    comboMaximumWidth: Math.round(appWindow.width*0.8)

    signal folderRemoved(var path)

    delegate: Rectangle {
        id: delegateRoot

        property bool hover: false
        color: hover ? appWindow.theme.menuHighlight : "transparent"
        height: 30*appWindow.zoom
        width: parent ? parent.width : 0

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 6*appWindow.zoom
            anchors.rightMargin: 6*appWindow.zoom

            BaseLabel {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                text: modelData.text
                elide: Text.ElideRight

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: delegateRoot.hover = true
                    onExited: delegateRoot.hover = false
                    onClicked: {
                        root.currentIndex = index;
                        root.editText = App.toNativeSeparators(modelData.text);
                        root.popup.close();
                    }
                }

                BaseToolTip
                {
                    text: parent.text
                    visible: delegateRoot.hover && parent.truncated
                }
            }

            WaSvgImage {
                visible: root.model.length > 1
                Layout.alignment: Qt.AlignVCenter
                Layout.leftMargin: qtbug.leftMargin(0, 6*appWindow.zoom)
                Layout.rightMargin: qtbug.rightMargin(0, 6*appWindow.zoom)

                zoom: appWindow.zoom
                source: appWindow.macVersion ? Qt.resolvedUrl("../../images/desktop/search_clear_mac.svg") :
                                               Qt.resolvedUrl("../../images/desktop/clean.svg")

                layer {
                    effect: ColorOverlay {
                        color: appWindow.theme.foreground
                    }
                    enabled: true
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.removeAt(index)
                }
            }
        }
    }

    contentItem: BaseTextField {
        text: root.editText
        anchors.left: parent.left
        leftPadding: qtbug.leftPadding(6*appWindow.zoom, 30*appWindow.zoom)
        rightPadding: qtbug.rightPadding(6*appWindow.zoom, 30*appWindow.zoom)
        background: Rectangle {
            color: "transparent"
            border.color: "transparent"
        }
        focus: true
    }

    function removeAt(index)
    {
        let etext = editText;
        let path = model[index].value;
        let m = model;
        m.splice(index, 1);
        model = m;
        if (App.toNativeSeparators(etext) === App.toNativeSeparators(path) &&
                m.length)
        {
            etext = App.toNativeSeparators(m[0].text);
        }
        editText = etext;
        folderRemoved(path);
    }
}
