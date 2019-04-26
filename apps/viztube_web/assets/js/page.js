import "./calendar.min"

export var Calendar = { run: function() {

  $("#rangestart").calendar({
    startMode: "year",
    minDate: new Date("01-01-2005 00:00"),
    maxDate: new Date(),
    disableMinute: true,
    formatter: {
      date: function (date, settings) {
        if (!date) return '';
        var day = date.getUTCDate() < 10 ? '0'+ date.getUTCDate() : date.getUTCDate();
        var month = date.getUTCMonth() + 1 < 10 ? '0' + (date.getUTCMonth() + 1) : date.getUTCMonth() + 1;
        var year = date.getUTCFullYear();
        return year + '-' + month + '-' + day;
      },
      time: function (time, settings) {
        if (!time) return '';
        var hour = time.getUTCHours() < 10 ? '0'+ time.getUTCHours():'' + time.getUTCHours();
        var min = time.getUTCMinutes() < 10 ? '0'+ time.getUTCMinutes():'' + time.getUTCMinutes();
        return hour + ':' + min + ":00";
      }
    }
  });

  $("#rangeend").calendar({
    startMode: "year",
    minDate: new Date("01-01-2005 00:00"),
    maxDate: new Date(),
    disableMinute: true,
    formatter: {
      date: function (date, settings) {
        if (!date) return '';
        var day = date.getUTCDate() < 10 ? '0'+ date.getUTCDate() : date.getUTCDate();
        var month = date.getUTCMonth() + 1 < 10 ? '0' + (date.getUTCMonth() + 1) : date.getUTCMonth() + 1;
        var year = date.getUTCFullYear();
        return year + '-' + month + '-' + day;
      },
      time: function (time, settings) {
        if (!time) return '';
        var hour = time.getUTCHours() < 10 ? '0'+ time.getUTCHours():'' + time.getUTCHours();
        var min = time.getUTCMinutes() < 10 ? '0'+ time.getUTCMinutes():'' + time.getUTCMinutes();
        return hour + ':' + min + ":00";
      }
    }
  });


}}
