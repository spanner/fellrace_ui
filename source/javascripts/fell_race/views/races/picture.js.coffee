class FellRace.Views.Picture extends Backbone.Marionette.ItemView
  template: "races/picture"
  size_limit: 10
  allowed_extensions: [".png",".jpg",".jpeg"]

  events: 
    "change input.file": 'getPickedFile'
    "drop .picture": 'getDroppedFile'
    "click a.dropbox": 'getDropboxFile'
    "dragenter .preview": 'dragIn'
    "dragleave .preview": 'dragOut'
    "dragover .preview": 'containEvent'
    "click a.detach": 'removeImage'
    "click a.help": "showHelp"

  bindings: 
    ":el":
      attributes: [
        name: "style"
        observe: 'picture'
        onGet: "backgroundImageUrl"
      ]
    "a.detach":
      observe: 'picture'
      visible: true
    ".picture_metadata":
      observe: 'picture'
      visible: true
    ".confirmation":
      observe: 'picture'
      visible: true
      visibleFn: "visibleInline"
    ".filesize": 
      observe: "image_size"
      onGet: "niceSize"
    ".filename": 
      observe: "image_name"
      onGet: "imageNameOrDefault"
    ".dimensions": 
      observe: ["image_width", "image_height"]
      onGet: "imageDimensions"

  onRender: () =>
    @_filefield = @$el.find('input.file')
    @$el.find('label.pick').addClass('camera') if Modernizr.ios6plus
    @$el.find('a.dropbox').hide() unless Modernizr.dropbox
    # @model.readDimensions()
    @stickit()

  # file-selection

  clickFileField: (e) =>
    # not very reliable. we prefer to use labels where possible.
    @_filefield.trigger('click')

  getPickedFile: (e) =>
    if files = @_filefield[0].files
      @readLocalFile files[0]

  getDropboxFile: (e) =>
    e.preventDefault() if e
    Dropbox.choose
      multiselect: false
      linkType: "direct"
      extensions: @allowed_extensions
      success: @readDropboxFile

  getDroppedFile: (e) =>
    @dragOut(e)
    if files = e.originalEvent.dataTransfer.files
      @readLocalFile files[0]

  removeImage: (e) =>
    if e
      e.preventDefault()
      e.stopPropagation()
    @model.dropImage()

  # file-handling

  readLocalFile: (file) =>
    if file?
      if @fileOk(file.name, file.size)
        # job = _fellrace.announce("Reading file")
        reader = new FileReader()
        reader.onprogress = (e) -> 
          # job.setProgress(e)
        reader.onloadend = () =>
          @setImage reader.result, file.name, file.size
          # job.complete()
        reader.readAsDataURL(file)

  readDropboxFile: (files) =>
    if file = files[0]
      if @fileOk(file.name, file.bytes)
        url = file.link
        # job = _fellrace.announce("Reading file #{file.name} from dropbox")
        request = new XMLHttpRequest()
        request.responseType = "blob"
        request.onprogress = (e) -> 
          # job.setProgress(e)
        request.onloadend = (e) =>
          @setImage window.URL.createObjectURL(e.srcElement.response), file.name, file.bytes
          # job.complete()
        request.open("GET", url, true)
        request.send(null)

  setImage: (data, name, size) =>
    @model.set picture: data, {persistChange:true}
    @model.set "image_name", name
    @model.set "image_size", size
    @model.set "image_changed", true

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
      @complain('notimage', filename, filesize) 
      false
    else
      true
    
  complain: (error, filename, filesize) =>
    if error is "toobig"
      _fellrace.notify "refusal", "Sorry: there is a limit of #{@size_limit}MB for these files and #{filename} is #{@niceSize(filesize)}. Please choose another image or make this one smaller before uploading."
    else if error is "notimage"
      _fellrace.notify "refusal", "Sorry: #{filename} doesn't look like an image file. We can handle jpeg, png and gif files. Please choose another, or make sure that your file has the right extension."
    else
      _fellrace.notify "error", "Unknown file-selection error"

  # drag and drop event handling
  
  dragIn: (e) =>
  dragOut: (e) =>
  containEvent: (e) =>

  # onGet formatters
  
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

  imageDimensions: ([x,y]) =>
    if x and y
      "#{x}x#{y}px"

  imageNameOrDefault: (name) =>
    if name
      name
    else
      "Previously uploaded image"
  
  visibleInline: ($el, isVisible, options) =>
    if isVisible
      $el.css "display", "inline-block"
    else
      $el.css "display", "none"

  pictureUrl: (url) =>
    if url
      if url.match(/data:image/)
        url
      else
        "#{_fellrace.apiUrl()}/#{url}"

  backgroundImageUrl: (url) =>
    if url
      if url.match(/data:image/)
        "background-image: url(#{url})"
      else
        "background-image: url(#{_fellrace.apiUrl()}/#{url})"
