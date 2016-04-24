$(document).ready(function ()
{
    $('#mainSplitter').jqxSplitter({
        width: '100%',
        height: '100%',
        resizable: false,
        showSplitBar: false,
        panels: [{ size: '346' }]
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

        $('.buttons-container ul li').removeClass('person-active');
        $('.buttons-container ul li:nth-child(3)').addClass('person-active');

        var id = clickedListElement.attr('index');
        $('#person-dropdown').jqxDropDownList({ selectedIndex: id - 1 });
        getUser(id);
        getChart(id, 'weightChart');
        setTimeout(function ()
        {
            $('.exerciseTitles, .exerciseContainers, .back').css('display', 'none');
            $('#chart , .buttons-container, .person-stats').css('display', 'block');
            $('.gear').css('display', 'inline-block');
            mainPageHeight();
        }, 500)
    });

    var response = new $.jqx.response();
    var documentWidth = window.innerWidth;
    if (documentWidth < 1101)
    {
        $('#mainSplitter').jqxSplitter({ orientation: 'horizontal', panels: [{ size: '150' }] });
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
                $('#mainSplitter').jqxSplitter({ orientation: 'horizontal', panels: [{ size: '150' }] });
            } else
            {
                $('#mainSplitter').jqxSplitter({ orientation: 'vertical', panels: [{ size: '346' }] });
            }

            var rightPannelWidth = $('.rightPanel').width();
            $('#chart').css('width', rightPannelWidth - 314);
            $('#chart').jqxChart('refresh');

            secondPageHeight();
            mainPageHeight();

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
        var rightPannelWidth = $('.rightPanel').width();
        $('#chart').css('width', rightPannelWidth - 314);
        $('#chart').jqxChart('refresh');
        mainPageHeight();
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
    var photoslinks = ['./assets/people/60_borkata.png', './assets/people/60_ivo.jpg', './assets/people/60_marto.jpg', './assets/people/60_petar.jpg',
                       './assets/people/60_evgeni.jpg', './assets/people/60_kosio.jpg', './assets/people/60_teodora.jpg', './assets/people/60_joro.jpg'
    ];
    var users = JSON.parse(localStorage.getItem('usersDB'));
    var names = [];
    for (var i = 0; i < users.length; i++)
    {
        names.push(users[i].Name);
    }

    $('#person-dropdown').jqxDropDownList({
        selectedIndex: 0, source: names, theme: 'metrodark', width: 400, height: 65, autoItemsHeight: true, dropDownHeight: 300,
        renderer: function (index, label, value)
        {
            var imgurl = photoslinks[index];
            var img = '<img class="table-img-format" src="' + imgurl + '"/>';
            var table = '<table class="table-content"><tr><td class="table-img">' + img + '</td><td class="table-text">' + label + '</td></tr></table>';
            return table;
        },
        selectionRenderer: function (element, index, label, value)
        {
            var imgurl = photoslinks[index];
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

        $('.buttons-container ul li').removeClass('person-active');
        $('.buttons-container ul li:nth-child(3)').addClass('person-active');

        getUser(id);
        getChart(id, 'weightChart');
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
            //$('.person-container ul li:nth-child(' + (i + 1) + ') span').css('background-image', 'url(' + data[i].picture_small + ')');
        }
        localStorage.setItem('usersDB', JSON.stringify(data));

        var photoslinks = ['./assets/people/60_borkata.png', './assets/people/60_ivo.jpg', './assets/people/60_marto.jpg', './assets/people/60_petar.jpg',
                       './assets/people/60_evgeni.jpg', './assets/people/60_kosio.jpg', './assets/people/60_teodora.jpg', './assets/people/60_joro.jpg'
        ];
        for (var i = 1; i < 9; i++)
        {
            $('.person-container ul li:nth-child(' + i + ') span').css('background-image', 'url(' + photoslinks[i - 1] + ')');
        }
    });
    return false;
})();

