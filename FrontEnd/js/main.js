$(document).ready(function ()
{
    $('#mainSplitter').jqxSplitter({
        width: '100%',
        height: '100%',
        resizable: false,
        showSplitBar: false,
        panels: [{ size: '346' }, { size: '82%' }]
    });

    $('.person-container ul li').on('click', function ()
    {
        var clickedListElement = $(this);
        $('.person-container ul li').removeClass('active');
        clickedListElement.addClass('active');
    });

    var response = new $.jqx.response();
    var documentWidth = window.innerWidth;
    if (documentWidth < 1001)
    {
        $('#mainSplitter').jqxSplitter({ orientation: 'horizontal', panels: [{ size: '150' }, { size: '82%' }] });
    }
    var resizeEvent;
    response.resize(function ()
    {
        $("#person-dropdown").jqxDropDownList("close");
        clearTimeout(resizeEvent);
        resizeEvent = setTimeout(function ()
        {
            documentWidth = window.innerWidth;
            //TODO Response for menuBar
            if (documentWidth < 1001)
            {
                $('#mainSplitter').jqxSplitter({ orientation: 'horizontal', panels: [{ size: '150' }, { size: '82%' }] });
            } else
            {
                $('#mainSplitter').jqxSplitter({ orientation: 'vertical', panels: [{ size: '346' }, { size: '82%' }] });
            }
        }
        , 1);
    });
    dropDownList();
});

function dropDownList()
{
    var source = [
        'Ivo Zhulev',
        'Martin Kuvandzhiev',
        'Peter Lazarov',
        'Ivo Zhulev',
        'Martin Kuvandzhiev',
        'Peter Lazarov',
        'Ivo Zhulev',
        'Martin Kuvandzhiev',
        'Peter Lazarov',
        'Ivo Zhulev'
    ];

    $('#person-dropdown').jqxDropDownList({
        selectedIndex: 0, source: source, theme:'metrodark', width:400, height:50,autoItemsHeight: true, dropDownHeight: 300,
        renderer: function (index, label, value)
        {
            var datarecord = source[index];
            var imgurl = 'C:/Users/Asus/Documents/Visual Studio 2015/Projects/Adept/assets/person.png';
            var img = '<img class="table-img-format" src="' + imgurl + '"/>';
            var table = '<table><tr><td class="table-img">' + img + '</td><td class="table-text">' + label + '</td></tr></table>';
            return table;
        },
        selectionRenderer: function (element, index, label, value)
        {
            return '<span class="dropdown-header">' + label + '</span>';
        }
    });
}; 