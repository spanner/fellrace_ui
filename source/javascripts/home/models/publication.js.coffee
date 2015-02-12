class Home.Models.Publication extends Backbone.Model
  getCenter: =>
    new google.maps.LatLng @get("map_lat"), @get("map_lng")
