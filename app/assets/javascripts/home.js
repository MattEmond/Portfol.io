

$.getJSON('http://localhost:3000/stocks/historical_chart/aapl.json', function (data) {
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

        series: [{
            name: 'Stock Price',
            data: parseData,
            type: 'area',
            threshold: null,
            tooltip: {
                valueDecimals: 2
            }
        }],

        responsive: {
            rules: [{
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
            }]
        }
    });
});



