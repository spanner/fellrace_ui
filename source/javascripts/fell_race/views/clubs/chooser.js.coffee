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

  initialize: (options) =>
    @_chooser = options.chooser
    super

  onRender: =>
    @$el.find()
    @stickit()
    @model.on "change:highlighted", (highlighted) =>
      if highlighted
        @el.scrollIntoView(false)
  
  selectMe: (e) =>
    @_chooser.select(@model)

  highlight: =>
    @_chooser.highlight(@model)

  markWithTerms: (name) =>
    if terms = @_chooser.inputVal()
      terms = "(" + terms.split(/\s+/).join('|') + ")"
      re = new RegExp terms, "gi"
      if match = name.match(re)
        marked_name = name.replace(re, "<strong>$1</strong>")
        marked_name
      else
        name
    else
      name


class FellRace.Views.ClubChooser extends Backbone.Marionette.CollectionView
  tagName: "ul"
  className: "chooser"
  itemView: FellRace.Views.ClubSuggestion

  initialize: (options = {}) ->
    @_search_box = options.input
    @_source_collection = _fr.clubs
    @collection = new FellRace.Collections.Clubs
    @_hidden = true
    
  itemViewOptions: () =>
    options =
      chooser: @

  onRender: () =>
    @$el.insertAfter(@_search_box)
    if @_source_collection.size()
      @bindSearchBox()
    else
      @_source_collection.fetch().done @bindSearchBox

  bindSearchBox: () =>
    @_search_box.on 'keydown', @catchControlKeys
    @_search_box.on 'keyup', @moveHighlight
    refreshSuggestions = _.debounce(@setSuggestions, 100)
    if _fr.msie
      @_search_box.on 'keyup paste', (e) =>
        @_search_box.addClass('working')
        refreshSuggestions(e)
    else
      @_search_box.on 'input', (e) =>
        @_search_box.addClass('working')
        refreshSuggestions(e)
    @_search_box.on "blur", @hideSlowly
    @_search_box.on "focus", @showIfPopulated

  inputVal: () =>
    _.trim(@_search_box.val())

  setSuggestions: (e) =>
    if !e?.keyCode or !(e.keyCode in [13, 38, 40, 27])
      term = @inputVal()
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
    if @collection.length
      index = @collection.indexOfHighlight()
      if index < @collection.length - 1
        @collection.highlight(index + 1)
      else
        @collection.highlight(0)
    
  highlight: (club) =>
    @collection.clearHighlight()
    club.set("highlighted", true)

  selectHighlit: =>
    if @collection.length > 0
      @select @collection.getHighlit()
      
  select: (club) =>
    if club
      @_search_box.val(club.get("name"))
      @trigger "chosen"
      @hide()

  clearSearch: =>
    @_search_box.text("")
    @collection.reset []

  focus: () =>
    @_search_box.focus()