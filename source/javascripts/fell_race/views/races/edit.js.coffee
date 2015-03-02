class FellRace.Views.Race extends Backbone.Marionette.ItemView
  template: 'races/edit'
  className: "race"
  modelEvents:
    'change:show_checkpoints': 'setCheckpointVisibility'

  events:
    'click a.publish': 'publish'
    'click a.add_attachment': 'addAttachment'
    'click a.add_record': 'addRecord'
    'click a.add_checkpoint': 'addCheckpoint'
    'click a.add_link': 'addLink'
    'click a.checkpoint_route': "createRouteThroughCheckpoints"
    'click a.draw_route': "drawRoute"
    'click a.delete_route': 'deleteRoute'
    'keyup span.social': 'showPresence'

  bindings:
    # generally best to bind one element with each declaration:
    # updates are not triggered within a set of bound elements.
    'a.publish':
      attributes: [
        {
          observe: "publishing"
          name: "class"
          onGet: (publishing) =>
            "publishing" if publishing
        }
      ]
    "a.close":
      attributes: [
        name: "href"
        observe: "race_slug"
        onGet: (race_slug) =>
          "/races/#{race_slug}"
      ]
    "label.pick":
      observe: 'picture'
      onGet: "buttonText"

    '.name': 'name'
    '.description':
      observe: 'description'
      updateMethod: 'html'
    '.distance': 'distance'
    '.climb': "climb"
    '.cat': 'cat'

    'span.fb': 'fb_event_id'
    'span.twit': 'twitter_id'
    'span.shr': 'shr_id'
    # 'span.analytics_id': "analytics_id"

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

    '.organiser_name': "organiser_name"
    '.organiser_email': "organiser_email"
    '.organiser_phone': "organiser_phone"
    '.organiser_address':
      observe: "organiser_address"
      onSet: (val) ->
        val = null if /(\<div\>\<br\>\<\/div\>|\<br\>)/.test(val)
        val

    '.requirements': "requirements"

    'a.add_instance':
      attributes: [
        observe: "slug"
        name: "href"
        onGet: "newInstanceUrl"
      ]

  onRender: =>
    @stickit()
    @$el.find('.editable').editable()
    @stickit()

    new FellRace.Views.NextRaceInstance(model:@model,el:@$el.find(".next_or_recent")).render()
    new FellRace.Views.Picture(model: @model, el: @$el.find(".picture")).render()
    new FellRace.Views.AdminAttachmentsList(collection: @model.attachments, el: @$el.find("ul.attachments")).render()
    new FellRace.Views.AdminLinksList(collection: @model.links, el: @$el.find("ul.links")).render()
    new FellRace.Views.AdminCheckpointsList(collection: @model.checkpoints, el: @$el.find("ul.checkpoints")).render()
    new FellRace.Views.AdminRecordsList(collection: @model.records, el: @$el.find("ul.records")).render()
    new FellRace.Views.AdminFutureInstancesList(collection: @model.future_instances, el: @$el.find("ul.future_instances")).render()
    new FellRace.Views.AdminPastInstancesList(collection: @model.past_instances, el: @$el.find("ul.past_instances")).render()

  ## Flash a dom element to show that it has changed

  highlight: ($el, val, options) =>
    $el.signal_confirmation()

  ## Add hooks for each of our main collections.
  # The new empty object in each collection will be picked up by the relevant subview.

  addAttachment: =>
    @model.attachments.create({})

  addCheckpoint: =>
    @model.checkpoints.create(pos: @model.checkpoints.length - 1)

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
    "/admin/races/#{slug}/new_instance"

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
      width: @$el.find(".profile").width()
      height: 50

  buttonText: (image) =>
    if image
      "Replace picture"
    else
      "Choose picture"

  date: (date) =>
    moment(date).format("D MMMM YYYY") if date
