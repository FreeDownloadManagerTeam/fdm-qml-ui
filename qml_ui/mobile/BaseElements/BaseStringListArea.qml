import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQml
import org.freedownloadmanager.fdm

Item
{
    id: root

    property var list: []
    property string chJoin: '\n'

    property var isValidItem: function(str) {
        return str.length > 0;
    }

    function setString(str)
    {
        d.changingText = true;
        textArea.text = str;
        d.changingText = false;
        d.onTextChanged();
    }

    function getString()
    {
        if (d.isDirty)
            d.onTextChanged();
        return list.join(chJoin);
    }

    implicitHeight: content.implicitHeight
    implicitWidth: content.implicitWidth

    ColumnLayout
    {
        id: content

        anchors.fill: parent

        Flickable
        {
            id: flickable

            property bool hasVerticalScrollbar: contentHeight > height

            ScrollBar.vertical: ScrollBar {
                policy: flickable.hasVerticalScrollbar ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
            }
            ScrollBar.horizontal: null

            Layout.fillWidth: true
            Layout.fillHeight: true

            clip: true

            TextArea.flickable: TextArea
            {
                id: textArea

                background: Rectangle {
                    color: appWindow.theme.background
                }

                color: appWindow.theme.foreground

                focus: visible

                horizontalAlignment: Text.AlignLeft

                onTextChanged: {
                    if (!d.changingText) {
                        d.isDirty = true;
                        timer.restart();
                    }
                }
            }
        }

        BaseLabel
        {
            visible: chJoin === '\n'
            text: qsTr("Please enter one item per line") + App.loc.emptyString
        }
    }

    QtObject
    {
        id: d

        property bool isDirty: false
        property bool changingText: false

        function onTextChanged()
        {
            let l = textArea.text.split(chJoin);
            let ll = [];
            for (let i = 0; i < l.length; ++i)
            {
                if (root.isValidItem(l[i]))
                    ll.push(l[i]);
            }
            root.list = ll;
            isDirty = false;
        }
    }

    Timer
    {
        id: timer
        onTriggered: d.onTextChanged()
        interval: 500
    }
}
