class FellRace.Views.AdminClubRow extends Backbone.Marionette.ItemView
  template: "clubs/admin_row"
  tagName: "tr"
  className: "club"

  events:
    "click a.merge": "merge"
    "click a.remove_alias": "removeAlias"
    "click a.merge_to": "mergeTo"
    "click a.cancel_merge": "cancelMerge"

  bindings:
    ":el":
      attributes: [
        name: "data-id"
        observe: "id"
      ]
    "span.id": "id"
    "span.name": "name"
    "span.full_name": "full_name"
    "span.short_name": "short_name"

    "span.alias_of":
      observe: "original_club_id"
      onGet: "aliasName"
    "a.merge_to":
      observe: "original_club_id"
      visible: "untrue"
    "a.merge, a.remove_alias":
      observe: "original_club_id"
      visible: true
    "a.cancel_merge":
      observe: "merging"
      visible: true

  onRender: =>
    @$el.find('.editable').editable()
    @stickit()

  aliasName: (id) =>
    if id
      if name = _fellrace.clubs.findWhere(id:id).get("name")
        name
      else
        "missing club"

  merge: =>
    alias = @model.get("name")
    club_name = _fellrace.clubs.findWhere(id:@model.get "original_club_id").get("name")
    if confirm "Merge '#{alias}' into '#{club_name}'?"
      $.post "#{@model.url()}/merge", (data) =>
        _fellrace.clubs.remove(@model)
        $.notify "success", "Merged '#{alias}' into '#{club_name}"

  untrue: (val) =>
    !val

  removeAlias: =>
    @model.set original_club_id: null, {persistChange: true}

  mergeTo: =>
    @model.set merging: true
    $("table.clubs").addClass "merging"
    $("tr.club").on "click", @gotAlias

  cancelMerge: =>
    @model.set merging: false
    $("table.clubs").removeClass "merging"
    $("tr.club").off "click", @gotAlias

  gotAlias: (e) =>
    id = parseInt(e.currentTarget.dataset.id,10)
    unless id is @model.id
      $("table.clubs").removeClass "merging"
      $("tr.club").off "click", @gotAlias
      @model.set original_club_id: id, {persistChange:true}
      @model.set merging: false

class FellRace.Views.AdminClubsTable extends Backbone.Marionette.CompositeView
  template: "clubs/admin_table"
  tagName: "section"
  itemView: FellRace.Views.AdminClubRow
  itemViewContainer: "tbody"
  id: "clubs"

  initialize: ->
    @collection = _fellrace.clubs
    @collection.fetch()

  onRender: =>
    console.log @collection
