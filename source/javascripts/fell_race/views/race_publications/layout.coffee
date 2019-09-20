class FellRace.Views.RacePublicationLayout extends FellRace.Views.LayoutView

  routes: () =>
    "(/)": @default
    "checkpoints/:checkpoint_slug(/*path)": @checkpoint
    "history(/*path)": @history
    ":instance_name(/*path)": @instance

  onRender: =>
    race_view = new FellRace.Views.RacePublication
      model: @model
    @$el.append race_view.el
    race_view.render()

  default: =>
    _fr.noExtraView()

  instance: (instance_name,path) =>
    instance = @model.past_instances.findWhere(name: instance_name)
    instance ?= @model.future_instances.findWhere(name: instance_name)
    if instance
      if instance.populated
        view = new FellRace.Views.InstanceLayout
          model: instance
          path: path
      else
        instance.set fetching:true
        instance.fetch().done =>
          instance.build()
          instance.populated = true
          instance.set fetching:false
          @instance instance_name,path

  checkpoint: (slug,path) =>
    if cp = @model.checkpoints.findWhere(slug: slug)
      _fr.noExtraView()
      _fr.moveMapTo cp

  history: (path) =>
    _fr.showExtraView new FellRace.Views.RaceHistory
      model: @model
