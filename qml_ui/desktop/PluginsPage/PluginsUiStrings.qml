import QtQuick

Item 
{
    function permissionsHtml(names, descriptions)
    {
        var result = "<div style='margin-left:20px; margin-top:10px; margin-bottom:10px'>";

        for (var i = 0; i < names.length; ++i)
        {
            if (i)
                result += "<br>";
            result += "<b>" + names[i] + "</b>:<br>" + descriptions[i];
        }

        result += "</div>";

        return result;
    }
}
