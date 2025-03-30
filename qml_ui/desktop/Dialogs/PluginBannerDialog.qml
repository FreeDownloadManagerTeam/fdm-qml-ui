import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0
import "../BaseElements"
import "../../common"
import "../../qt5compat"

BaseDialog
{
    id: root

    property string pluginUuid

    readonly property string pluginName: pluginUuid ? App.plugins.mgr.pluginName(pluginUuid) : ""
    readonly property var pluginIcon: pluginUuid ? App.plugins.mgr.pluginIcon(pluginUuid) : null

    title: qsTr("Enjoy using %1 add-on?").arg(pluginName) + App.loc.emptyString
    onCloseClick: root.close()

    contentItem: BaseDialogItem
    {
        Keys.onEscapePressed: root.close()

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 10*appWindow.zoom

            RowLayout
            {
                spacing: 20*appWindow.zoom

                WaSvgImage
                {
                    source: root.pluginIcon && root.pluginIcon.toString() ?
                                root.pluginIcon :
                                Qt.resolvedUrl("../../images/desktop/plugin.svg")
                    zoom: appWindow.zoom
                    Layout.preferredHeight: 64*zoom
                    Layout.preferredWidth: Layout.preferredHeight
                }

                ColumnLayout
                {
                    Layout.minimumWidth: 400*appWindow.fontZoom

                    DialogWrappedLabel {
                        text: qsTr("We would like to ask you to help this add-on to reach its potential users.") + App.loc.emptyString
                        Layout.fillWidth: true
                    }

                    DialogWrappedLabel {
                        text: qsTr("Please use your favorite social networks and forums to let the other people know about %1 and %2.")
                            .arg(App.displayName).arg(root.pluginName) + App.loc.emptyString
                        Layout.fillWidth: true
                    }
                }
            }

            RowLayout {
                Layout.topMargin: 10*appWindow.zoom
                Layout.alignment: Qt.AlignRight
                Layout.fillWidth: true

                spacing: 5*appWindow.zoom

                BaseButton {
                    id: remindBtn
                    text: qsTr("Remind me later") + App.loc.emptyString
                    onClicked: {
                        App.pluginsBanners.bannerIsClosed(root.pluginUuid, false);
                        root.close();
                    }
                    Layout.alignment: Qt.AlignRight
                }

                BaseButton {
                    text: qsTr("OK") + App.loc.emptyString
                    blueBtn: true
                    alternateBtnPressed: remindBtn.isPressed
                    onClicked: {
                        App.pluginsBanners.bannerIsClosed(root.pluginUuid, true);
                        root.close();
                    }
                    Layout.alignment: Qt.AlignRight
                }
            }
        }
    }

    onClosed: appWindow.appWindowStateChanged()
    onOpened: root.forceActiveFocus()
}
