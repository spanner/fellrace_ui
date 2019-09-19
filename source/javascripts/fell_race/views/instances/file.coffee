class FellRace.Views.ResultsFile extends FellRace.View
  template: "instances/results_file"
  size_limit: 10
  allowed_extensions: [".csv"]

  events: 
    "change input.file": 'getPickedFile'
    "click a.detach": 'removeFile'

  bindings:
    "label.pick":
      observe: 'file'
      onGet: "buttonText"
    "a.detach":
      observe: 'file'
      visible: true
    ".file_metadata":
      observe: 'file'
      visible: true
    ".confirmation":
      observe: 'file'
      visible: true
      visibleFn: "visibleInline"
    ".filesize":
      observe: "file_size"
      onGet: "niceSize"
    ".filename":
      observe: "file_name"
      onGet: "fileNameOrDefault"

  onRender: () =>
    @_filefield = @$el.find('input.file')
    @stickit()

  # file-selection

  clickFileField: (e) =>
    # not very reliable. we prefer to use labels where possible.
    @_filefield.trigger('click')

  getPickedFile: (e) =>
    if files = @_filefield[0].files
      @setFile files.item(0)
      # @readLocalFile files[0]

  removeFile: (e) =>
    if e
      e.preventDefault()
      e.stopPropagation()
    @model.dropFile()

  # file-handling

  readLocalFile: (file) =>
    if file?
      if @fileOk(file.name, file.size)
        # job = _fr.announce("Reading file")
        reader = new FileReader()
        reader.onprogress = (e) ->
          # job.setProgress(e)
        reader.onloadend = () =>
          @setFile reader.result, file.name, file.size
          # job.complete()
        reader.readAsDataURL(file)

  setFile: (data, name, size) =>
    @model.set
      file: data
      file_changed: true
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
      @complain('notcsv', filename, filesize) 
      false
    else
      true

  niceSize: (value) =>
    if value
      if value > 1048576
        mb = Math.floor(value / 10485.76) / 100
        "#{mb}MB, "
      else
        kb = Math.floor(value / 1024)
        "#{kb}KB, "
    else
      ""
    
  complain: (error, filename, filesize) =>
    if error is "toobig"
      _fr.notify "refusal", "Sorry: there is a limit of #{@size_limit}MB for these files and #{filename} is #{@niceSize(filesize)}."
    else if error is "notcsv"
      _fr.notify "refusal", "Sorry: #{filename} doesn't look like a CSV file. Please choose another, or make sure that your file has the right extension."
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

  buttonText: (file) =>
    if file
      "Replace results file"
    else
      "Upload CSV results file"
