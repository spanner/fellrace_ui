class _Notification extends Backbone.View
  tagName: "div"
  className: "notification"


class _Loader extends _Notification
  className: "notification loader",

  render: =>
    @$el.html(@text).append($("<em>"))
    @

  finish: =>
    el = @$el
    el.fadeOut "fast", -> el.remove()


class _SelectorLoader extends _Loader
  className: "notification loader selector"


class _ProgressBar extends _Loader
  className: "notification progress"
  update: (prog) =>
    @$el.find("em").width(prog + "%");
    @


class FellRace.Views.Notifier extends FellRace.View
  className: "notifications"
  defaults:
    wait: 4000

  initialize: (options={}) ->
    @loaders = {}
    @wait = options.wait || defaults.wait
    @model.on "flash", @notifyFlash
    @model.on "error", @notifyError
    @model.on "success", @notifySuccess
    @model.on "start:loader", @startLoader
    @model.on "finish:loader", @finishLoader
    @model.on "start:progress", @startProgressBar
    @model.on "finish:progress", @finishProgressBar
    @model.on "update:progress", @updateProgressBar

  notify: (text, type, wait) =>
    notification = new _Notification
      text: text
      type: type
      wait: wait or @wait
    notification.render()
    @$el.append notification.el
    notification

  notifyFlash: (message) =>
    @notify(message, 'flash')

  notifyError: (message) =>
    @notify(message, 'error')

  notifySuccess: (message) =>
    @notify(message, 'success')

  startLoader: (message, selector) =>
    if selector
      @_startSelectorLoader(message, selector)
    else
      @_startRootLoader(message)

  _startRootLoader: (message) =>
    unless @loaders["root"]
      @loaders["root"] = new _Loader
        text: message
      @loaders["root"].render()
      @$el.append @loaders["root"].el

  _startSelectorLoader: (message, selector) =>
    unless @loaders[selector]
      @loaders[selector] = new _SelectorLoader
        text: message
      @loaders[selector].render()
      $(selector).css("position", "relative").append(@loaders[selector].el)

  finishLoader: (selector) =>
    if selector and @loaders[selector]
      $(selector).css("position", "")
      @_finishAndClearLoader(selector)
    else if @loaders['root']
      @_finishAndClearLoader("root")

  _finishAndClearLoader: (selector) =>
    this.loaders[selector].finish();
    this.loaders[selector] = null

  startProgressBar: (message) =>
    unless @progress_bar
      @progress_bar = new _ProgressBar
        text: message
      @progress_bar.render()
      @$el.append @progress_bar.el

  updateProgressBar: (progress) =>
    if @progress_bar
      @progress_bar.update(progress)

  finishProgressBar: () =>
    if @progress_bar
      @progress_bar.update(100);
      _.delay @progress_bar.finish, @wait
      @progress_bar = null
