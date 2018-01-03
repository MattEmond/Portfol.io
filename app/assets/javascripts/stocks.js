// Error messages timeout function


$(document).ready(() => {
    setTimeout(() => {
        $(".alert").fadeOut('slow');
    }, 3000)
})


// news feed
$(document).on('turbolinks:load', function() {
  console.log(`Stockticker: ${stockTicker}`);
  if (stockTicker) {
    newsFeed();
    historicalChart();
  };
});


var newsFeed = function() {
  $.ajax({
  url: `http://localhost:3000/stocks/stock_news/${stockTicker}.json`,
  dataType: 'json',
  method: "GET",
  success: function(data) {
    for (let news in data) {
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
  });
};

var historicalChart = function() {
  $.getJSON(`http://localhost:3000/stocks/historical_chart/${stockTicker}.json`, function(data) {
    var parseData = data.map(function(obj) {
      var dateConcat = Date.parse(obj.date)
      return [dateConcat, obj.open, obj.high, obj.low, obj.close]
    })
    console.log(parseData)
    // Create the chart
    var chart = Highcharts.stockChart('container', {

      chart: {
        height: 400
      },

      title: {
        text: 'Historical Stock Data'
      },

      rangeSelector: {
        selected: 1
      },

      series: [
        {
          name: 'Stock Price',
          data: parseData,
          type: 'area',
          threshold: null,
          tooltip: {
            valueDecimals: 2
          }
        }
      ],

      responsive: {
        rules: [
          {
            condition: {
              maxWidth: 500
            },
            chartOptions: {
              chart: {
                height: 300
              },
              subtitle: {
                text: null
              },
              navigator: {
                enabled: false
              }
            }
          }
        ]
      }
    });
  });
}




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



