import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import org.freedownloadmanager.fdm
import "../../common"

BaseComboBox {
    id: root

    editable: true

    popupVisibleRowsCount: appWindow.uiver === 1 ? 7 : 5
    comboMaximumWidth: Math.round(appWindow.width*0.8)
    delegateMinimumHeight: 30*appWindow.zoom

    signal folderRemoved(var path)

    delegate: Item {
        id: delegateRoot

        property bool hover: false

        anchors.left: parent.left
        height: root.recommendedDelegateHeight
        width: root.recommendedDelegateWidth

        Rectangle {
            anchors.fill: parent
            anchors.margins: appWindow.uiver === 1 ? 0 : 2*appWindow.zoom
            color: parent.hover ?
                       (appWindow.uiver === 1 ? appWindow.theme.menuHighlight : appWindow.theme_v2.hightlightBgColor) :
                       "transparent"
            radius: parent.hover ?
                        (appWindow.uiver === 1 ? 0 : 4*appWindow.zoom) :
                        0
        }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: root.leftPadding
            anchors.rightMargin: root.rightPadding

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

                zoom: appWindow.zoom
                source: appWindow.macVersion ? Qt.resolvedUrl("../../images/desktop/search_clear_mac.svg") :
                                               Qt.resolvedUrl("../../images/desktop/clean.svg")

                layer {
                    effect: MultiEffect {
                        colorization: 1.0
                        colorizationColor: appWindow.uiver === 1 ?
                                               appWindow.theme.foreground :
                                               appWindow.theme_v2.textColor
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
        background: Item {}
        topPadding: 0
        bottomPadding: 0
        leftPadding: qtbug.leftPadding(0, root.indicator.width + 4*appWindow.zoom)
        rightPadding: qtbug.rightPadding(0, root.indicator.width + 4*appWindow.zoom)
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
