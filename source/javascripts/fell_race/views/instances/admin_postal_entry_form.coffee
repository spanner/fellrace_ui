class FellRace.Views.AdminPostalEntryForm extends FellRace.View
  template: "instances/admin_postal_entry_form"
  size_limit: 1
  allowed_extensions: [".pdf"]

  events: 
    "change input.file": 'getPickedFile'
    "click a.detach": 'removeFile'

  bindings:
    "label.pick":
      observe: ['entry_form', 'entry_form_name']
      onGet: "buttonText"
      attributes: [
        name: "class"
        observe: 'entry_form_name'
        onGet: "buttonClass"
      ]
    "a.detach":
      observe: 'entry_form'
      visible: true
    ".confirmation":
      observe: 'entry_form'
      visible: true
      visibleFn: "visibleInline"
    "span.note":
      observe: "entry_form_size"
      onGet: "niceSize"
      

  onRender: () =>
    @_filefield = @$el.find('input.file')
    @stickit()

  # file-selection

  getPickedFile: (e) =>
    if files = @_filefield[0].files
      @readLocalFile files[0]
      
  removeFile: (e) =>
    if e
      e.preventDefault()
      e.stopPropagation()
    @model.dropFile()

  readLocalFile: (file) =>
    if file?
      if @fileOk(file.name, file.size)
        @model.set
          entry_form: file
          entry_form_changed: true
          entry_form_name: file.name
          entry_form_type: file.type
          entry_form_size: file.size
        , 
          persistChange: true

  fileOk: (filename, filesize) =>
    @fileNameOk(filename, filesize) and @fileSizeOk(filename, filesize)

  fileSizeOk: (filename, filesize) =>
    if filesize > @size_limit * 1048576
      @complain('toobig', filename, filesize) 
      false
    else
      true

  fileNameOk: (filename, filesize) =>
    ext = filename.split('.').pop().toLowerCase()
    if @allowed_extensions.indexOf(".#{ext}") is -1
      @complain('wrongtype', filename, filesize) 
      false
    else
      true

  niceSize: (value) =>
    if value
      if value > 1048576
        mb = Math.floor(value / 10485.76) / 100
        "#{mb}MB"
      else
        kb = Math.floor(value / 1024)
        "#{kb}KB"
    else
      "PDF files only, please"
    
  complain: (error, filename, filesize) =>
    if error is "toobig"
      _fr.notify "refusal", "Sorry: there is a limit of #{@size_limit}MB for these files and #{filename} is #{@niceSize(filesize)}."
    else if error is "wrongtype"
      _fr.notify "refusal", "Sorry: #{filename} doesn't look like a PDF file. Please choose another, or make sure that your file has the right extension."
    else
      _fr.notify "error", "Unknown file-selection error"

  fileNameOrDefault: (name) =>
    if name
      name
    else
      "Previously uploaded file"
  
  visibleInline: ($el, isVisible, options) =>
    if isVisible
      $el.css "display", "inline-block"
    else
      $el.css "display", "none"

  buttonText: ([file, file_name]=[]) =>
    if file
      file_name
    else
      "Upload entry form"
  
  buttonClass: (filename) =>
    ext = filename?.split('.').pop()
    "pick #{ext}"