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


class FellRace.Views.AttachmentsList extends FellRace.CollectionView
  itemView: FellRace.Views.Attachment
