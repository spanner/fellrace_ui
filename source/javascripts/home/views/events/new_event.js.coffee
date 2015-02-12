class Home.Views.NewEvent extends Backbone.Marionette.ItemView
  template: 'events/new'
  events: 
    "submit form": "submit"
  bindings:
    "#slug":
      observe: "slug"
      onSet: "slugify"
    ".availability": 
      observe: "slug"
      update: "checkSlug"

  initialize: () ->
    @model ?= new Home.Models.Event()
    $.getJSON "/api/events/taken", (response) =>
      @slugs = response
      @render()

  onRender: () =>
    @stickit()

  slugify: (value, options) =>
    _.string.slugify value

  checkSlug: ($el, value, model, options) =>
    value = _.string.slugify(value)
    @_flag = @$el.find('.availability')
    if value is ""
      $el.removeClass('ok').removeClass('notok').text("")
      @deny()
    else if @slugs? and value in @slugs
      $el.removeClass('ok').addClass('notok').text("#{value}.fellrace.org.uk is not available.")
      @deny()
    else if value.length < 3
      $el.removeClass('ok').addClass('notok').text("At least three letters, please")
      @deny()
    else if value.length >12
      $el.removeClass('ok').addClass('notok').text("No more than 12 letters, please")
      @deny()
    else
      $el.removeClass('notok').addClass('ok').text("#{value}.fellrace.org.uk is available.")
      @allow()

  allow: () =>
    @$el.find('.submit').slideDown()

  deny: () =>
    @$el.find('.submit').slideUp()

  submit: (e) =>
    e.preventDefault() if e
    @model.save {},
      success: (data) =>
        @model.trigger "created"
        @remove()
      error: () =>
        # handle error