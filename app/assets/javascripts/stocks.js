// Error messages timeout function


$(document).ready(() => {
    setTimeout(() => {
        $(".alert").fadeOut('slow');
    }, 3000)
})

// news feed
$(document).on('turbolinks:load', function() {
  if (typeof stockTicker !== 'undefined') {
    newsFeed();
    historicalChart();
  }

  if ($('portfolio')) {
    pieChart();
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



var pieChart = function() {
  // debugger
  // in debugger use $('.js-stocks').data().stocks to see all data
// Create the chart
Highcharts.chart('portfolio', {
    chart: {
        plotBackgroundColor: null,
        plotBorderWidth: null,
        plotShadow: false,
        type: 'pie'
    },
    title: {
        text: 'Portfolio breakdown by sector'
    },
    tooltip: {
        pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
    },
    plotOptions: {
        pie: {
            allowPointSelect: true,
            cursor: 'pointer',
            dataLabels: {
                enabled: true,
                format: '<b>{point.name}</b>: {point.percentage:.1f} %',
                style: {
                    color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
                }
            }
        }
    },
    series: [{
        name: 'Sector',
        colorByPoint: true,
        data: [{
            name: 'IE',
            y: 56.33
        }, {
            name: 'Chrome',
            y: 24.03,
            sliced: true,
            selected: true
        }, {
            name: 'Firefox',
            y: 10.38
        }, {
            name: 'Safari',
            y: 4.77
        }, {
            name: 'Opera',
            y: 0.91
        }, {
            name: 'Other',
            y: 0.2
        }]
    }]
});
}


