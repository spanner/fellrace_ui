class FellRace.Views.RaceAdmin extends Backbone.Marionette.ItemView
  template: 'races/edit'
  className: "race"
  modelEvents:
    'change:show_checkpoints': 'setCheckpointVisibility'

  events:
    'click a.publish': 'publish'
    'click a.add_attachment': 'addAttachment'
    'click a.add_record': 'addRecord'
    'click a.add_checkpoint': 'addCheckpoint'
    # 'click a.add_instance': 'addInstance'
    'click a.add_link': 'addLink'
    'click a.checkpoint_route': "createRouteThroughCheckpoints"
    'click a.draw_route': "drawRoute"
    'click a.delete_route': 'deleteRoute'
    'keyup span.social': 'showPresence'

  bindings:
    # generally best to bind one element with each declaration:
    # updates are not triggered within a set of bound elements.

    '.name': 'name'
    '.description':
      observe: 'description'
      updateMethod: 'html'
    '.distance': 'distance'
    '.climb': "climb"
    '.cat': 'cat'

    'span.fb': 'fb_event_id'
    'span.twit': 'twitter_id'
    'span.fra': 'fra_id'
    'span.shr': 'shr_id'
    # 'span.analytics_id': "analytics_id"

    'input.race_show_attachments': "show_attachments"
    'ul.attachments':
      observe: "show_attachments"
      updateView: false
      visible: true

    'input.race_show_checkpoints': "show_checkpoints"
    'ul.checkpoints':
      observe: "show_checkpoints"
      updateView: false
      visible: true

    'input.race_show_route': "show_route"

    '.route_controls':
      observe: "show_route"
      updateView: false
      visible: true

    '.route_elevation': "route_elevation"

    '.route_distance':
      observe: "encoded_route"
      onGet: "getRouteDistance"

    'input.route_colour': "route_colour"

    '.no_route':
      observe: "encoded_route"
      updateView: false
      visible: (value) ->
        !value

    '.route_details':
      observe: "encoded_route"
      updateView: false
      visible: true

    'span.race_profile':
      observe: 'route_profile'
      update: "peify"

    'input.race_show_records': "show_records"
    'ul.records': 
      observe: "show_records"
      updateView: false
      visible: true

    'input.race_show_instances': "show_instances"
    'ul.instances':
      observe: "show_instances"
      updateView: false
      visible: true

    'input.race_show_links': "show_links"
    'ul.links':
      observe: "show_links"
      updateView: false
      visible: true
    'ul.autolinks':
      observe: "show_links"
      updateView: false
      visible: true

    '.organiser_name': "organiser_name"
    '.organiser_email': "organiser_email"
    '.organiser_phone': "organiser_phone"
    '.organiser_address':
      observe: "organiser_address"
      onSet: (val) ->
        val = null if /(\<div\>\<br\>\<\/div\>|\<br\>)/.test(val)
        val
    'input.race_show_organiser': "show_organiser"
    '.show_organiser':
      observe: "show_organiser"
      updateView: false
      visible: true

    '.requirements': "requirements"
    'input.race_show_requirements': "show_requirements"
    '.show_requirements': 
      observe: "show_requirements"
      updateView: false
      visible: true
    'a.add_instance':
      attributes: [
        {
          observe: "slug"
          name: "href"
          onGet: "newInstanceUrl"
        }
      ]

  onRender: =>
    @stickit()
    @$el.find('.editable').editable()
    @stickit()

    new FellRace.Views.AttachmentsList(collection: @model.attachments, el: @$el.find("ul.attachments")).render()
    new FellRace.Views.LinksList(collection: @model.links, el: @$el.find("ul.links")).render()
    new FellRace.Views.CheckpointsList(collection: @model.checkpoints, el: @$el.find("ul.checkpoints")).render()
    new FellRace.Views.RecordsList(collection: @model.records, el: @$el.find("ul.records")).render()
    new FellRace.Views.InstancesList(collection: @model.instances, el: @$el.find("ul.instances")).render()

  ## Flash a dom element to show that it has changed

  highlight: ($el, val, options) =>
    $el.signal_confirmation()

  ## Add hooks for each of our main collections.
  # The new empty object in each collection will be picked up by the relevant subview.

  addAttachment: =>
    @model.attachments.create({})

  addCheckpoint: =>
    @model.checkpoints.create({})

  addRecord: =>
    @model.records.create({})

  addLink: =>
    @model.links.create({})

  setCheckpointVisibility: () =>
    if @model.get('show_checkpoints') then @model.checkpoints.trigger('show') else @model.checkpoints.trigger('hide')

  createRouteThroughCheckpoints: =>
    @model.createRouteFromCheckpoints()

  drawRoute: =>
    @model.trigger "extend"

  setRoute: (path) =>
    @model.set encoded_route: path

  deleteRoute: =>
    @setRoute null

  showPresence: (e) =>
    el = $(e.currentTarget)
    val = _.str.trim(el.text())
    if val isnt ""
      el.addClass('present')
    else
      el.removeClass('present')

  getRouteDistance: =>
    @model.getRouteDistance()

  newInstanceUrl: (slug) =>
    "/races/#{slug}/new_instance"

  publish: =>
    @model.publish()

  error: (args) =>
    $.notify "Error fetching record", args

  peify: ($el, value, model, options) =>
    checkExist = setInterval(() =>
      if $el.length
        clearInterval(checkExist)
        $el.text value
        $el.peity("line")
        @old_peify()
    , 100)

  old_peify: () =>
    @$el.find('span.race_profile').peity "line",
      fill: "#e2e1dd"
      stroke: "#d6d6d4"
      width: 480
      height: 100
