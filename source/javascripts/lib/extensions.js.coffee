unless Number::toSimplestTime?
  Number::toSimplestTime = () ->
    if @ <= 0
      ""
    else
      if @ >= 3600
        h = Math.floor(@ / 3600)
        m = Math.floor(@ % 3600 / 60)
        s = Math.floor(@ % 60)
        m0 = if m < 10 then 0 else ""
        s0 = if s < 10 then 0 else ""
        "#{h}:#{m0}#{m}:#{s0}#{s}"
      else if @ >= 60
        m = Math.floor(@ / 60)
        s = Math.floor(@ % 60)
        s0 = if s < 10 then 0 else ""
        "#{m}:#{s0}#{s}"
      else
        @

unless String::toSeconds?
  String::toSeconds = () ->
    [s,m,h] = @split(":").reverse()
    seconds = (parseInt(s,10)||0) + 60 * (parseInt(m,10)||0) + 3600 * (parseInt(h,10)||0)

unless Date::round?
  Date::round = (interval) ->
    interval ?= 15
    resolution = 1000 * 60 * interval
    new Date(Math.round(@getTime() / resolution) * resolution)

unless Date::ceil?
  Date::ceil = (interval) ->
    interval ?= 15
    resolution = 1000 * 60 * interval
    new Date(Math.ceil(@getTime() / resolution) * resolution)
  
unless Date::floor?
  Date::floor = (interval) ->
    interval ?= 15
    resolution = 1000 * 60 * interval
    new Date(Math.floor(@getTime() / resolution) * resolution)

unless Date::addMinutes?
  Date::addMinutes = (interval) ->
    interval ?= 15
    new Date @getTime() + 1000 * 60 * interval 

unless Date::simpleTime?
  Date::simpleTime = ->
    hours = @getHours()
    minutes = @getMinutes()
    minutes = "0#{minutes}" if minutes < 10
    time = "at #{hours}:#{minutes}"

unless Date::simpleDate?
  Date::simpleDate = ->
    datetime = ""
    if @isToday()
      datetime += "today" 
    else if @isTomorrow()
      datetime += "tomorrow"
    else if @isYesterday()
      datetime += "yesterday"
    else
      day = @getUTCDate()
      month = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'][@getUTCMonth()]
      year = @getFullYear()
      datetime += "#{day} #{month} #{year}"
    datetime
  
unless Date::isToday?
  Date::isToday = () ->
    time = new Date()
    @getDate() == time.getDate() and @getMonth() is time.getMonth() and @getYear() is time.getYear()

unless Date::isTomorrow?
  Date::isTomorrow = () ->
    time = new Date()
    time.setHours(time.getHours() + 24)
    @getDate() is time.getDate() and @getMonth() is time.getMonth() and @getYear() is time.getYear()

unless Date::isYesterday?
  Date::isYesterday = () ->
    time = new Date()
    time.setHours(time.getHours() - 24)
    @getDate() is time.getDate() and @getMonth() is time.getMonth() and @getYear() is time.getYear()

