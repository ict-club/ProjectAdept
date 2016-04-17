$(document).ready(function ()
{
    $('#mainSplitter').jqxSplitter({
        width: '100%',
        height: '100%',
        resizable: false,
        showSplitBar: false,
        panels: [{ size: '201.5' }, { size: '79%' }]
    });

    $('.person-container ul li').on('click', function ()
    {
        var clickedListElement = $(this);
        $('.person-container ul li').removeClass('active');
        clickedListElement.addClass('active');
    });

    var response = new $.jqx.response();
    var documentWidth = window.innerWidth;
    if (documentWidth < 679)
    {
        $('#mainSplitter').jqxSplitter({ orientation: 'horizontal', panels: [{ size: '67' }, { size: '85%' }] });
    }
    var resizeEvent;
    response.resize(function ()
    {
        clearTimeout(resizeEvent);
        resizeEvent = setTimeout(function ()
        {
            documentWidth = window.innerWidth;
            //TODO Response for menuBar
            if (documentWidth < 679)
            {
                $('#mainSplitter').jqxSplitter({ orientation: 'horizontal', panels: [{ size: '67' }, { size: '85%' }] });
            } else
            {
                $('#mainSplitter').jqxSplitter({ orientation: 'vertical', panels: [{ size: '201.5' }, { size: '79%' }] });
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
        'Peter Lazarov'
    ];

    $('#person-dropdown').jqxDropDownList({
        selectedIndex: 0, source: source, theme:'metrodark',
        renderer: function (index, label, value)
        {
            var datarecord = source[index];
            var imgurl = 'C:/Users/Asus/Documents/Visual Studio 2015/Projects/Adept/assets/person.png';
            var img = '<img height="30" width="30" src="' + imgurl + '"/>';
            var table = '<table><tr><td style="width: 45px;">' + img + '</td><td>' + label + '</td></tr></table>';
            return table;
        },

    });
};