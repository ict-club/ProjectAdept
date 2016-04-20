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

        var id = clickedListElement.attr('index');
        getUser(id);
    });

    var response = new $.jqx.response();
    var documentWidth = window.innerWidth;
    if (documentWidth < 1101)
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
            if (documentWidth < 1101)
            {
                $('#mainSplitter').jqxSplitter({ orientation: 'horizontal', panels: [{ size: '150' }, { size: '82%' }] });
            } else
            {
                $('#mainSplitter').jqxSplitter({ orientation: 'vertical', panels: [{ size: '346' }, { size: '82%' }] });
            }

            if ($('#chart').css('display') === 'none')
            {
                secondPageHeight();
            } else
            {
                mainPageHeight();
            }
        }
        , 1);
    });

    $('.gear').on('click', function ()
    {
        exercisesContainers();
        $('#chart , .buttons-container, .person-stats, .gear').css('display', 'none');
        $('.back').css('display', 'inline-block');
        secondPageHeight()
    });

    $('.back').on('click', function ()
    {
        $('#chart , .buttons-container, .person-stats, .back').css('display', 'block');
        $('.gear').css('display', 'inline-block');
        mainPageHeight()
    });


    $('.exerciseContainers ul li').on('click', function (e)
    {
        if (e.target !== this)
        {
            return;
        }
            
        var isChecked = $(this).find('input:checkbox').is(':checked');
        if (isChecked)
        {
            $(this).find('input:checkbox').prop('checked', false);
        } else 
        {
            $(this).find('input:checkbox').prop('checked', true);
        }
    });

    

    getUser(1);
    dropDownList();
    chart();
    mainPageHeight();
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

function OverallConditionCircleColor(condition)
{
    switch (condition)
    {
        case -2:
            $('.person-big-img').css('border-color', '#33CCFF');
            break;
        case -1:
            $('.person-big-img').css('border-color', '#33CC7F');
            break;
        case -0:
            $('.person-big-img').css('border-color', '#33CCCC');
            break;
        case 1:
            $('.person-big-img').css('border-color', '#33CCCC');
            break;
        case 2:
            $('.person-big-img').css('border-color', '#33CCCC');
            break;
    }
}

function getUser(UserId)
{
    $.ajax({
        url: 'http://adept-adeptserver.rhcloud.com/userdata',
        headers:
        {
            'parameters': '[{ "UserId" :' + UserId + '}]'
        },
        method: 'GET',
        dataType: 'json',
        async: false,
        success: function (data)
        {
            console.log(data)
            $('.person-name').html(data[0].Name);
            //$('.person-title').html(data[0].Title);
            $('.weight-stats').html(data[0].Weight);
            $('.MS-stats').html(data[0].avgForce);
            //$('.WBS-stats').html(data[0].WristCirc);
            $('.CB-stats').html(data[0].CaloriesBalance);
            $('.RHR-stats').html(data[0].RestingHeartRate);
            $('.person-big-img').css('background-image', 'url(' + data[0].picture_big + ')');
            OverallConditionCircleColor(data[0].OverallCondition);
        }
    });
}

function mainPageHeight()
{
    var mainHeight = $('.person-info-container').height() + $('.person-stats').height() + $('.buttons-container').height() + $('#chart').height()
    if ($('#mainSplitter').jqxSplitter('orientation') === 'vertical')
    {
        $('#mainSplitter').jqxSplitter({ height: mainHeight + 324 });
    } else
    {
        $('#mainSplitter').jqxSplitter({ height: mainHeight + 501 });
    }
    
}

function secondPageHeight()
{
    var mainHeight = $('.person-info-container').height() + $('.exerciseTitles').height() + $('.exerciseContainers').height();
    if ($('#mainSplitter').jqxSplitter('orientation') === 'vertical')
    {
        $('#mainSplitter').jqxSplitter({ height: mainHeight + 610 });
    } else
    {
        $('#mainSplitter').jqxSplitter({ height: mainHeight + 759 });
    }
}

function exercisesContainers()
{
    $('.exerciseContainers').jqxPanel({ width: '76%', height: 180, scrollBarSize: 10 });

}
