class FellRace.Views.AdminLink extends FellRace.View
  template: 'links/admin_list_item'
  tagName: "li"
  className: "link"
  events:
    'click a.delete': "delete"
    'click a.visit': "goto"
  bindings:
    "span.title": "title"
    'span.url': 'url'

  onRender: () =>
    @$el.find('.editable').editable()
    @stickit()

  delete: (e) =>
    e.preventDefault() if e
    @model.destroy()

class FellRace.Views.AddLink extends FellRace.View
  template: 'links/empty'
  tagName: "li"
  className: "note"

class FellRace.Views.AdminLinksList extends FellRace.CollectionView
  emptyView: FellRace.Views.AddLink
  itemView: FellRace.Views.AdminLink
