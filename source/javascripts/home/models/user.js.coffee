class Home.Models.User extends Backbone.Model
  urlRoot: '/api/users'

  defaults:
    email: ""
    first_name: ""
    last_name: ""
    password: ""
    password_confirmation: ""
    desired_slug: ""
    uid: ""
    authentication_token: ""
    confirmed: false

  initialize: ->
    @_competitor = new Home.Models.Competitor @get("competitor")

  toJSON: () =>
    json = 
      user: super

  hasCompetitor: =>
    !@_competitor?.isNew()
