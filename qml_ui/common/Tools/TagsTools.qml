import QtQuick 2.12
import org.freedownloadmanager.fdm 1.0

Item {
    id: root

    property var tagsCollection
    property variant callbacks: []

    property var allTags: []
    property var systemTags: []
    property var nonHiddenSystemTags: []
    property var customTags: []
    property var visibleTags: []
    property var hiddenTags: []

    property bool tagFormOpened

    property color editedTagColor
    property int editedTagId
    property string editedTagName
    property bool editedTagError
    property var editedTagExtensions
    property string editedTagDownloadFolder

    property string newTagName
    property color newTagColor: "red"
    property bool newTagError

    property bool dragNDropTagInProgress: false
    property var viewTag

    property int tagsPanelWidth
    property int tagsScrollMaxHeight: appWindow.height - 248

    property var defaultColors: [
        "#D73C3D", "#00157A", "#009C7E", "#1B433C", "#643D19", "#EC642A",
        "#6D1949", "#008AC5", "#6ACE39", "#FFB600", "#FF9753", "#FF716E",
        "#FA48AA", "#D135B6", "#00C3C4", "#B4C400", "#CC4401", "#CC1886",
        "#541CC6", "#004AC6", "#0090C6", "#435B64", "#00F200", "#FC150C"
    ]

    onViewTagChanged: splitTagsByVisibility()
    onTagsPanelWidthChanged: {
        closeTagForm();
        splitTagsByVisibility()
    }
    onEditedTagNameChanged: {
        if (tagFormOpened) {
            splitTagsByVisibility()
        }
    }

    function updateState() {
        var t = [];
        var tagIds = App.downloads.tags.allTagsIds();
        for (var i = 0; i < tagIds.length; i++) {
            t.push(App.downloads.tags.tag(tagIds[i]));
        }

        systemTags = t.filter(e => e.id < 0);
        systemTags.sort(sortByIdDesc);

        customTags = t.filter(e => e.id > 0);
        customTags.sort(sortByPopularityDesc);

        //join all tags to common array
        allTags = systemTags.concat(customTags);

        updateNonHiddenSystemTags();

        splitTagsByVisibility();
    }

    function updateNonHiddenSystemTags() {
        nonHiddenSystemTags = systemTags.filter(e => !uiSettingsTools.settings.hideTags[e.id])
    }

    function checkTagSize(tagLabel)
    {
        textMetrics.text = tagLabel.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
        return Math.max(45*appWindow.zoom, textMetrics.width + (15 + 12 + 5)*appWindow.zoom);
    }

    function downloadsIds(tag)
    {
        return App.downloads.tagsHelper2.tagHelper(tag.id).downloadsIds;
    }

    function splitTagsByVisibility() {
        var tags_width = tagsPanelWidth;
        var tags = allTags;
        var view_tag = viewTag;

        var edited_tag_is_visible = false;

        if (tagFormOpened && editedTagId){
            if (visibleTags.find(obj => { return obj.id === editedTagId })) {
                edited_tag_is_visible = true;
            }
        }

        var view_tag_size = 0;
        if (view_tag){
            var view_tag_name = view_tag.name;
            if (tagFormOpened && editedTagId == view_tag.id)
                view_tag_name = editedTagName;
            var view_tag_popular = tags.find(obj => { return obj.id === view_tag.id })
            if (view_tag_popular)
                view_tag_name = view_tag_name + ' (' + downloadsIds(view_tag_popular).length + ')';

            view_tag_size = checkTagSize(view_tag_name);
        }

        var visible_tags = [];
        var hide_tags = [];

        var visible = true;
        for (var i = 0; i < tags.length; i++){

            var tag = tags[i];

            if (uiSettingsTools.settings.hideTags[tag.id])
                continue;

            if (visible){

                var name = tag.name;
                if (tagFormOpened && editedTagId == tag.id) {
                    name = editedTagName;
                }
                name = name + ' (' + downloadsIds(tag).length + ')';

                var tag_width = checkTagSize(name);

                if (view_tag && view_tag.id != tag.id && tags_width - view_tag_size - tag_width <= 0) {
                    view_tag_popular = tags.find(obj => { return obj.id === view_tag.id })

                    if (view_tag_popular){
                        visible_tags.push(view_tag_popular);
                    }
                    else{
                        visible_tags.push({
                            id: view_tag.id,
                            name: view_tag.name
                        });
                    }

                    visible = false;
                    if (view_tag && tag.id != view_tag.id){
                        hide_tags.push(tag);
                    }

                }
                else if (tags_width - tag_width > 0){
                    visible_tags.push(tag);

                    if (view_tag && tag.id == view_tag.id){
                        view_tag = false;
                    }
                }
                else{
                    if (view_tag && tag.id == view_tag.id){
                        continue;
                    }

                    hide_tags.push(tag);
                    visible = false;
                }

                tags_width -= tag_width;
            }
            else
            {
                if (view_tag && tag.id == view_tag.id)
                    continue;
                hide_tags.push(tag);
            }
        }

        if (tagFormOpened && editedTagId){
            if (edited_tag_is_visible && hide_tags.find(obj => { return obj.id === editedTagId })) {
                setViewTag(editedTagId);
            }
        }

        visibleTags = visible_tags;
        hiddenTags = hide_tags;
    }

    function sortByIdAsc(a, b) {
      if (a.id > b.id) return 1;
      if (a.id == b.id) return 0;
      if (a.id < b.id) return -1;
    }

    function sortByIdDesc(a, b) {
      if (a.id < b.id) return 1;
      if (a.id == b.id) return 0;
      if (a.id > b.id) return -1;
    }

    function sortByPopularityDesc(a, b) {
      if (downloadsIds(a).length < downloadsIds(b).length) return 1;
      if (downloadsIds(a).length == downloadsIds(b).length) {
          return sortByIdAsc(a, b);
      }
      if (downloadsIds(a).length > downloadsIds(b).length) return -1;
    }

    function setViewTag(id) {
        viewTag = getTag(id);//id > 0 ? getTag(id) : null;
    }

    function addTag(name) {
        name = name.trim();
        if (!name.length) {
            return false;
        }

        var color = newTagColor;

        acquireNextTagId(function(id){
            App.downloads.tags.addTag(id, name, color);
        });

        newTagColor = getRandomTagColor(color);
    }

    function removeTag(id) {
        App.downloads.tags.removeTag(id);
    }

    function acquireNextTagId(callbackFn) {
        callbacks = [];
        callbacks.push(callbackFn);
        App.downloads.tags.acquireNextTagId();
    }

    function getTagName(id) {
        if (id) {
            var t = App.downloads.tags.tag(id);
            return t.readOnly ? App.loc.tr(t.name) + App.loc.emptyString : t.name;
        } else {
            return "";
        }
    }

    function getTag(id) {
        if (id) {
            var t = App.downloads.tags.tag(id);
            return t;
        } else {
            return null;
        }
    }

    function startTagEditing(tag, quickForm = false) {
        editedTagId = tag.id;
        editedTagName = tag.name;
        editedTagColor = tag.color;
        editedTagExtensions = tag.defaultExtensions;
        editedTagDownloadFolder = tag.defaultDownloadFolder;
        editedTagError = false;
        if (quickForm) {
            tagFormOpened = true;
        }
    }

    function endTagEditing() {
        if (editedTagId) {
            closeTagForm();
        }
    }

    function closeTagForm() {
        tagFormOpened = false;
        editedTagId = 0;
        editedTagName = "";
        editedTagExtensions = null;
        editedTagDownloadFolder = '';
        editedTagError = false;
        newTagName = "";
        newTagError = false;
    }

    function changeTagName() {
        editedTagName = editedTagName.trim();
        if (editedTagId && editedTagName.length) {
            var tag = App.downloads.tags.tag(editedTagId);
            if (tag && tag.name != editedTagName) {
                tag.name = editedTagName.length ? editedTagName : tag.name;
            }
        }
        endTagEditing();
    }

    function changeTagColor(tagId, color) {
        if (editedTagId && tagId == editedTagId && color) {
            var tag = App.downloads.tags.tag(editedTagId);
            if (tag) {
                tag.color = color;
            }
        } else if (!tagId) {
            setNewTagColor(color);
        }
    }

    function changeTagData() {
        editedTagName = editedTagName.trim();
        if (editedTagId && editedTagName.length) {
            var tag = App.downloads.tags.tag(editedTagId);
            if (tag) {
                tag.name = editedTagName.length ? editedTagName : tag.name;
                tag.color = editedTagColor;
                tag.defaultExtensions = editedTagExtensions;
                tag.defaultDownloadFolder = editedTagDownloadFolder.trim();
            }
        }
        endTagEditing();
    }

    function setNewTagColor(color) {
        newTagColor = color;
    }

    function saveEditedTagName(text) {
        if (tagFormOpened) {
            editedTagName = text;
        }
    }

    function changeDownloadsTag(downloadsIds, tagId, setTag) {
        App.downloads.tags.changeDownloadsTag(downloadsIds, tagId, setTag);
    }

    function setTagsPanelWidth(x) {
        tagsPanelWidth = x;
    }

    function getRandomTagColor(remove_color) {
        remove_color = remove_color || false;

        var new_colours = [];
        defaultColors.map(function(color){
            if (!customTags.some(elem => { return elem.color.toString().toLowerCase() == color.toString().toLowerCase() })
                && !(remove_color && remove_color.toString().toLowerCase() == color.toString().toLowerCase())) {
                    new_colours.push(color);
            }
        }.bind(this));

        if (new_colours.length) {
            return new_colours[randomVal(0, new_colours.length - 1)];
        }
        else {
            return defaultColors[randomVal(0, defaultColors.length - 1)];
        }
    }

    function randomVal(min, max) {
        return Math.floor(Math.random()*(max-min+1)+min);
    }

    Component.onCompleted: {
        updateState()
        newTagColor = getRandomTagColor()
    }

    Connections {
        target: App.downloads.tags
        onNextTagId: {
            if (typeof callbacks === "object") {
                var arr = callbacks;
                for (var i = 0; i < arr.length; i++) {
                    arr[i](id);
                }
            }
            delete callbacks;
        }
        onTagAdded: {
            updateState();
        }
        onTagRemoved: {
            updateState();
        }
        onTagChanged: {
            updateState();
        }
        onWasReset: {
            updateState();
        }
    }

    Connections {
        target: uiSettingsTools.settings
        onHideTagsChanged: {
            updateNonHiddenSystemTags();
            splitTagsByVisibility();
        }
    }

    TextMetrics {
        id: textMetrics
        font.pixelSize: 11*appWindow.fontZoom
        font.family: Qt.platform.os === "osx" ? font.family : "Arial"
    }
}
