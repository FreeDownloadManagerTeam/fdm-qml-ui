import QtQuick 2.12
import QtQuick.Layouts 1.12
import org.freedownloadmanager.fdm 1.0
import "../../common"

Item
{
    id: root

    property string title: ""
    property string url: ""
    property string downloadModuleUid: ""

    visible: url.length > 0

    QtObject
    {
        id: d
        property string customIcon: App.linkIcon(url, downloadModuleUid, appWindow.theme.isLightTheme)
    }

    implicitHeight: myContent.implicitHeight
    implicitWidth: myContent.implicitWidth

    RowLayout
    {
        id: myContent

        anchors.fill: parent

        spacing: 3

        Image
        {
            id: img
            source: d.customIcon ? d.customIcon : appWindow.theme.linkImg;
            Layout.preferredWidth: img2.implicitWidth
            Layout.preferredHeight: img2.implicitHeight
            Layout.alignment: Qt.AlignVCenter
            Layout.topMargin: titleLabel.visible ? 0 : Math.max(1, fm.lineWidth/2) // helps the image to look visually centered
            sourceSize: Qt.size(width, height)
            Image {
                id: img2
                visible: false
                source: parent.source
            }
        }

        BaseLabel
        {
            id: titleLabel
            visible: root.title.length > 0
            text: root.title + ":"
            Layout.alignment: Qt.AlignVCenter
            font.pixelSize: appWindow.fonts.defaultSize
            Layout.fillHeight: true
        }

        BaseLabel
        {
            id: label
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignVCenter
            font.pixelSize: appWindow.fonts.defaultSize
            property string elidedText: fm.myElidedText(url, width).replace(/&/g, "&amp;")
            text: "<a href='" + url + "'>" + elidedText + "</a>"
            onLinkActivated: App.openDownloadUrl(link)
            MyFontMetrics {
                id: fm
                font: label.font
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: {
                    if (mouse.button == Qt.LeftButton)
                        App.openDownloadUrl(root.url);
                    else
                        showMenu(parent, mouse, root.url)
                }
                BaseToolTip {
                    text: root.url
                    visible: label.enabled && parent.containsMouse && url != label.elidedText
                    fontSize: 11
                }
            }
        }
    }

    function showMenu(anchor, mouse, url)
    {
        var component = Qt.createComponent(Qt.resolvedUrl("../BottomPanel/CopyLinkMenu.qml"));
        var menu = component.createObject(anchor, {
                                              "url": url
                                          });
        menu.x = Math.round(mouse.x);
        menu.y = Math.round(mouse.y);
        menu.open();
        menu.aboutToHide.connect(function(){
            menu.destroy();
        });
    }
}

