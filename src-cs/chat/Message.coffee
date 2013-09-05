define ->
  Em.Object.extend
    type: "message"
    name: ""
    text: ""
    date: null

    init: ->
      @set "date", new Date()

    formattedDate: (->
      moment(@get("date")).format "HH:mm"
    ).property("date")

    isMessage: (->
       @get("type") is "message"
    ).property("type")

    isUser: (->
      @get("type") is "user"
    ).property("type")

    isPart: (->
      @get("type") is "part"
    ).property("type")

    isJoin: (->
      @get("type") is "join"
    ).property("type")

    isInfo: (->
      @get("type") is "info"
    ).property("type")

