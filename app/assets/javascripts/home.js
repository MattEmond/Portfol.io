$.ajax ({
  url: "http://localhost:3000/stocks/one_day_chart/aapl",
  dataType: 'json',
  method: "GET",
  success: function(data) {
    $("#one-day").text(data);
    console.log(data)
  }
})
