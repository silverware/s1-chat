define ->
  Message = Em.Object.extend
    name: ""
    text: ""
    date: new Date()
    formattedDate: (->
      moment(@get("date")).format "HH:mm"
    ).property("date")

  exports =
    create: (name, text) ->
      message = Message.create
        name: name
        text: text
        date: new Date()
