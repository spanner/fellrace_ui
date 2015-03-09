class FellRace.Views.EntryRow extends Backbone.Marionette.ItemView
  template: "entries/row"
  className: "entry"
  tagName: "tr"

  bindings:
    "a.name":
      attributes: [
        {
          observe: "competitor_id"
          name: "href"
          onGet: "competitorUrl"
        }
      ]
    "span.fore": 
      observe: "forename"
    "span.middle": 
      observe: "middlename"
    "span.sur": 
      observe: "surname"
    "td.club": "club_name"
    "td.cat": "category_name"

  onRender: =>
    @stickit()
    @$el.addClass('postal') if @model.get('accepted')

  competitorUrl: (id) ->
    "/runners/#{id}"

  clubUrl: (id) ->
    "/clubs/#{id}" if id
  
  rowClass: (value) =>
    cssclass = "entry"
    cssclass << " postal" if value
    cssclass

class FellRace.Views.EntriesTable extends Backbone.Marionette.CompositeView
  itemView: FellRace.Views.EntryRow
  template: "entries/table"
  itemViewContainer: "tbody"
