class FellRace.Views.Competitor extends Backbone.Marionette.ItemView
  template: 'competitors/show'
  id: "competitor"

  events:
    'click a.claim': "claim"
    'click a.disown': "disown"

  bindings:
    "span.forename": "forename"
    "span.middlename": "middlename"
    "span.surname": "surname"

    # "a.strava":
    #   observe: "strava_id"
    #   visible: true
    #   attributes: [
    #     {
    #       observe: "strava_id"
    #       name: "href"
    #       onGet: (id) =>
    #         "https://www.strava.com/athletes/#{id}"
    #     }
    #   ]
    #
    # "a.ap":
    #   observe: "ap_id"
    #   visible: true
    #   attributes: [
    #     {
    #       observe: "ap_id"
    #       name: "href"
    #       onGet: (id) =>
    #         "http://www.attackpoint.org/log.jsp/user_#{id}"
    #     }
    #   ]

    # ".claim":
    #   observe: ["user_id", "merge_to_id"]
    #   visible: (val) ->
    #     !val[0] and !val[1]
    #   visibleFn: "inlineBlock"
    #
    # ".disown":
    #   observe: "user_id"
    #   visible: (val) ->
    #     val is _fellrace.currentUser()?.get "id"
    #   visibleFn: "inlineBlock"
    #
    # ".edit":
    #   observe: "permissions"
    #   visible: (permissions) =>
    #     permissions.can_edit
    #   attributes: [
    #     {
    #       observe: "id"
    #       name: "href"
    #       onGet: (val) ->
    #         "/runners/#{val}/edit"
    #     }
    #   ]
    #   visibleFn: "inlineBlock"

  onRender: =>
    @stickit()
    performances_view = new FellRace.Views.CompetitorPerformancesTable
      model: @model
      collection: @model.performances
      el: @$el.find ".results"
    performances_view.render()

    entries_view = new FellRace.Views.CompetitorEntriesTable
      model: @model
      collection: @model.entries
      el: @$el.find ".entries"
    entries_view.render()

  inlineBlock: ($el, isVisible, options) =>
    if isVisible
      $el.css display: "inline-block"
    else
      $el.hide()

  # claim: =>
  #   if _fellrace.userSignedIn()
  #     @model.save user_id: _fellrace.currentUser().get("id"),
  #       success: (model, data) =>
  #         if data.user_id is _fellrace.currentUser().get("id")
  #           $.notify "success", "The profile '#{@model.get "forename"} #{@model.get "surname"}' now belongs to you."
  #         else
  #           $.notify "success", "Merge request sent to admin."
  #   else
  #     $.notify "flash", "You have to be signed in to claim a competitor."
  #     #TODO show a competitor claim form instead of basic signIn
  #     _fellrace.user_actions().signIn()
  #
  # disown: =>
  #   @model.save user_id: null,
  #     success: (data) =>
  #       $.notify "success", "The profile '#{@model.get "forename"} #{@model.get "surname"}' no longer belongs to you."
