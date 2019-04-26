import socket from "./socket"

export var Queries = { run: function() {

  let t = $('table#queries-list'),
      id = t.data("id"),
      topic = "query:" + id,
      channel = socket.channel(topic, {})

  channel.join()

  .receive("ok", data => {
    // console.log("Joined topic:", data)
  })
  .receive("error", resp => {
    console.log("unable to join topic", resp)
  });

  // To update view :/
  window.setInterval(function(){
    let rows = $('table#queries-list tr')
    rows.each(function(e, i) {
      if (i.getAttribute("id") != null) {
        let date = new Date(i.getAttribute("data-date"))
        channel.push("update", {id: i.getAttribute("id")})
      }
    })
  }, 30000)

  // update last_checked and videos fields when receive update
  channel.on("update", payload => {
    let rows = $('table#queries-list tr')
    rows.each(function(e, i) {
      if (i.getAttribute("id") == payload["id"]) {
        i.getElementsByClassName('last-checked')[0].textContent = payload["last_checked"]
        i.getElementsByClassName('videos')[0].textContent = payload["videos"] || 0
      }
    })
  })

  $('.ui.search.dropdown').dropdown({
    allowAdditions: true
  });

}}
