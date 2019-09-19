# This is a collection of interface elements. They're all self-contained. Most are attached to a 
# form element and cause its value to change, but there are also some standalone widgets that live
# on the page and follow their own rules.

jQuery ($) ->

  # appearing and disappearing the standard rails flash messages.
  
  $.fn.flash = ->
    @each ->
      container = $(this)
      container.fadeIn "fast"
      $("<a href=\"#\" class=\"closer\">close</a>").prependTo(container).bind "click", (e) ->
        e.preventDefault()
        container.slideUp "normal"



  # The collapser is a self-expanding unit.

  $.fn.expander = (options) ->
    @each ->
      new Expander(@, options)
    @

  class Expander
    constructor: (link) ->
      @link = $(link)
      @toggled = $(@link.attr('data-affected'))
      @set()
      @link.click @toggle
      
    set: () =>
      if @link.hasClass("open") then @show() else @hide()
      
    toggle: (e) =>
      e.preventDefault() if e
      if @link.hasClass("open") then @hide() else @show()

    hide: () =>
      @link.removeClass('open')
      @toggled.stop().slideUp 
        duration: 'slow'
        easing: 'glide'

    show: () =>
      @link.addClass('open')
      @toggled.stop().slideDown
        duration: 'normal'
        easing: 'boing'




  ## Form Widgets
  #
  # These attach to a form element and provide a nicer interface by which to update its content.

  class DatePicker
    constructor: (element) ->
      @_container = $(element)
      @_trigger = @_container.find('a')
      @_field = @_container.find('input')
      @_holder = @_container.find('div.kal')
      @_mon = @_container.find('span.mon')
      @_dom = @_container.find('span.dom')
      @_year = @_container.find('span.year')
      @_kal = new Kalendae @_holder[0]
      @_holder.hide()
      @_trigger.click @toggle
      @_container.click @contain
      @_kal.subscribe 'change', () =>
        @hide()
        @_field.val(@_kal.getSelected())
        [year, month, day] = @_kal.getSelected().split('-')
        @_year.text(year)
        @_dom.text(day)
        @_mon.text(Kalendae.moment.monthsShort[parseInt(month, 10) - 1])

    contain: (e) =>
      e.stopPropagation() if e

    toggle: (e) =>
      e.preventDefault() if e
      if @_holder.is(':visible') then @hide() else @show()

    show: () =>
      @_holder.fadeIn "fast", () =>
        @_container.addClass('editing')
        $(document).bind "click", @hide
              
    hide: () =>
      $(document).unbind "click", @hide
      @_container.removeClass('editing')
      @_holder.fadeOut("fast")

  $.fn.date_picker = () ->
    @each ->
      new DatePicker(@)
    @


  class TimePicker
    constructor: (element) ->
      @field = $(element)
      @holder = $('<div class="timepicker" />')
      @dropdown = new Dropdown @field,
        on_select: @select
        on_keyup: @change
      times = []
      for i in [0..24]
        times.push({value: "#{i}:00"})
        times.push({value: "#{i}:30"})
      @dropdown.populate(times)
      @field.focus @show
      @field.blur @hide

    select: (value) =>
      @field.val(value)
      @field.trigger('change')

    change: (e) =>
      # this is called on keyup but only if the dropdown doesn't recognise the keypress as a command
      @dropdown.match(@field.val())

    show: (e) =>
      @dropdown.show()

    hide: (e) =>
      @dropdown.hide()

  $.fn.time_picker = ->
    @each ->
      new TimePicker(@)






  $.fn.slug_field = ->
    @each ->
      new SlugField(@)

  class SlugField
    constructor: (element, opts) ->
      @options = $.extend
        min: 3
        match: /^\w+$/
      , opts
      @field = $(element)
      @notice = $('.availability')
      @form = @field.parents('form')
      @submit = @form.find('.submit')
      @field.keyup @check
      @request = null
      
    val: () =>
      @field.val()
      
    check: () =>
      @val = @field.val()
      if @valid()
        @notice.removeClass("invalid")
        @checkAvailability() 
      else
        @notice.addClass("invalid").text("Please enter three or more letters and digits")
        @submit.addClass('unavailable')
    
    valid: () =>
      @val.length >= @options.min and @options.match.test(@val)
    
    checkAvailability: () =>
      @wait()
      @request?.abort()
      @request = $.getJSON "/check/#{@val}.json", @showAvailability
    
    showAvailability: (available) =>
      @unwait()
      if available
        @notice.text("This address is available")
        @notice.addClass('available').removeClass('unavailable')
        @field.addClass('available').removeClass('unavailable')
        @submit.removeClass('unavailable')
      else
        @notice.text("This address is already in use")
        @notice.addClass('unavailable').removeClass('available')
        @field.addClass('unavailable').removeClass('available')
        @submit.addClass('unavailable')
    
    wait: () =>
      @notice.addClass('waiting')

    unwait: () =>
      @notice.removeClass('waiting')





  $.fn.password_form = ->
    @each ->
      new PasswordForm(@)

  class PasswordForm
    constructor: (element, opts) ->
      @options = $.extend
        length: 6
      , opts
      @form = $(element)
      @password_field = @form.find('input.password')
      @confirmation_field = @form.find('input.password_confirmation')
      @fields = @form.find('input')
      @confirmation_holder = @confirmation_field.parents("p")
      @submit = @form.find('.submit')
      @required = @password_field.attr('required')

      @fields.bind 'keyup', @checkForm
      @password_field.bind 'keyup', @checkPassword
      @fields.bind 'invalid', @invalidField
      @form.bind 'submit', @submitIfValid
      
      @fields.attr('data-strict', false)
      @unsubmittable()
      @confirmation_holder.hide()

    checkForm: () =>
      @fields.removeClass('invalid').addClass('valid')
      if @form.get(0).checkValidity() then @submittable() else @unsubmittable()
    
    invalidField: () ->
      # note thin arrow: `this` is the failing input element
      field = $(@)
      field.removeClass('valid')
      if !field.attr('data-strict') and !field.val() or field.val() is ""
        field.addClass('empty')
      else
        field.addClass("invalid")
      
    checkPassword: () =>
      if @password_field.val() == "" and !@required
        @confirmation_field.attr('pattern', '').attr('required', false)
        @confirmation_holder.hide()
      else
        @confirmation_field.attr('pattern', @password_field.val()).attr('required', true)
        if @password_field.get(0).checkValidity()
          @confirmation_holder.show()
        else
          @confirmation_holder.hide()
          
    submittable: () =>
      @submit.removeClass("unavailable")
      @blocked = false

    unsubmittable: () =>
      @submit.addClass("unavailable")
      @blocked = true

    submitIfValid: (e) =>
      @fields.attr('data-strict', true)
      @checkForm()
      if @blocked
        e.preventDefault()
      else
        # might as well debounce, since we're here
        @submit.val('please wait')
        @unsubmittable()




  ## Display Widgets
  #
  # These stand alone and usually encapsulate some interaction with the user.

  # The *folder* action is just a display convention that shows and hides the contents of a folder
  # when its link is clicked. It could perhaps become a subclass of the generic toggle mechanism and benefit from its persistence.
      
  $.fn.folder = ->
    @each ->
      new Folder(@)
      
  class Folder
    constructor: (element) ->
      @_container = $(element)
      @_list = @_container.children('ul.filing')
      if @_list[0]
        @_container.children('a.folder').click @toggle
        @set()
      
    set: (e) =>
      e.preventDefault() if e
      if @_container.hasClass('open') then @show() else @hide()

    toggle: (e) =>
      if e
        e.preventDefault() 
        e.stopPropagation()
      if @_container.hasClass('open') then @hide() else @show()

    show: (e) =>
      e.preventDefault() if e
      @_container.addClass('open')
      @_list.stop().slideDown("fast")
      
    hide: (e) =>
      e.preventDefault() if e
      @_list.stop().slideUp "normal", () =>
        @_container.removeClass('open')



  # The page turner is a pagination link that retrieves a page of results remotely
  # then slides it into view from either the right or left depending on its relation 
  # to the current page.

  $.fn.sliding_link = () ->
    @each ->
      new Slider(@)
  
  class Slider
    constructor: (element) ->
      @_link = $(element)
      @_selector = @_link.attr('data-affected') || @defaultSelector()
      @_direction = @getDirection()
      @_page = @getPage()
      
      # build viewport and sliding frame around the the content-holding @_page
      @_frame = @_page.parents('.scroller').first()
      unless @_frame.length
        @_page.wrap($('<div class="scroller" />'))
        @_frame = @_page.parent()

      @_viewport = @_frame.parents('.scrolled').first()
      unless @_viewport.length
        @_frame.wrap($('<div class="scrolled" />'))
        @_viewport = @_frame.parents('.scrolled')

      @_width = @_page.width()
      @_link.remote
        on_success: @receive
      
    getPage: =>
      @_link.parents(@_selector).first()
      
    getDirection: =>
      @_link.attr "data-direction"

    defaultSelector: () =>
      '.scrap'
      
    receive: (r) =>
      response = $(r)
      @sweep response
      response.activate()
      
    sweep: (r) =>
      @_old_page = @_page
      @_viewport.css("overflow", "hidden")
      if @_direction == 'right'
        @_frame.append(r)
        @_viewport.animate {scrollLeft: @_width}, 'slow', 'glide', @cleanup
      else
        @_frame.prepend(r)
        @_viewport.scrollLeft(@_width).animate {scrollLeft: 0}, 'slow', 'glide', @cleanup
          
    cleanup: () =>
      @_viewport.scrollLeft(0)
      @_old_page.remove()



  $.fn.page_turner = () ->
    @each ->
      new Pager(@)

  class Pager extends Slider
    constructor: (element) ->
      super
      @_page_number = parseInt(@_link.parent().siblings('.current').text())
    
    defaultSelector: () =>
      '.paginated'
      
    getDirection: =>
      if @_link.attr "rel"
        @_direction = if @_link.attr("rel") == "next" then "right" else "left"
      else
        @_direction = if parseInt(@_link.text()) > @_page_number then "right" else "left"

