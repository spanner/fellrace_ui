#
# Modern Sortable
#
# HTML5 native drag and drop sortables. Event-driven, requires jquery.
# Partly derived from Ali Farhadi's html5-sortable but repackaged and
# unburdened by jquery UI compatibility.
# 
## Usage
#
#     $('ul.sortable').sortable(
#       placeholder: '<li class="ph" />',
#       selector: 'li'
#       handle: 'span.handle'
#     )
#
# After a successful drag and drop a 'sorted' event is triggered on the dropped item, from where
# it bubbles up to the (possibly now different) parent on which sortable was called.
#
# Connection between sortables is going to work at some point but I haven't needed it yet.
#
# Written by Will for Spanner, March 2014
#
#
jQuery ($) ->

  $.sortable = (el, options) ->
    new Sortable(el, options)

  class Sortable
    constructor: (element, opts={}) ->
      defaults =
        placeholder: '<li class="placeholder" />'
        selector: "li"
        handle: false
        connected: null
      @_options = $.extend defaults, opts

      @_placeholder = $(@_options.placeholder)
      @_placeholder.bind 'drop.sortable', @putDown
      @_placeholder.bind 'dragover.sortable dragenter.sortable', @ignore

      @_container = $(element)
      @_container.bind 'changed', @refresh
      @_container.bind 'appended', @refresh
      @_container.bind 'refresh', @refresh
      @_container.bind 'dragend.sortable', @finish

      # if a handle selector is defined then we place a marker on drag events 
      # that have been preceded by a mousedown on a handle. Without that marker
      # subsequent drag events are ignored.
      @_handling = false
      @populate()
      @

    refresh: (e) =>
      @_items?.off 'dragstart.sortable dragend.sortable dragover.sortable dragenter.sortable drop.sortable'
      @populate()

    populate: () =>
      @_items = @_container.children(@_options.selector)
      @_items
        .attr 'draggable', true
        .bind 'dragstart.sortable', @pickup
        .bind 'dragover.sortable dragenter.sortable', @move
        .bind 'drop.sortable', @putDown
        .bind 'dragend.sortable', @finish
        # .not('a[href], img').bind 'selectstart.sortable', @ieBeginDrag # causing problems with [contenteditable]
      if @_options.handle
        @_items.find(@_options.handle)
          .bind "mousedown", @handle
          .bind "mouseup", @unhandle

    handle: (e) =>
      @_handling = true

    unhandle: (e) =>
      @_handling = false
      true

    pickup: (e) =>
      e.stopImmediatePropagation()
      return false if @_options.handle and not @_handling
      @_handling = false
      @_dragging = $(e.target)
      e.originalEvent.dataTransfer= 'move'
      e.originalEvent.dataTransfer.setData 'Text', 'sorting'
      e.originalEvent.dataTransfer.setDragImage(@_dragging.get(0), 0, 0)
      @_original_index = @_dragging.index()
      @_original_parent = @_dragging.parent()
      @_dragging.addClass('dragging')
      @_placeholder.height(@_dragging.outerHeight())
      @_original_parent.trigger 'sorting', @_dragging
      
    ieBeginDrag: (e) =>
      return true if @_handling
      e.target.dragDrop() if e.target and e.target.dragDrop
      false

    ignore: (e) =>
      e.preventDefault()
      e.originalEvent.dataTransfer= 'move'
      return true

    move: (e) =>
      return true unless @_dragging? and @_items.is(@_dragging) #todo: or we are a named target for the drag source
      e.preventDefault()
      e.stopPropagation()
      drag_target = $(e.currentTarget)
      @_dragging.hide()
      previously_placed = @_placeholder.parent().get(0)?
      previous_index = if previously_placed? then @_placeholder.index() else @_original_index
      new_index = drag_target.index()
      if new_index < previous_index
        drag_target.before @_placeholder
      else
        drag_target.after @_placeholder

    # insert dragged element at drop location
    putDown: (e) =>
      e.stopPropagation()
      e.originalEvent.dataTransfer.dropEffect = 'move'
      @_dragging.insertAfter(@_placeholder)
      @_dragging.trigger('dragend.sortable')
      return false  # we've dealt with the drop event

    finish: (e) =>
      return unless @_dragging
      new_parent = @_dragging.parent()
      @_placeholder.detach()
      new_index = @_dragging.index()
      @_dragging.removeClass('dragging').show()
      if new_index isnt @_original_index or new_parent.get(0) isnt @_original_parent.get(0)
        # usually new_parent will be the same as original_parent 
        # and this the same as triggering 'sorted' on @_container
        new_parent.trigger 'sorted', @_dragging,
          old_index: @_original_index
          new_index: new_index
          old_parent: @_original_parent
          new_parent: new_parent
      @_dragging = null
