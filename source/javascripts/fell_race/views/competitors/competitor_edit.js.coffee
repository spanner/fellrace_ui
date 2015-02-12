class FellRace.Views.CompetitorEdit extends Backbone.Marionette.ItemView
  template: 'competitors/edit'
  id: "competitor"

  events:
    'click a.claim': "claim"
    'click a.save': "save"

  bindings:
    "span.forename": "forename"
    # ".middlename": "middlename"
    "span.surname": "surname"
    ".gender":
      observe: "gender"
      selectOptions: {
        collection: 'this.genders'
        labelPath: 'name'
        valuePath: 'gender'
      }
      defaultOption: {
        label: 'Choose one...'
        value: null
      }
    "span.strava_id": "strava_id"
    "span.twitter_name": "twitter_name"
    "span.power_of_ten_id": "power_of_ten_id"
    "span.uka_number": "uka_number"
    "span.fra_number": "fra_number"
    "span.ap_id": "ap_id"
    "span.dob": "dob"
    "select.club":
      observe: "club_id"
      selectOptions: {
        collection: "clubs"
        labelPath: 'name'
        value_path: 'id'
      }

  clubs: =>
    _fellrace.clubs

  genders: [{name:'male', gender:"m"}, {name:'female', gender:"f"}]

  onRender: =>
    @$el.find('.editable').editable()
    @stickit()
    @model.on "change", =>
      @$el.find("a.save").removeClass "waiting"

    # @_performances = new FellRace.Collections.Performances()
    # @_performances.url = "#{@model.url()}/performances"
    # @_performances.fetch()

    # performances_list = new FellRace.Views.PerformancesTable
    #   collection: @_performances
    #   el: @$el.find ".performances"
    # if club = @model.get("club")
    #   @_club = _fellrace.clubs.findOrAdd(club)
    #   unless @_club.has("name")
    #     @_club.fetch()
    # 
    #   club_link = new FellRace.Views.ClubLink
    #     model: @_club
    #     el: @$el.find ".club"
    # 
    # performances_list.render()
    # club_link.render()
  save: =>
    @model.save {},
      success: =>
        @$el.find("a.save").addClass "waiting"
