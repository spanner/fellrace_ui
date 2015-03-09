class FellRace.Models.Link extends FellRace.Model
  singular_name: 'link'
  defaults:
    title: null
    url: null

  jsonForPublication: =>
    id: @id
    title: @get("title")
    url: @get("url")
