define ->
  Message = 
    create: (name, text) ->
      message = 
        name: name
        text: text
        date: new Date()