class FellRace.Views.AdminFutureInstance extends Backbone.Marionette.ItemView
  template: 'instances/admin_future'
  className: "instance future admin"
  tagName: "section"
  storage_date_format: "YYYY-MM-DD"
  display_date_format: "Do MMM YYYY"

  events:
    'click a.delete': "delete"
    "change input#entries_file": 'getPickedFile'
    'click a.export_autodownload': 'exportAutoDownload'
    'click a.export_multisport': 'exportMultiSport'
    'click a.export_all': 'exportAllData'

  bindings:
    ".race_name": "race_name"
    ".instance_name":
      observe: "name"
      onGet: "deSlugify"
    "span.race_date": 
      observe: "date"
      onSet: "dateForStorage"
      onGet: "dateForDisplay"
    "span.time": "time"
    "span.entry_limit": "entry_limit"

    "input#eod": "eod"
    ".eod_details":
      observe: "eod"
      visible: true
      visibleFn: "quickSlide"
    "span.eod_fee":
      observe: "eod_fee"
      onGet: "currency"

    "input#online_entry": "online_entry"
    ".online_details":
      observe: "online_entry"
      visible: true
      visibleFn: "quickSlide"
    "span.online_entry_opening":
      observe: "online_entry_opening"
      onSet: "dateForStorage"
      onGet: "dateForDisplay"
    "span.online_entry_closing":
      observe: "online_entry_closing"
      onSet: "dateForStorage"
      onGet: "dateForDisplay"
    "span.online_entry_fee":
      observe: "online_entry_fee"
      onGet: "currency"
    "span.admin_charge":
      observe: "online_entry_fee"
      onGet: "adminCharge"

    "input#postal_entry": "postal_entry"
    ".postal_details":
      observe: "postal_entry"
      visible: true
      visibleFn: "quickSlide"
    "span.postal_entry_opening":
      observe: "postal_entry_opening"
      onSet: "dateForStorage"
      onGet: "dateForDisplay"
    "span.postal_entry_closing":
      observe: "postal_entry_closing"
      onSet: "dateForStorage"
      onGet: "dateForDisplay"
    "span.postal_entry_fee":
      observe: "postal_entry_fee"
      onGet: "currency"

    "input.accept_cheque": "accept_cheque"
    "input.cheque_paid_to": "cheque_paid_to"
    "input.accept_cash": "accept_cash"

    ".total_count": "total_count"
    ".online_count": "online_count"
    ".postal_count": "postal_count"
    ".cancelled_count": "cancelled_count"

    "a.close":
      attributes: [
        observe: "race_slug"
        name: "href"
        onGet: "raceUrl"
      ]

  onRender: () =>
    @$el.find('.editable').editable()
    $.defer
    @stickit()
    
    @$el.find('span.date').each (i, el) =>
      picker = $(el)
      picker.attr('contenteditable', 'true')
      new Pikaday
        field: el
        format: @display_date_format
        onSelect: () ->
          picker.text this.getMoment().format(@_o.format)

    category_picker = new FellRace.Views.CategoryPicker
      model: @model
      el: @$el.find(".category_picker")
    category_picker.render()

    entry_form = new FellRace.Views.AdminPostalEntryForm
      model: @model
      el: @$el.find(".entry_form")
    entry_form.render()

    entries_import = new FellRace.Views.AdminEntriesImport
      model: @model
      el: @$el.find(".entries_import")
    entries_import.render()

    # if @model.entries?.length
    #   @renderEntries()
    # if @model.get('entry_data')?
    #   @renderEntryChart()
    # if @model.get('cat_data')?
    #   @renderCatCharts()
    @model.entries.on "reset add remove", @renderEntries
    @model.on "change:entry_data", @renderEntryChart
    @model.on "change:cat_data", @renderCatCharts

  renderEntryChart: (model, data) =>
    # if entries_ctx = @$el.find("canvas.entries_chart").get(0)?.getContext("2d")
    #   @_entries_chart = new Chart(entries_ctx).Doughnut(@model.get('entry_data'))
      @_entry_chart = new Chartist.Pie '.entries_chart.ct-chart', @model.get('entry_data'),
        donut: true
        donutWidth: 40
        startAngle: 0
        showLabel: true
        plugins: [
          Chartist.plugins.tooltip()
        ]

  renderCatCharts: (model, data) =>
    @_cat_chart = new Chartist.Bar '.categories_chart.ct-chart', @model.get('cat_data'),
      stackBars: true
      showGrid: false
      chartPadding:
        top: 15
        right: 15
        bottom: 5
        left: 10
      axisX:
        offset: 0
        labelInterpolationFnc: (value, index) -> null
      axisX:
        offset: 0
        labelInterpolationFnc: (value, index, series) -> null
      plugins: [
        Chartist.plugins.tooltip()
      ]

  renderEntries: () =>
    entries_table = new FellRace.Views.AdminEntriesTable
      collection: @model.entries
      el: @$el.find("table.entries")
    entries_table.render()

    cancelled_entries_table = new FellRace.Views.AdminCancelledEntriesTable
      collection: @model.cancelled_entries
      el: @$el.find("table.cancelled_entries")
    cancelled_entries_table.render()

  delete: (e) =>
    e.preventDefault() if e
    @model.destroy()

  adminCharge: (fee) ->
    fee ?= 0
    merchant_ratio = 0.024
    merchant_fixed = 0.2
    fr_ratio = 0.025
    fr_fixed = 0
    ratio = merchant_ratio + fr_ratio
    fixed = merchant_fixed + fr_fixed
    charge = 0
    if fee > fixed
      charge = (fee * ratio + fixed).toFixed(4)
    @currency (Math.ceil(charge * 100) / 100)

  raceUrl: (slug) ->
    "/admin/races/#{slug}"

  currency: (amount) ->
    amount?.toFixed(2)

  quickSlide: ($el, isVisible, options) =>
    if (isVisible) then $el.slideDown('fast') else $el.slideUp('fast')

  # dates are displayed in a nicer format than they are stored.

  dateForDisplay: (string) =>
    if string and string isnt ""
      new moment(string, @storage_date_format).format(@display_date_format)
    else
      ""

  dateForStorage: (string) =>
    new moment(string, @display_date_format).toDate()

  deSlugify: (string) ->
    string.split("-").map((w) -> _.str.capitalize(w)).join(" ") if string

  onClose: =>
    $(".pika-single").remove()

  exportAutoDownload: =>
    csv = Papa.unparse @model.entries.map (e) ->
      {
        RaceNumber: ""
        CardNumbers: ""
        MembershipNumbers: ""
        Name: "#{e.name()}"
        AgeClass: "#{e.get("category")}"
        Club: "#{e.get("club_name")}"
        Country: ""
        CourseClass: ""
        StartTime: ""
        StartTimePreference: ""
        EnvelopeNumber: ""
        NonCompetitive: ""
        Seeded: ""
        NotUsed1: ""
        Handicap: ""
        RegistrationNotes: ""
        SiEntriesIDs: ""
        Eligibility: ""
      }
    link = document.createElement("a")
    link.setAttribute("href", encodeURI("data:text/csv;charset=utf-8,#{csv}"))
    link.setAttribute("download", "#{@model.get("race_slug")}-#{@model.get("name")}-entries-autodownload.csv")
    link.click()

  exportMultiSport: =>
    csv = Papa.unparse
      fields: ["Stno","Chip no","Database Id","Surname","First name","YB","S","Block","nc","Start","Finish","Time","Classifier","Club no.","Cl.name","City","Nat","Cl. no.","Short","Long","Num1","Num2","Num3","Text1","Text2","Text3","Adr. name","Street","Line2","Zip","City","Phone","Fax","EMail","Id/Club","Rented","Start fee","Paid"]
      data: @model.entries.map (e) => ["","","",e.get("surname"),e.get("forename"),"",e.get("gender"),"",0,"#{@model.get("time")}:00","","",0,"",e.get("club_name"),"","","",e.get("category"),e.get("category"),"","","","","","",e.get("postal_address_line_1"),"",e.get("postal_address_line_2"),e.get("postcode"),e.get("postal_town"),e.get("mobile") || e.get("phone"),"",e.get("email"),"","",e.get("cost"),"X"]
    link = document.createElement("a")
    link.setAttribute("href", encodeURI("data:text/csv;charset=utf-8,#{csv}"))
    link.setAttribute("download", "#{@model.get("race_slug")}-#{@model.get("name")}-entries-multisport.csv")
    link.click()

  exportAllData: =>
    csv = Papa.unparse @model.entries.map (e) ->
      {
        forename: e.get("forename")
        middlename: e.get("middlename")
        surname: e.get("surname")
        club: e.get("club_name")
        cat: e.get("category")
        gender: e.get("gender")
        dob: e.get("dob")
        emergency_contact: e.get("emergency_contact_name")
        emergency_contact_phone: e.get("emergency_contact_phone")
        address_line_1: e.get("postal_address_line_1")
        address_line_2: e.get("postal_address_line_2")
        town: e.get("postal_town")
        county: e.get("postal_county")
        postcode: e.get("postcode")
        country: e.get("postal_country")
        phone: e.get("phone")
        mobile: e.get("mobile")
        email: e.get("email")
      }
    link = document.createElement("a")
    link.setAttribute("href", encodeURI("data:text/csv;charset=utf-8,#{csv}"))
    link.setAttribute("download", "#{@model.get("race_slug")}-#{@model.get("name")}-entries-all.csv")
    link.click()

