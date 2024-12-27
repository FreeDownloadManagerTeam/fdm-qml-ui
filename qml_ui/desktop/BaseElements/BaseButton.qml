import QtQuick 2.10

Loader
{
    id: root

    signal clicked()

    property string text

    property bool blueBtn: false
    property bool smallBtn: false
    property bool alternateBtnPressed: false
    property bool isPressed: false
    property int radius: 0

    property color primaryBtnColor: blueBtn ? appWindow.theme.btnBlueBackgroud : appWindow.theme.btnGreyBackgroud
    property color secondaryBtnColor: blueBtn ? appWindow.theme.btnGreyBackgroud : appWindow.theme.btnBlueBackgroud
    property color primaryTextColor: blueBtn ? appWindow.theme.btnBlueText : appWindow.theme.btnGreyText
    property color secondaryTextColor: blueBtn ? appWindow.theme.btnGreyText : appWindow.theme.btnBlueText
    property color primaryBorderColor: blueBtn ? appWindow.theme.btnBlueBorder : appWindow.theme.btnGreyBorder
    property color secondaryBorderColor: blueBtn ? appWindow.theme.btnGreyBorder : appWindow.theme.btnBlueBorder

    source: Qt.resolvedUrl(appWindow.uiver === 1 ? "CustomButton.qml" : "V2/ToolbarFlatButton_V2.qml")

    onItemChanged:
    {
        if (!item)
            return;

        item.clicked.connect(clicked);

        if (appWindow.uiver === 1)
        {
            item.text = Qt.binding(() => root.text);
            item.blueBtn = Qt.binding(() => root.blueBtn);
            item.smallBtn = Qt.binding(() => root.smallBtn);
            item.alternateBtnPressed = Qt.binding(() => root.alternateBtnPressed);
            item.radius = Qt.binding(() => root.radius);
            item.primaryBtnColor = Qt.binding(() => root.primaryBtnColor);
            item.secondaryBtnColor = Qt.binding(() => root.secondaryBtnColor);
            item.primaryTextColor = Qt.binding(() => root.primaryTextColor);
            item.secondaryTextColor = Qt.binding(() => root.secondaryTextColor);
            item.primaryBorderColor = Qt.binding(() => root.primaryBorderColor);
            item.secondaryBorderColor = Qt.binding(() => root.secondaryBorderColor);
            root.isPressed = Qt.binding(() => item.isPressed);
        }
        else
        {
            item.title = Qt.binding(() => root.text);
            item.primaryButton = Qt.binding(() => root.blueBtn);
            item.leftPadding = item.rightPadding = 12*appWindow.zoom
            root.isPressed = false;
        }
    }
}
