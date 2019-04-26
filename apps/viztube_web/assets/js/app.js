// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".

import "phoenix_html"
import socket from "./socket"
import "./semantic.min"

window.onload = function(){
  $('.ui.embed').embed();
  $('.ui.accordion').accordion();
  $('.ui.modal#user').modal().modal('show');

  $('.ui.search.dropdown').dropdown({
    allowAdditions: true
  });

  let videos = $('.video-data')

  videos.each(function(index, elem) {
    let videoTopic = elem.id.replace(/video-/g, ''),
        videoChannel = socket.channel('video:' + videoTopic, {})

    videoChannel.join()
    .receive("ok", data => {
      // console.log("joined topic: ", data)
    })
    .receive("error", resp => {
      console.log("unable to join topic", resp)
    })

    videoChannel.push("update", {id: videoTopic})

    videoChannel.on("update", payload => {
      $("#duration-" + videoTopic)[0].textContent = "Video duration: " + convert_time(payload["duration"])
      $("#commentCount-" + videoTopic)[0].innerHTML =
        (payload["comments"]) ?
          payload["comments"].replace(/\B(?=(\d{3})+(?!\d))/g, ",") + "<div class=\"detail\">comments</div>" :
          "0<div class=\"detail\">comments</div>"

      $("#viewCount-" + videoTopic)[0].innerHTML =
        (payload["views"]) ?
          payload["views"].replace(/\B(?=(\d{3})+(?!\d))/g, ",") + "<div class=\"detail\">views</div>" :
          "0<div class=\"detail\">views</div>"

      if (payload["lat"] && payload["lon"]) {
        $("#location-" + videoTopic)[0].innerHTML =
          "<a href=\"https://www.google.com/maps/place/" + payload["lat"] + "," + payload["lon"] + "\" target=\"_blank\"><i class=\"icon link large blue world\"></a>"
      }
    })
  });

  function convert_time(duration) {
    let hours, minutes, seconds
    let a = duration.match(/\d+/g);

    if (duration.indexOf('M') >= 0 && duration.indexOf('H') == -1 && duration.indexOf('S') == -1) {
        a = [0, a[0], 0];
    }

    if (duration.indexOf('H') >= 0 && duration.indexOf('M') == -1) {
        a = [a[0], 0, a[1]];
    }

    if (duration.indexOf('H') >= 0 && duration.indexOf('M') == -1 && duration.indexOf('S') == -1) {
        a = [a[0], 0, 0];
    }

    if (a.length == 3) {
      hours   = (a[0] < 10) ? "0"+ a[0] : a[0]
      minutes = (a[1] < 10) ? "0"+ a[1] : a[1]
      seconds = (a[2] < 10) ? "0"+ a[2] : a[2]
    }

    if (a.length == 2) {
      hours   = "00"
      minutes = (a[0] < 10) ? "0"+ a[0] : a[0]
      seconds = (a[1] < 10) ? "0"+ a[1] : a[1]
    }

    if (a.length == 1) {
      hours   = "00"
      minutes = "00"
      seconds = (a[0] < 10) ? "0"+ a[0] : a[0]
    }

    return hours + ":" + minutes + ":" + seconds
  }
}

$('a.metadata').click(function(e) {
  e.preventDefault();
  let jsonMetadata = JSON.parse($('.ui.modal#' + e.target.id)[0].childNodes[2].firstChild.textContent),
      duration     = $("#duration-" + e.target.id)[0].textContent.split(" ")[2],
      commentCount = $("#commentCount-" + e.target.id)[0].innerHTML.split("<")[0],
      viewCount    = $("#viewCount-" + e.target.id)[0].innerHTML.split("<")[0]

  let lat = ($("#location-" + e.target.id)[0].firstChild.classList.contains("disabled")) ? "" : $("#location-" + e.target.id)[0].innerHTML.split("\"")[1].split("/")[5].split(",")[0],
      lon = ($("#location-" + e.target.id)[0].firstChild.classList.contains("disabled")) ? "" : $("#location-" + e.target.id)[0].innerHTML.split("\"")[1].split("/")[5].split(",")[1]

  jsonMetadata["duration"] = duration
  jsonMetadata["view_count"] = viewCount
  jsonMetadata["comment_count"] = commentCount
  jsonMetadata["lat"] = lat
  jsonMetadata["lon"] = lon

  $('.ui.modal#' + e.target.id)[0].childNodes[2].firstChild.textContent = JSON.stringify(jsonMetadata, null, 2)

  $('.ui.modal#' + e.target.id)
    .modal()
    .modal('show');
})

$('a.tag').click(function(e) {
  e.preventDefault();
  let id = (e.target.id).split("-")[1]
  $('.ui.modal#tagmodal-' + id)
    .modal()
    .modal('show');
})

$('.ui.modal.delete')
  .modal()
  .modal('show');

// Import local files
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".
