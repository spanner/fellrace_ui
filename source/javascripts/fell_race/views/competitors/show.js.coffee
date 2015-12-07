class FellRace.Views.Competitor extends Backbone.Marionette.ItemView
  template: 'competitors/show'
  id: "competitor"

  events:
    'click a.claim': "claim"
    'click a.disown': "disown"

  bindings:
    'a.edit':
      observe: "permissions"
      visible: "canEdit"
      attributes: [
        observe: ["id","permissions"]
        name: "href"
        onGet: ([id,permissions]=[]) ->
          "/admin/runners/#{id}" if permissions?.can_edit
      ]

    "span.forename": "forename"
    "span.middlename": "middlename"
    "span.surname": "surname"

    ".picture":
      attributes: [
        name: "style"
        observe: 'picture'
        onGet: "backgroundImageUrl"
      ]

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

    if _fellrace.userConfirmed() and @model.get("permissions")?.can_edit
      match_table = new FellRace.Views.MatchTable
        model: @model
        el: @$el.find(".matches")
      match_table.render()

  canEdit: ({can_edit:can_edit}={}) ->
    can_edit

  inlineBlock: ($el, isVisible, options) =>
    if isVisible
      $el.css display: "inline-block"
    else
      $el.hide()

  backgroundImageUrl: (url) =>
    if url
      if url.match(/data:image/)
        "background-image: url(#{url})"
      else if url.match(/^\//)
        "background-image: url(#{_fellrace.apiUrl()}#{url})"
      else
        "background-image: url(#{url})"

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
