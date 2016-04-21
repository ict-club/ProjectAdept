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
        
        var chartType = $(this).attr('class').match(/([^\s]+)/)[0];
        var personId = $('.person-container ul li.active').attr('index');;
        getChart(personId, chartType);
    });

    $('.person-container ul li').on('click', function ()
    {
        var clickedListElement = $(this);
        $('.person-container ul li').removeClass('active');
        clickedListElement.addClass('active');

        var id = clickedListElement.attr('index');
        $('#person-dropdown').jqxDropDownList({ selectedIndex: id - 1 });
        getUser(id);
    });

    var response = new $.jqx.response();
    var documentWidth = window.innerWidth;
    if (documentWidth < 1101)
    {
        $('#mainSplitter').jqxSplitter({ orientation: 'horizontal', panels: [{ size: '150' }, { size: '82%' }] });
    }
    rightPannelWidth = $('.rightPanel').width();
    $('#chart').css('width', rightPannelWidth - 314);
    $('#chart').jqxChart('refresh');
    var resizeEvent;
    response.resize(function ()
    {
        $("#person-dropdown").jqxDropDownList("close");
        $('#chart').jqxChart('update');

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

            var rightPannelWidth = $('.rightPanel').width();
            $('#chart').css('width', rightPannelWidth - 314);
            $('#chart').jqxChart('refresh');

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
        $('.exerciseTitles, .exerciseContainers').css('display', 'block');
        $('.back').css('display', 'inline-block');
        secondPageHeight()
    });

    $('.back').on('click', function ()
    {
        $('.exerciseTitles, .exerciseContainers, .back').css('display', 'none');
        $('#chart , .buttons-container, .person-stats').css('display', 'block');
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
    getChart(1, 'weightChart');
    dropDownList();
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
        }
    });

    $('#person-dropdown').on('select', function (event)
    {
        var id = event.args.index + 1;
        $('.person-container ul li').removeClass('active');
        $('.person-container ul li:nth-child(' + id + ')').addClass('active');
        getUser(id);
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

function chart(ChartType)
{

    'use strict';
    var chartPropertyName;
    if (ChartType === 'weightChart')
    {
        chartPropertyName = 'Weight';
    } else if (ChartType === 'msChart')
    {
        chartPropertyName = 'Muscle_strenght';
    } else if (ChartType === 'wbsChart')
    {
        chartPropertyName = 'WristCirc';
    } else if (ChartType === 'cbChart')
    {
        chartPropertyName = 'CaloriesBalance';
    } else if (ChartType === 'rhChart')
    {
        chartPropertyName = 'HeartRate';
    }

    var data = JSON.parse(localStorage.getItem('chart'));
    var dates = ['20160418', '20160419', '20160420', '20160421', '20160422'];
    var newData = [];
    for (var i = 0; i < data.length; i++) {
        var temp = { 'points': dates[i], 'data': data[i][chartPropertyName] };
        newData.push(temp); 
    }
    var toolTipCustomFormatFn = function (value, itemIndex, serie, group, categoryValue)
    {
        return '<div style="text-align:left"><b><i>' + categoryValue + ' : ' + value + '</i></b></div>';
    };

    var settings = {
        title: '',
        description: '',
        showBorderLine: false,
        showLegend: false,
        enableAnimations: false,
        toolTipFormatFunction: toolTipCustomFormatFn,
        padding: { left: 10, top: 10, right: 15, bottom: 10 },
        titlePadding: { left: 90, top: 0, right: 0, bottom: 10 },
        source: newData,
        xAxis: {
            dataField: 'points',
            unitInterval: 1,
            tickMarks: { visible: true, interval: 1 },
            gridLinesInterval: { visible: true, interval: 1 },
            valuesOnTicks: false,
            padding: { bottom: 10 }
        },
        valueAxis: {
            minValue: 0,
            title: { text: '' },
            labels: { horizontalAlignment: 'right' }
        },
        seriesGroups:
            [
                {
                    type: 'splinearea',
                    series:
                    [
                        {
                            dataField: 'data',
                            symbolType: 'cirlce',
                            labels:
                            {
                                visible: true,
                                backgroundColor: '#33CCCC',
                                backgroundOpacity: 0.2,
                                borderColor: '#33CCCC',
                                borderOpacity: 0.7,
                                padding: { left: 5, right: 5, top: 0, bottom: 0 }
                            }
                        }
                    ]
                }
            ]
    };
    $('#chart').jqxChart(settings);
    var myChart = $('#chart').jqxChart(settings);
    myChart.jqxChart('addColorScheme', 'myScheme', ['#33CCCC']);
    myChart.jqxChart('colorScheme', 'myScheme');
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

function getChart(UserId, ChartType)
{
    $.ajax({
        url: 'http://adept-adeptserver.rhcloud.com/' + ChartType,
        headers:
        {
            'parameters': '[{"UserId":' + UserId + ', "Points":5, "FromDate":"2016-04-18", "ToDate":"2016-04-22"}]'
        },
        method: 'GET',
        dataType: 'json',
        async: false,
        success: function (data)
        {
            localStorage.setItem('chart', JSON.stringify(data));
            console.log(JSON.parse(localStorage.getItem('chart')))
            chart(ChartType);
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