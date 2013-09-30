Chat.GeoLocationMixin = Ember.Mixin.create
  getLoaction: (callback) ->
    showMap = (position) ->
      latitude = position.coords.latitude
      longitude = position.coords.longitude
      callback position

    handleError = (error) ->
      if error.code is 1
        console.debug "user said no"

    if Modernizr.geolocation
      navigator.geolocation.getCurrentPosition showMap, handleError
    else
      # no native support; maybe try a fallback?
