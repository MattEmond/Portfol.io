// news feed

$.ajax ({
  url: "http://localhost:3000/stocks/stock_news/aapl.json",
  dataType: 'json',
  method: "GET",
  success: function(data) {
    for(let news in data){
        newsObj = data[news];
        $listitem = $("<li>");
        $news_url = $("<a>").attr("href", newsObj.url);
        $headline = $("<p>").text(newsObj.headline);
        $source = $("<span>").addClass("source_news").text(newsObj.source);
        $link = $news_url.append($headline);
        $news_item = $listitem.append($link).append($source);
        $("#news").prepend($news_item);
    }

  }
})


$(function () {
     // create chart here
    // Build the chart
    Highcharts.chart('pie_chart', {
        chart: {
            plotBackgroundColor: null,
            plotBorderWidth: null,
            plotShadow: false,
            type: 'pie',
            title: false,
            backgroundColor: false,
        },
        legend: {
              itemStyle: {
                 fontSize:'12px',
                 font: 'Oswald',
                 color: '#fff'
              },
              itemHoverStyle: {
                 color: '#1B88B6'
              }

        },
        title: {
            text: '',
            style: {
                display: 'none'
            }
        },
        tooltip: {
            pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
        },
        plotOptions: {
            pie: {
                allowPointSelect: true,
                cursor: 'pointer',
                dataLabels: {
                    enabled: false
                },
                showInLegend: true
            }

        },
        series: [{
            name: 'Brands',
            color: '#fff',
            colorByPoint: true,
            data: [{
                name: 'Apple',
                y: 100
            }, {
                name: 'Google',
                y: 50,
                sliced: true,
                selected: true
            }, {
                name: 'Amazon',
                y: 30
            }, {
                name: 'Sony',
                y: 45
            }, {
                name: 'Delta',
                y: 12
            }]
        }]
    });
});