function chart(ChartType)
{

    'use strict';
    var chartPropertyName;
    var newData = [], min = 99999, max = 0, dates = [];
    for (var i = 0; i < 7; i++)
    {
        var oneWeekAgo = new Date();
        oneWeekAgo.setDate(oneWeekAgo.getDate() - i);
        var day = oneWeekAgo.getDate();
        var month = oneWeekAgo.getMonth() + 1;
        var year = oneWeekAgo.getFullYear();
        var date = year + '/' + month + day;
        dates.push(date);
    }
    dates.reverse();
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
    for (var i = 0; i < data.length; i++)
    {
        var temp = { 'points': dates[i], 'data': data[i][chartPropertyName] };
        newData.push(temp);
    }
    
    for (var i = 0; i < newData.length; i++)
    {
        if (newData[i].data < min)
        {
            min = newData[i].data;
        }
        if (newData[i].data > max)
        {
            max = newData[i].data;
        }
    }
    console.log(min,max)

    
    if (ChartType === 'weightChart')
    {
        min = min - 0.1;
        max = max + 0.1;
    } else if (ChartType === 'msChart')
    {
        min = min - 50;
        max = max + 50;
    } else if (ChartType === 'wbsChart')
    {
        min = min - 0.1;
        max = max + 0.1;
    } else if (ChartType === 'cbChart')
    {
        min = min - 100;
        max = max + 100;
    } else if (ChartType === 'rhChart')
    {
        min = min - 2;
        max = max + 2;
    }
    

    var toolTipCustomFormatFn = function (value, itemIndex, serie, group, categoryValue)
    {
        var symbol = '/';
        var output = [categoryValue.slice(0, 6), symbol, categoryValue.slice(6)].join('');
        return '<div style="text-align:left"><b><i>' + output + ' : ' + value.toString().substr(0, 5) + '</i></b></div>';
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
            padding: { bottom: 10 },
            formatFunction: function (value)
            {
                var symbol = '/';
                var output = [value.slice(0, 6), symbol, value.slice(6)].join('');
                return output;
            }
        },
        valueAxis: {
            minValue: min,
            maxValue: max,
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
                            formatFunction: function (value)
                            {
                                return value.toString().substr(0, 5);
                            },
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
            $('.person-big-img').css('border-color', '#ff33cc');
            break;
        case -1:
            $('.person-big-img').css('border-color', '#7f33cc');
            break;
        case 0:
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
    var photoslinks =
        {
            'Borislav Filipov': './assets/people/170_borkata.png', 'Ivo Zhulev': './assets/people/170_ivo.jpg',
            'Martin Kuvandzhiev': './assets/people/170_marto.jpg', 'Peter Lazarov': './assets/people/170_petar.jpg',
            'Evgeni Sabev': './assets/people/170_evgeni.jpg', 'Konstantin Jleibinkov': './assets/people/170_kosio.jpg',
            'Teodora Malashevska': './assets/people/170_teodora.jpg', 'Georgi Velev': './assets/people/170_joro.jpg',
        };

    $.ajax({
        url: 'http://adept-adeptserver.rhcloud.com/userdata',
        headers:
        {
            'parameters': '[{ "UserId" :' + UserId + '}]'
        },
        method: 'GET',
        dataType: 'json',
        async: true,
        success: function (data)
        {
            var muscleStrength = data[0].avgForce.toString() + '.';
            muscleStrength = muscleStrength.substr(0, muscleStrength.indexOf("."));
            var restingHearthRate = data[0].RestingHeartRate.toString() + '.';
            restingHearthRate = restingHearthRate.substr(0, restingHearthRate.indexOf("."));

            $('.person-name').html(data[0].Name.toUpperCase());
            $('.person-title').html(data[0].Title);
            $('.weight-stats').html(data[0].Weight);
            $('.MS-stats').html(muscleStrength);
            $('.WBS-stats').html(data[0].WristCirc);
            $('.CB-stats').html(data[0].CaloriesBalance);
            $('.RHR-stats').html(restingHearthRate);
            //$('.person-big-img').css('background-image', 'url(' + data[0].picture_big + ')');
            $('.person-big-img').css('background-image', 'url(' + photoslinks[data[0].Name] + ')');
            OverallConditionCircleColor(data[0].OverallCondition);
        }
    });
    return false;
}

function getChart(UserId, ChartType)
{
    var date = new Date();
    var day = date.getDate();
    var month = date.getMonth() + 1;
    var year = date.getFullYear();
    var currentDate = year + '-' + month + '-' + day;
    var oneWeekAgo = new Date();
    oneWeekAgo.setDate(oneWeekAgo.getDate() - 7);
    var pastDay = oneWeekAgo.getDate();
    var pastMonth = oneWeekAgo.getMonth() + 1;
    var pastYear = oneWeekAgo.getFullYear();
    var pastDate = pastYear + '-' + pastMonth + '-' + pastDay;

    $.ajax({
        url: 'http://adept-adeptserver.rhcloud.com/' + ChartType,
        headers:
        {
            'parameters': '[{"UserId":' + UserId + ', "Points":7, "FromDate":"' + pastDate + '", "ToDate":"' + currentDate + '"}]'
        },
        method: 'GET',
        dataType: 'json',
        async: true,
        success: function (data)
        {
            localStorage.setItem('chart', JSON.stringify(data));
            console.log(data)
            chart(ChartType);
        }
    });
    return false;
}

function mainPageHeight()
{
    var mainHeight = $('.person-info-container').height() + $('.person-stats').height() + $('.buttons-container').height() + $('#chart').height()
    if ($('#mainSplitter').jqxSplitter('orientation') === 'vertical')
    {
        $('#mainSplitter').jqxSplitter({ height: mainHeight + 350 });
    } else
    {
        $('#mainSplitter').jqxSplitter({ height: mainHeight + 501 });
    }
    $('#chart').jqxChart('refresh');
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
    $('.exerciseContainers').jqxPanel({ width: '76%', height: 180, scrollBarSize: 8 });

}