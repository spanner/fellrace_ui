jQuery ($) ->

  methodMap =
    create: "POST"
    update: "PUT"
    delete: "DELETE"
    read: "GET"

  getUrl = (object) ->
    return null  unless object and object.url
    (if _.isFunction(object.url) then object.url() else object.url)

  urlError = ->
    throw new Error("A 'url' property or function must be specified")

  Backbone.sync = (method, model, options) ->
    type = methodMap[method]
    
    # Default JSON-request options.
    params = _.extend(
      type: type
      dataType: "json"
      beforeSend: (xhr) ->
        unless options.noCSRF
          token = $("meta[name=\"csrf-token\"]").attr("content")
          xhr.setRequestHeader "X-CSRF-Token", token  if token
        model.trigger "sync:start"
    , options)
    params.url = getUrl(model) or urlError()  unless params.url
    
    # Ensure that we have the appropriate request data.
    if not params.data and model and (method is "create" or method is "update")
      params.contentType = "application/json"
      data = {}
      if model.paramRoot
        data[model.paramRoot] = model.toJSON()
      else
        data = model.toJSON()
      params.data = JSON.stringify(data)
    
    # Don't process data on a non-GET request.
    params.processData = false  if params.type isnt "GET"
    
    # Trigger the sync end event
    complete = options.complete
    params.complete = (jqXHR, textStatus) ->
      model.trigger "sync:end"
      complete jqXHR, textStatus  if complete

    success = options.success
    params.success = (resp) ->
      success model, resp, options  if success
      model.trigger "sync", model, resp, options

    error = options.error
    params.error = (xhr) ->
      error model, xhr, options  if error
      model.trigger "error", model, xhr, options

    
    # Make the request.
    $.ajax params
