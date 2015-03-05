class FellRace.Views.ClubSuggestion extends Backbone.Marionette.ItemView
  template: "clubs/suggestion"
  className: "suggestion"
  tagName: "li"

  events:
    "click": "selectMe"
    "mouseenter": "highlight"

  bindings: =>
    "span.name":
      observe: "name"
      updateMethod: 'html'
      onGet: "markWithTerms"
    ":el":
      attributes: [
        observe: "highlighted"
        name: "class"
        onGet: (highlighted) => if highlighted then "current" else ""
      ]

  onRender: =>
    @$el.find()
    @stickit()
    @model.on "change:highlighted", (highlighted) =>
      if highlighted
        @el.scrollIntoView(false)
  
  selectMe: (e) =>
    @model.collection.trigger "select", @model

  highlight: =>
    @model.collection.trigger "highlight", @model

  markWithTerms: (name) =>
    # terms = "(" + terms.join('|') + ")"
    # re = new RegExp terms, "gi"
    name


class FellRace.Views.ClubChooser extends Backbone.Marionette.CollectionView
  tagName: "ul"
  className: "chooser"
  itemView: FellRace.Views.ClubSuggestion
  
  initialize: (options = {}) ->
    @_search_box = options.input
    @_source_collection = _fellrace.clubs
    @collection = new FellRace.Collections.Clubs
    @collection.on "select", @select
    @collection.on "highlight", @highlight
    @_hidden = true

  onRender: () =>
    @$el.insertAfter(@_search_box)
    if @_source_collection.size()
      @bindSearchBox()
    else
      @_source_collection.fetch().done @bindSearchBox

  bindSearchBox: () =>
    console.log "ClubChooser bindSearchBox", @_source_collection.size()
    @_search_box.on 'keydown', @catchControlKeys
    @_search_box.on 'keyup', @moveHighlight
    refreshSuggestions = _.debounce(@setSuggestions, 100)
    if _fellrace.msie
      @_search_box.on 'keyup paste', (e) =>
        @_search_box.addClass('working')
        refreshSuggestions(e)
    else
      @_search_box.on 'input', (e) =>
        @_search_box.addClass('working')
        refreshSuggestions(e)
    @_search_box.on "blur", @hideSlowly
    @_search_box.on "focus", @showIfPopulated
    $.sb = @_search_box

  setSuggestions: (e) =>
    if !e?.keyCode or !(e.keyCode in [13, 38, 40, 27])
      term = _.trim(@_search_box.val())
      if term
        re = new RegExp term, "i"
        @collection.reset @_source_collection.filter (club) =>
          re.test club.get("name")
      else
        @collection.reset()
      if @collection.length
        @show() if @_hidden
      else 
        @hide()
    @_search_box.removeClass('working')

  show: () =>
    @$el.show()
    @_hidden = false
    $(document).bind "click", @hide

  hideSlowly: () =>
    @$el.fadeOut "slow", () =>
      @hide()

  hide: () =>
    @$el.hide()
    @_hidden = true
    $(document).unbind "click", @hide
  
  showIfPopulated: () =>
    @show() if @collection.length

  ## Handle search box events, 
  # by catching control keypresses and turning them into actions on the suggestion set.
  #
  catchControlKeys: (e) =>
    code = e.keyCode
    if code in [13, 38, 40]
      e.preventDefault()

  moveHighlight: (e) =>
    code = e.keyCode
    if code in [13, 38, 40, 27]
      e.preventDefault()
      e.stopImmediatePropagation()
    if code is 13 then @selectHighlit()
    else if code is 38 then @moveHighlightUp()
    else if code is 40 then @moveHighlightDown()
    else if code is 27 then @hide()

  moveHighlightUp: =>
    if @collection.length > 1
      index = @collection.indexOfHighlight()
      if index > 0
        @collection.highlight(index - 1)
      else
        @collection.highlight(@collection.length - 1)

  moveHighlightDown: =>
    if @collection.length > 1
      index = @collection.indexOfHighlight()
      if index < @collection.length - 1
        @collection.highlight(index + 1)
      else
        @collection.highlight(0)
    
  highlight: (suggestion) =>
    @collection.unhighlightAll()
    suggestion.set("highlighted", true)

  selectHighlit: =>
    if @collection.length > 0
      @select @collection.getHighlit()
      
  select: (suggestion) =>
    if suggestion
      @_search_box.val(suggestion.get("name"))
      @hide()

  clearSearch: =>
    @_search_box.text("")
    @collection.reset []

  focus: () =>
    @_search_box.focus()