$.ajax ({
  url: "http://localhost:3000/stocks/one_day_chart/aapl",
  dataType: 'json',
  method: "GET",
  success: function(data) {
    $("#json").text(data);
    console.log(data)
  }
})
