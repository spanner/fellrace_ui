class FellRace.Views.Attachment extends FellRace.View
  template: 'attachments/list_item'
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
          onGet: "externalUrl"
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
          onGet: "externalUrl"
        },
        {
          name: 'class'
          observe: 'extension'
        }
      ]

  onRender: =>
    @stickit()

  externalUrl: (url) =>
    "//api.#{_fr.domain()}#{url}"

class FellRace.Views.AttachmentsList extends FellRace.CollectionView
  childView: FellRace.Views.Attachment