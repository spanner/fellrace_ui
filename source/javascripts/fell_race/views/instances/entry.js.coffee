class FellRace.Views.Entries extends Backbone.Marionette.ItemView
  template: 'instances/entry'
  className: "instance"

  events:
    "click a.enter": "buildEntry"
    "click a.cancel": "cancelEntry"
    "click a.sign_in": "signIn"

  bindings:
    ".name": "name"
    'span.fee':
      observe: "entry_fee"
      onGet: (fee) =>
        fee ||= 0.00
        "£#{fee.toFixed(2)}"
    'span.entries_closing': "closing_date"
    'span.total_entries': "total_entries"
    'table':
      observe: "total_entries"
      visible: true
    'span.limit':
      observe: "entry_limit"
      visible: true
    'span.entry_limit': "entry_limit"
    'span.limit_reached':
      observe: ["total_entries","entry_limit"]
      visible: true
      onGet: ([total,limit]=[]) ->
        total and limit and total is limit
    'span.remaining':
      observe: ["total_entries","entry_limit"]
      onGet: ([total,limit]=[]) ->
        limit - total
    'span.hurry':
      observe: ["total_entries","entry_limit"]
      visible: true
      onGet: ([total,limit]=[]) ->
        total and limit and total < limit and total > 0.7 * limit

  initialize: ->
    # @model.entries?.fetch()

  onRender: () =>
    @stickit()
    new FellRace.Views.EntriesTable
      collection: @model.entries
      el: @$el.find("tbody.entries")

    @enter_controls = @$el.find("p.enter")
    @entry_form = @$el.find(".entry_form")
    @sign_in_button = @$el.find("a.sign_in")
    @competitor_view = new FellRace.Views.EntryCompetitor
      model: _fellrace.getCurrentCompetitor()
      el: @$el.find ".competitor"
    @competitor_view.render()

    @entry_form.hide()

    if _fellrace.userSignedIn()
      @showCompetitor()
    _fellrace.vent.on "login:changed", =>
      if _fellrace.userSignedIn()
        @showCompetitor()
      else
        @hideCompetitor()

  buildEntry: =>
    @enter_controls.hide()
    @entry_form.show()

  cancelEntry: =>
    @enter_controls.show()
    @entry_form.hide()

  showCompetitor: =>
    @sign_in_button.hide()
    @competitor_view.show()

  hideCompetitor: =>
    @sign_in_button.show()
    @competitor_view.hide()

  signIn: =>
    _fellrace.user_actions().signIn()

class FellRace.Views.EntryInstances extends Backbone.Marionette.CollectionView
  itemView: FellRace.Views.EntryInstance
