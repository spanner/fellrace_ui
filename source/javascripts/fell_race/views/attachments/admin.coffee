class FellRace.Views.AdminAttachment extends FellRace.View
  template: 'attachments/admin_list_item'
  tagName: "li"
  className: "attachment"
  events:
    'click a.file_icon': "pickFile"
    'change input[type="file"]': "filePicked"
    'click a.delete': "delete"
  modelEvents: 
    "freeze": "freeze"
    "thaw": "thaw"
  bindings:
    "span.name":
      observe: "name"
      events: ["blur"]
    "a.file_icon":
      attributes: [{name: 'class', observe: 'extension'}]

  onRender: () =>
    @_filefield = @$el.find('input[type="file"]')
    @thaw()
    @stickit()
    @pickFile() if @model.isNew()

  pickFile: =>
    @_filefield.trigger('click')

  filePicked: (e) =>
    if files = @_filefield[0].files
      @model.set("file", files.item(0))

  freeze: () =>
    @$el.addClass('frozen')
    @$el.find('.editable').ineditable()

  thaw: () =>
    @$el.removeClass('frozen')
    @$el.find('.editable').editable()

  delete: (e) =>
    e.preventDefault() if e
    @model.destroy()
