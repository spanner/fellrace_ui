class FellRace.Views.CategoryOption extends Backbone.Marionette.ItemView
  template: 'categories/option'
  tagName: 'li'

  bindings: 
    "span.name": "name"
    "input":
      attributes: [
        name: "value"
        observe: "name"
      ]
      
  onRender: =>
    @stickit()


class FellRace.Views.CategoryPicker extends Backbone.Marionette.CompositeView
  template: 'categories/picker'
  itemView: FellRace.Views.CategoryOption
  itemViewContainer: ".categories"

  bindings: 
    "input.category": "category_names"

  initialize: ->
    @collection = _fr.getCategories()

  onRender: ->
    @stickit()

  appendHtml: (collectionView, itemView, index) =>
    $container = @getItemViewContainer(collectionView)
    name = itemView.model.get('name')
    group = switch
      when (itemView.model.get('junior')) then 'junior'
      when (itemView.model.get('name')[0] is 'F') then 'female'
      else 'male'
    $container.find("ul.#{group}").append(itemView.$el)
