

$.ajax ({
  url: "http://localhost:3000/stocks/one_day_chart/aapl.json",
  dataType: 'json',
  method: "GET",
  success: function(data) {
    $("#one-day").text(data);
    console.log(data)
    var parseData = data.map(function(obj) {
      return [obj.date, obj.minute, obj.average]
    })
  }
})



$.getJSON('http://localhost:3000/stocks/one_day_chart/aapl.json', function (data) {
  var parseData = data.map(function(obj) {
    var dateConcat = Date.parse(obj.date)
    return [dateConcat, obj.open, obj.high, obj.low, obj.close]
  })
  console.log(parseData)
    // create the chart
    Highcharts.stockChart('container', {


        title: {
            text: 'AAPL stock price by minute'
        },

        subtitle: {
            text: 'Using ordinal X axis'
        },

        xAxis: {
            gapGridLineWidth: 0
        },

        rangeSelector: {
            buttons: [{
                type: 'hour',
                count: 1,
                text: '1h'
            }, {
                type: 'day',
                count: 1,
                text: '1D'
            }, {
                type: 'all',
                count: 1,
                text: 'All'
            }],
            selected: 1,
            inputEnabled: false
        },

        series: [{
            name: 'AAPL',
            type: 'area',
            data: parseData,
            gapSize: 5,
            tooltip: {
                valueDecimals: 2
            },
            fillColor: {
                linearGradient: {
                    x1: 0,
                    y1: 0,
                    x2: 0,
                    y2: 1
                },
                stops: [
                    [0, Highcharts.getOptions().colors[0]],
                    [1, Highcharts.Color(Highcharts.getOptions().colors[0]).setOpacity(0).get('rgba')]
                ]
            },
            threshold: null
        }]
    });
});



