class FellRace.Views.AdminEntriesImport extends Backbone.Marionette.ItemView
  template: 'instances/admin_entries_import'
  tagName: "section"

  events:
    "change input#entries_file": 'parseFile'

  # bindings:
  #   #

  _aliases: # alias: "model_attribute"
    firstname: "forename"
    lastname: "surname"
    fullname: "name"
    clubname: "club_name"
    club: "club_name"
    cat: "category"
    class: "category"
    sex: "gender"
    dateofbirth: "dob"

  _model_fields: ["forename","middlename","surname","name","club_name","category","dob","gender"]

  initialize: ->
    @_entries = @model.entries

  onRender: () =>
    @_filefield = @$el.find('input.file')
    @_filefield.click () -> @value = null
    @stickit()

  parseFile: () =>
    if files = @_filefield[0].files
      Papa.parse files[0],
        header: true
        complete: ({data:data,erros:errors,meta:meta}={}) =>
          @setFieldNames meta.fields
          _.each data, (entry) =>
            @addEntry entry
      @_filefield

  addEntry: (object) =>
    model = {}
    if object.name
      @splitName object
    _.each @_fields, (file_attr, model_attr) =>
      model[model_attr] = object[file_attr]
    if @_entries.present(forename: model.forename, surname: model.surname, dob: model.dob, gender: model.gender)#, club_name: model.club_name)
      console.log "#{model.forename} #{model.surname} is already entered"
    else
      model.accepted = true
      model.instance_id = @model.id
      entry = @_entries.add model
      entry.save()

  setFieldNames: (meta_fields) =>
    @_fields = {}
    _.each meta_fields, (field) =>
      sanitized_field = field.toLowerCase().replace(/\W/g, '')
      if sanitized_field in @_model_fields
        @_fields[sanitized_field] = field
      else if model_field = @_aliases[sanitized_field]
        @_fields[model_field] = field

    if @_fields.name
      @_fields["forename"] or= "forename"
      @_fields["middlename"] or= "middlename"
      @_fields["surname"] or= "surname"
      delete @_fields.name

  splitName: (object) =>
    if name = _.str.words object.name
      object.forename = name[0]
      object.surname = name[name.length - 1] if name.length > 1
      object.middlename = name[1] if name.length > 2
      delete object.name
