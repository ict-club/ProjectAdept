$(document).ready(function ()
{
    $('#mainSplitter').jqxSplitter({
        width: '100%',
        height: '100%',
        resizable: false,
        showSplitBar: false,
        panels: [{ size: '346' }, { size: '82%' }]
    });

    $('.buttons-container ul li').on('click', function ()
    {
        var clickedListElement = $(this);
        $('.buttons-container ul li').removeClass('person-active');
        clickedListElement.addClass('person-active');
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
    chart();
});

function dropDownList()
{
    var users = JSON.parse(localStorage.getItem('usersDB'));
    var names = [], imgUrls = [];
    for (var i = 0; i < users.length; i++)
    {
        names.push(users[i].Name);
        imgUrls.push(users[i].picture_small);
    }

    $('#person-dropdown').jqxDropDownList({
        selectedIndex: 0, source: names, theme: 'metrodark', width: 400, height: 65, autoItemsHeight: true, dropDownHeight: 300,
        renderer: function (index, label, value)
        {
            var imgurl = imgUrls[index];
            var img = '<img class="table-img-format" src="' + imgurl + '"/>';
            var table = '<table class="table-content"><tr><td class="table-img">' + img + '</td><td class="table-text">' + label + '</td></tr></table>';
            return table;
        },
        selectionRenderer: function (element, index, label, value)
        {
            var imgurl = imgUrls[index];
            var img = '<img class="table-img-format" src="' + imgurl + '"/>';
            var table = '<table class="table-header"><tr><td class="table-img">' + img + '</td><td class="dropdown-header">' + label + '</td></tr></table>';
            return table;
            //return '<span class="dropdown-header">' + label + '</span>';
        }
    });
};

(function getUsers()
{
    $.get('http://adept-adeptserver.rhcloud.com/users', function (data)
    {
        for (var i = 0; i < data.length; i++)
        {
            $('.person-container ul li:nth-child(' + (i + 1) + ') p').html(data[i].Name);
            $('.person-container ul li:nth-child(' + (i + 1) + ')').attr('index', data[i].id);
            $('.person-container ul li:nth-child(' + (i + 1) + ') span').css('background-image', 'url(' + data[i].picture_small + ')');
        }
        localStorage.setItem('usersDB', JSON.stringify(data));
    });
})();

function chart()
{

    'use strict';
    //var source =
    //                {
    //                    datafields: [
    //                        { name: 'day' },
    //                        { name: 'spline1' },
    //                        { name: 'spline2' }
    //                    ],
    //                    url: 'http://localhost/demos/interactivedemos/businessdashboard/data.php?usedwidget=chartdataclicks',
    //                    datatype: 'json'
    //                };


    //var dataAdapter = new $.jqx.dataAdapter(source, { async: false, autoBind: true, loadError: function (xhr, status, error) { alert('Error loading "' + source.url + '" : ' + error); } });
    var sampleData = [
                    { Day: 'Monday', Running: 30, Swimming: 10, Cycling: 25, Goal: 40 },
                    { Day: 'Tuesday', Running: 25, Swimming: 15, Cycling: 10, Goal: 50 },
                    { Day: 'Wednesday', Running: 30, Swimming: 10, Cycling: 25, Goal: 60 },
                    { Day: 'Thursday', Running: 40, Swimming: 20, Cycling: 25, Goal: 40 },
                    { Day: 'Friday', Running: 45, Swimming: 20, Cycling: 25, Goal: 50 },
                    { Day: 'Saturday', Running: 30, Swimming: 20, Cycling: 30, Goal: 60 },
                    { Day: 'Sunday', Running: 20, Swimming: 30, Cycling: 10, Goal: 90 }
    ];

    //var toolTipCustomFormatFn = function (value, itemIndex, serie, group, categoryValue)
    //{
    //    return '<div style="text-align:left"><b><i>' + categoryValue + ' : ' + value + '</i></b></div>';
    //};

    var settings = {
        title: '',
        description: '',
        showBorderLine: false,
        showLegend: false,
        enableAnimations: true,
        //toolTipFormatFunction: toolTipCustomFormatFn,
        padding: { left: 10, top: 10, right: 15, bottom: 10 },
        titlePadding: { left: 90, top: 0, right: 0, bottom: 10 },
        source: sampleData,
        colorScheme: 'scheme05',
        xAxis: {
            dataField: 'Day',
            unitInterval: 1,
            tickMarks: { visible: true, interval: 1 },
            gridLinesInterval: { visible: true, interval: 1 },
            valuesOnTicks: false,
            padding: { bottom: 10 }
        },
        valueAxis: {
            unitInterval: 10,
            minValue: 0,
            maxValue: 50,
            title: { text: '' },
            labels: { horizontalAlignment: 'right' }
        },
        seriesGroups:
            [
                {
                    type: 'spline',
                    series:
                    [
                        {
                            dataField: 'Running',
                            symbolType: 'square',
                            labels:
                            {
                                visible: true,
                                backgroundColor: '#FEFEFE',
                                backgroundOpacity: 0.2,
                                borderColor: '#7FC4EF',
                                borderOpacity: 0.7,
                                padding: { left: 5, right: 5, top: 0, bottom: 0 }
                            }
                        },
                        {
                            dataField: 'Swimming',
                            symbolType: 'square',
                            labels:
                            {
                                visible: true,
                                backgroundColor: '#FEFEFE',
                                backgroundOpacity: 0.2,
                                borderColor: '#7FC4EF',
                                borderOpacity: 0.7,
                                padding: { left: 5, right: 5, top: 0, bottom: 0 }
                            }
                        }
                    ]
                }
            ]
    };
    $('#chart').jqxChart(settings);

}