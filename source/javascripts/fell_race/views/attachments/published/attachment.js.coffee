class FellRace.Views.PublishedAttachment extends Backbone.Marionette.ItemView
  template: 'attachments/published/list_item'
  model: FellRace.Models.PublishedAttachment
  tagName: "li"
  className: "attachment"

  events:
    "click a": "bypass"

  bindings:
    "a.file_name":
      observe: "name"
      attributes: [
        {
          name: "href"
          observe: "url"
        },
        {
          name: 'class'
          observe: 'extension'
        }
      ]
    "a.file_icon":
      attributes: [
        {
          name: "href"
          observe: "url"
        },
        {
          name: 'class'
          observe: 'extension'
        }
      ]

  onRender: =>
    @stickit()
