class Home.Router extends Backbone.Marionette.AppRouter
  controller: Home.Controller
  onRoute: "navigate"
  appRoutes:
    "": "index"
    "events/:slug(/)": "public"
    "events/:slug/admin(/)": "admin"
    "events/:slug/preview(/)": "preview"
    "sign_in(/)": "sign_in"
    "sign_out(/)": "sign_out"
    "reconfirm(/)": "reconfirm"
    "confirm/:id/:token(/)": "confirm"
    "request_reset(/)": "request_reset"
    "reset_password/:id/:token(/)": "reset_password"
    "runners(/)": "competitors"
    "runner/:id(/)": "competitor"
    "clubs(/)": "clubs"
    "club/:id(/)": "club"
    "me(/)": "me"

  navigate: (name, path, args) =>
    console.log "navigate", name, path, args