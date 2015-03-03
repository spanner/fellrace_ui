class FellRace.Views.InstanceEnter extends Backbone.Marionette.ItemView
  template: 'instances/enter'

  bindings:
    ".race_name": "race_name"
    ".instance_name": "name"

    "a.close, a.race_name":
      attributes: [
        name: "href"
        observe: "race_slug"
        onGet: "racePublicationUrl"
      ]

    'a.enter_postal':
      observe: 'postal_entry_active'
      visible: true
      visibleFn: "visibleBlock"
      attributes: [
        name: "href"
        observe: "entry_form"
      ,
        name: "class"
        observe: "entry_form_type"
      ]

  onRender: () =>
    @stickit()

  racePublicationUrl: (slug) =>
    "/races/#{slug}"

  adminUrl: ([slug,name]) =>
    "/admin/races/#{slug}/#{name}"

  visibleBlock: ($el, isVisible, options) =>
    if isVisible
      $el.css display: "inline-block"
    else
      $el.hide()
    