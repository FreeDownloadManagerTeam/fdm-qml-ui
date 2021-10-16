import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "../../qt5compat"
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.dmcoresettings 1.0
import org.freedownloadmanager.fdm.appsettings 1.0
import org.freedownloadmanager.fdm.appfeatures 1.0
import "../BaseElements"

Column
{
    spacing: 10
    width: parent.width
    property bool customSettingsEnabled: antivirusCombo.model.length > 0 && antivirusCombo.model[antivirusCombo.currentIndex].id === ""
    property bool autoCheckEnabled: !customSettingsEnabled || !urlField.inError && !args.inError

    SettingsGroupHeader {
        text: qsTr("Antivirus") + App.loc.emptyString
    }

    GridLayout {
        id: grid

        columns: 2
        width: 548
        rowSpacing: 12

        BaseLabel {
            Layout.topMargin: 5
            text: qsTr("Select antivirus:") + App.loc.emptyString
            color: appWindow.theme.settingsItem
            rightPadding: 10
        }

        RowLayout {
            spacing: 10

            AntivirusComboBox {
                id: antivirusCombo
                Layout.topMargin: 5
            }

            BaseHyperLabel {
                text: "<a href='https://www.freedownloadmanager.org/board/viewtopic.php?f=1&t=18212'>" + qsTr("Is your antivirus not listed?") + "</a>" + App.loc.emptyString
                font.pixelSize: 12
            }
        }

        BaseLabel {
            text: qsTr("Path:") + App.loc.emptyString
            enabled: customSettingsEnabled
            leftPadding: 38
            rightPadding: 10
            color: appWindow.theme.settingsItem
        }

        RowLayout {
            height: folderBtn.implicitHeight + 1
            enabled: customSettingsEnabled

            SettingsTextField {
                id: urlField
                property bool inError: false
                focus: true
                Layout.fillWidth: true
                text: App.settings.dmcore.value(DmCoreSettings.AntivirusPath)
                enabled: antivirusCombo.model[antivirusCombo.currentIndex].id === ""

                onTextChanged: urlFieldUpdateStateTimer.restart()
                Component.onCompleted: urlFieldUpdateStateTimer.start()

                SettingsInputError {
                    visible: urlField.inError && urlField.activeFocus
                    errorMessage: qsTr("Please enter antivirus path") + App.loc.emptyString
                }

                function updatState() {
                    urlField.inError = text && !App.tools.fileExists(text);

                    if (!text && customSettingsEnabled)
                        autoCheck.checked = false;

                    if (!urlField.inError)
                        App.settings.dmcore.setValue(DmCoreSettings.AntivirusPath, text)
                }

                Timer {
                    id: urlFieldUpdateStateTimer
                    interval: 300
                    onTriggered: parent.updatState()
                }
            }

            CustomButton {
                id: folderBtn
                implicitWidth: 38
                implicitHeight: 25
                Layout.alignment: Qt.AlignRight
                clip: true
                Image {
                    source: Qt.resolvedUrl("../../images/desktop/pick_file.svg")
                    sourceSize.width: 37
                    sourceSize.height: 30
                    y: -5
                    layer {
                        effect: ColorOverlay {
                            color: folderBtn.isPressed ? folderBtn.secondaryTextColor : folderBtn.primaryTextColor
                        }
                        enabled: true
                    }
                }
                onClicked: browseDlg.open()
                FileDialog {
                    id: browseDlg
                    onAccepted: {
                        urlField.text = App.tools.url(fileUrl).toLocalFile();
                    }
                }
            }
        }

        BaseLabel {
            text: qsTr("Arguments:") + App.loc.emptyString
            enabled: customSettingsEnabled
            leftPadding: 38
            rightPadding: 10
            color: appWindow.theme.settingsItem
        }

        SettingsTextField {
            id: args
            property bool inError: false
            text: App.settings.dmcore.value(DmCoreSettings.AntivirusArgs)
            enabled: customSettingsEnabled
            Layout.fillWidth: true

            onTextChanged: {
                updatState()
                if (!args.inError) {
                    App.settings.dmcore.setValue(DmCoreSettings.AntivirusArgs, text)
                }
            }

            Component.onCompleted: updatState()

            SettingsInputError {
                id: argsErr
                visible: args.inError && args.activeFocus
                errorMessage: qsTr("Arguments must contain %path% variable") + App.loc.emptyString
            }

            function updatState() {
                argsErr.errorMessage = App.settings.isValidCustomAntivirusArgs(args.text);
                args.inError = argsErr.errorMessage != '';
                if (args.inError && customSettingsEnabled) {
                    autoCheck.checked = false;
                }
            }
        }

        Label{}

        SettingsGridLabel {
            Layout.topMargin: -7
            text: qsTr("Arguments must contain %path% variable") + App.loc.emptyString
            enabled: customSettingsEnabled
            color: "#999"
        }
    }

    SettingsCheckBox {
        id: autoCheck
        text: qsTr("Automatically perform virus check when download is finished") + App.loc.emptyString
        checked: App.settings.toBool(App.settings.dmcore.value(DmCoreSettings.AutoLaunchAntivirusForFinishedDownloads))
        enabled: autoCheckEnabled || checked
        onClicked: {
            App.settings.dmcore.setValue(
                DmCoreSettings.AutoLaunchAntivirusForFinishedDownloads,
                App.settings.fromBool(checked));
        }
    }
}
