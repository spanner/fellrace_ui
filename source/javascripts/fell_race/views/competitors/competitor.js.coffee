class FellRace.Views.Competitor extends Backbone.Marionette.ItemView
  template: 'competitors/show'
  id: "competitor"

  events:
    'click a.claim': "claim"
    'click a.disown': "disown"

  bindings:
    ".name": 
      observe: ["forename","surname"]
      onGet: "fullName"

    "p.description": "description"

    "span.category": "cat"

    ".cat":
      observe: ["dob", "gender"]
      visible: "any"
      visibleFn: "inlineBlock"

    ".cat .value":
      observe: ["dob","gender"]
      onGet: "category"

    ".age":
      observe: "dob"
      visible: true
      visibleFn: "inlineBlock"

    ".age .value":
      observe: "dob"
      onGet: "age"

    ".performances_count .value": "performances_count"
    ".years_racing .value": "years_racing"

    ".lives_in":
      observe: "location"
      visible: true
      visibleFn: "inlineBlock"

    ".lives_in .value": "location"

    ".born_in":
      observe: "birth_location"
      visible: true
      visibleFn: "inlineBlock"

    ".born_in .value": "birth_location"

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

  club_bindings:
    "a.club":
      observe: "name"
      attributes:[
        name: "href"
        observe: "id"
        onGet: (id) ->
          "/clubs/#{id}"
      ]

  onRender: =>
    @stickit()
    @stickit @model.club, @club_bindings
    performances_view = new FellRace.Views.CompetitorPerformancesTable
      collection: @model.performances
      competitor: @model
      el: @$el.find "table.performances"
    performances_view.render()

  any: (array) =>
    _.any array

  age: (dob) =>
    if dob and moment(dob, "YYYY-MM-DD").isValid()
      moment().diff(moment(dob, "YYYY-MM-DD"),"years")

  category: ([dob,gender]=[]) =>
    cat = if gender then gender else ""
    cat = "#{cat}#{@age dob}" if dob
    "Senior"

  fullName: ([first,last]=[]) =>
    "#{first} #{last}"

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
