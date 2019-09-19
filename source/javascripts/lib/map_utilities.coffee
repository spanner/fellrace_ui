jQuery ($) ->
  google.maps.LatLng.prototype.canvasOffset = (map) ->
    nw = new google.maps.LatLng map.getBounds().getNorthEast().lat(), map.getBounds().getSouthWest().lng()
    coordinateNW = map.getProjection().fromLatLngToPoint(nw)
    coordinate = map.getProjection().fromLatLngToPoint(@)
    scale = Math.pow(2, map.getZoom())
    new google.maps.Point Math.floor((coordinate.x - coordinateNW.x) * scale),
      Math.floor((coordinate.y - coordinateNW.y) * scale)

  google.maps.LatLng.prototype.kmTo = (a) ->
    e = Math
    ra = e.PI/ 180
    b = @lat() * ra
    c = a.lat() * ra
    d = b - c
    g = @lng() * ra - a.lng() * ra
    f = 2 * e.asin(e.sqrt(e.pow(e.sin(d/ 2), 2) + e.cos(b) * e.cos(c) * e.pow(e.sin(g/ 2), 2)))
    f * 6378.137

  google.maps.Polyline.prototype.inKm = ->
    path = @getPath()
    len = path.getLength()
    dist = 0
    for a, i in path.getArray()
      unless i is len - 1
        dist += a.kmTo(path.getAt(i+1))
    dist

  google.maps.Polyline.prototype.inMiles = ->
    @inKm() * 0.621371192
  
