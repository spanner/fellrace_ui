class FellRace.Views.RacePublicationIndexItem extends FellRace.View
  template: "race_publications/index_item"

  bindings:
    "span.name": "name"
    "a.race_link":
      attributes: [
        name: "href"
        observe: "slug"
        onGet: "raceUrl"
      ]
    'span.profile':
      observe: 'route_profile'
      onGet: 'simplifyProfile'

    'a.edit':
      observe: "permissions"
      visible: "canEdit"
      attributes: [
        observe: ["slug","permissions"]
        name: "href"
        onGet: ([slug,permissions]=[]) ->
          if permissions?.can_edit
            "/admin/races/#{slug}"
      ]

  onRender: =>
    @stickit()
    if @model.has("route_profile") and @model.get("route_profile") != ""
      _.defer @peify

  simplifyProfile: (profile) =>
    if profile and profile != ""
      elevations = profile.split(',').map (e) -> parseInt(e)
      elevations.join(',')

  peify: =>
    @$el.find('span.profile').peity "line",
      fill: "#e2e1dd"
      stroke: "#d6d6d4"
      width: 40
      height: 24

  raceUrl: (slug) ->
    "/races/#{slug}"

  canEdit: ({can_edit:can_edit}={}) ->
    can_edit

class FellRace.Views.RacePublicationsIndex extends FellRace.CollectionView
  template: "race_publications/index"
  tagName: "section"
  childView: FellRace.Views.RacePublicationIndexItem
  itemViewContainer: ".races"
