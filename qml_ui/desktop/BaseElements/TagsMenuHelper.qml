import QtQuick
import org.freedownloadmanager.fdm

QtObject
{
    property var menu: null
    property var insertAfter: null
    property var tags: null
    property bool checkable: true
    property var downloadsItemsTools: null

    property int __countAdded: 0
    property var __menuItemComponent: Qt.createComponent(Qt.resolvedUrl("BaseContextMenuItem.qml"));

    function addTags()
    {
        removeTags();

        let index = startIndex();

        for (let i = 0; i < tags.length; ++i)
        {
            let tag = tags[i];

            let item = __menuItemComponent.createObject(
                    menu.contentItem,
                    {
                        showThreeDotsBtn: !tag.readOnly && appWindow.uiver !== 1,
                        showRectWithColor: (tag.readOnly || appWindow.uiver === 1) ? "transparent" : tag.color,
                        overrideRightPadding: 5*appWindow.zoom,
                        text: tag.readOnly ? (App.loc.tr(tag.name) + App.loc.emptyString) : tag.name,
                        checkable: checkable,
                        checked: checkable ?
                                     (downloadsItemsTools ?
                                          downloadsItemsTools.isDownloadsTagChecked(tag.id) :
                                          selectedDownloadsTools.getDownloadsTagChecked(tag.id)) :
                                     false
                    });

            item.triggered.connect(
                        () => {
                            if (checkable) {
                                if (downloadsItemsTools)
                                    downloadsItemsTools.setDownloadsTag(tag.id, item.checked);
                                else
                                    selectedDownloadsTools.setDownloadsTag(tag.id, item.checked);
                            }
                            else {
                                downloadsViewTools.setDownloadsTagFilter(tag.id);
                            }
                        });

            item.threeDotsClicked.connect(
                        () =>
                        {
                            let cc = Qt.createComponent(Qt.resolvedUrl("TagMenu.qml"));
                            let mm = cc.createObject(
                                        item.threeDotsBtn,
                                        {
                                            "tag": tag,
                                            "askRemoveConfirmation": false
                                        });
                            mm.open();
                            mm.aboutToHide.connect(() => mm.destroy());
                            mm.aboutToOpenDialog.connect(() => Qt.callLater(closeMenu, menu));
                            menu.aboutToHide.connect(() => Qt.callLater(closeMenu, mm));
                        });

            menu.insertItem(index + __countAdded++, item);
        }
    }

    function removeTags()
    {
        let index = startIndex();

        while (__countAdded)
        {
            menu.removeItem(menu.itemAt(index));
            __countAdded--;
        }
    }

    function startIndex()
    {
        if (!insertAfter)
            return 0;

        for (let i = 0; i < menu.count; ++i)
        {
            if (menu.itemAt(i) == insertAfter)
                return i + 1;
        }

        return menu.count;
    }

    function closeMenu(m)
    {
        m.close();
    }

    onTagsChanged: addTags()

    Component.onCompleted: {
        App.loc.currentTranslationChanged.connect(addTags);
        addTags();
    }
}
