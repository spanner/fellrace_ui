class FellRace.Views.ResultsFile extends Backbone.Marionette.ItemView

  @field_aliases:
    pos: "position"
    place: 'position'
    no: 'number'
    cat: 'category'
    class: 'category'
    ageclass: 'category'
    time: 'elapsed_time'
    finish: 'elapsed_time'
    last_name: 'surname'
    lastname: 'surname'
    first_name: 'forename'
    firstname: 'forename'
    christian_name: 'forename'

  fields: ["position","number","forename","middlename","surname","name","club","category","elapsed_time"]

  template: "instances/results_file"
  size_limit: 10
  allowed_extensions: [".csv"]
  events:
    "change input.file": 'parseFile'
    "click a.empty": 'destroyResults'

  ui:
    filefield: "input.file"

  initialize: ->
    @checkpoints = _.without(@model.race.checkpoints.pluck("name"), "Start")

  onRender: =>
    @ui.filefield.click () -> @value = null
    @stickit()

  parseFile: =>
    if files = @ui.filefield[0].files
      Papa.parse files[0],
        header: true
        skipEmptyLines: true
        complete: ({data:data,erros:errors,meta:meta}={}) =>          
          json = @performancesJson(data, meta.fields)
          console.debug json
      @ui.filefield

  translateFields: (headers) =>
    field_translations = {}
    _.each headers, (header,i) =>
      data_field = header.toLowerCase().replace(/(-| )/,'')
      if @fields.indexOf(data_field) isnt -1
        field_translations[data_field] = header
        headers[i] = null
      else if data_field = FellRace.Views.ResultsFile.field_aliases[data_field]
        field_translations[data_field] = header
        headers[i] = null
    field_translations

  translateCheckpoints: (headers) =>
    # for now, just use exact matches (which is what we currently do in back end)
    checkpoint_translations = []

    _.each headers, (header) =>
      if @checkpoints.indexOf(header) isnt -1
        checkpoint_translations.push {
          csv_key: header
          json_key: header 
        }
    checkpoint_translations

  performancesJson: (parsed_data, headers) =>
    field_translations = @translateFields(headers)
    checkpoint_translations = @translateCheckpoints(_.compact(headers))

    performances = []
    _.each parsed_data, (csv_performance) =>
      performance = splits: []

      _.each field_translations, (csv_key, json_key) =>
        performance[json_key] = csv_performance[csv_key]

      _.each checkpoint_translations, (cp) =>
        string = csv_performance[cp.csv_key] || ""
        time = moment(string,["HH:mm:ss","mm:ss","HH.mm.ss","mm.ss"])
        performance.splits.push {
          name: cp.json_key
          elapsed_time: time.hours()*3600+time.minutes()*60+time.seconds()
        }

      performances.push performance

    json = {
      performances: performances
    }
    if checkpoint_translations.length > 0
      json.checkpoints = checkpoint_translations.map (cp) -> cp.json_key
    json


# class FellRace.Views.ResultsFile extends Backbone.Marionette.ItemView
#   template: "instances/results_file"
#   size_limit: 10
#   allowed_extensions: [".csv"]
#
#   events:
#     "change input.file": 'getPickedFile'
#     "click a.detach": 'removeFile'
#
#   bindings:
#     "label.pick":
#       observe: 'file'
#       onGet: "buttonText"
#     "a.detach":
#       observe: 'file'
#       visible: true
#     ".file_metadata":
#       observe: 'file'
#       visible: true
#     ".confirmation":
#       observe: 'file'
#       visible: true
#       visibleFn: "visibleInline"
#     ".filesize":
#       observe: "file_size"
#       onGet: "niceSize"
#     ".filename":
#       observe: "file_name"
#       onGet: "fileNameOrDefault"
#
#   onRender: () =>
#     @_filefield = @$el.find('input.file')
#     @stickit()
#
#   # file-selection
#
#   clickFileField: (e) =>
#     # not very reliable. we prefer to use labels where possible.
#     @_filefield.trigger('click')
#
#   getPickedFile: (e) =>
#     if files = @_filefield[0].files
#       @setFile files.item(0)
#       # @readLocalFile files[0]
#
#   removeFile: (e) =>
#     if e
#       e.preventDefault()
#       e.stopPropagation()
#     @model.dropFile()
#
#   # file-handling
#
#   readLocalFile: (file) =>
#     if file?
#       if @fileOk(file.name, file.size)
#         # job = _fellrace.announce("Reading file")
#         reader = new FileReader()
#         reader.onprogress = (e) ->
#           # job.setProgress(e)
#         reader.onloadend = () =>
#           @setFile reader.result, file.name, file.size
#           # job.complete()
#         reader.readAsDataURL(file)
#
#   setFile: (data, name, size) =>
#     @model.set
#       file: data
#       file_changed: true
#     ,
#       persistChange: true
#
#   fileOk: (filename, filesize) =>
#     @fileNameOk(filename, filesize) and @fileSizeOk(filename, filesize)
#
#   fileSizeOk: (filename, filesize) =>
#     if filesize > @size_limit * 1048576
#       @complain('toobig', filename, filesize)
#       false
#     else
#       true
#
#   fileNameOk: (filename, filesize) =>
#     ext = filename.split('.').pop().toLowerCase()
#     if @allowed_extensions.indexOf(".#{ext}") is -1
#       @complain('notcsv', filename, filesize)
#       false
#     else
#       true
#
#   niceSize: (value) =>
#     if value
#       if value > 1048576
#         mb = Math.floor(value / 10485.76) / 100
#         "#{mb}MB, "
#       else
#         kb = Math.floor(value / 1024)
#         "#{kb}KB, "
#     else
#       ""
#
#   complain: (error, filename, filesize) =>
#     if error is "toobig"
#       _fellrace.notify "refusal", "Sorry: there is a limit of #{@size_limit}MB for these files and #{filename} is #{@niceSize(filesize)}."
#     else if error is "notcsv"
#       _fellrace.notify "refusal", "Sorry: #{filename} doesn't look like a CSV file. Please choose another, or make sure that your file has the right extension."
#     else
#       _fellrace.notify "error", "Unknown file-selection error"
#
#   fileNameOrDefault: (name) =>
#     if name
#       name
#     else
#       "Previously uploaded file"
#
#   visibleInline: ($el, isVisible, options) =>
#     if isVisible
#       $el.css "display", "inline-block"
#     else
#       $el.css "display", "none"
#
#   buttonText: (file) =>
#     if file
#       "Replace results file"
#     else
#       "Upload CSV results file"
