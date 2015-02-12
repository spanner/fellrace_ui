// Code (c) Bill Chadwick 2010, 2011 please dont use it without permission
// until I have selelected a suitable license. 
// contact : bill.chadwick2@gmail.com


//As ever we have to jump through special hoops fro the worlds trickiest browser
function getInternetExplorerVersion()
// Returns the version of Internet Explorer or a -1
// (indicating the use of another browser).
{
    var rv = -1; // Return value assumes failure.
    if (navigator.appName == 'Microsoft Internet Explorer') {
        var ua = navigator.userAgent;
        var re = new RegExp("MSIE ([0-9]{1,}[\.0-9]{0,})");
        if (re.exec(ua) != null)
            rv = parseFloat(RegExp.$1);
    }
    return rv;
}





// Constructor. Pass your OpenSpace Key and your OpenSpace URL 
// and the Google map object that the OS map type is to be used with.
// this code depends on GridProjection.js
function WarpedOsOpenSpaceMapType(osKey, osUrl, map) {
    this._openSpaceKey = osKey;
    this._openSpaceUrl = osUrl;
    this._opacity = 1.0;
    this._map = map;
    this._osProjection = new GridProjection();
    this._osProjection.initialize();
    this._backColor = '';
    this._tiles = new Array(); //collection of tiles on map for opacity control, pruned by releaseTile
    this._ieTileOffset = '0px';
    if (getInternetExplorerVersion() >= 8.0) {
        this._ieTileOffset = '0px';
    }
        
}

WarpedOsOpenSpaceMapType.prototype.copyright = "&copy; Crown copyright and database rights 2010 Ordnance Survey <a href=\"http://openspace.ordnancesurvey.co.uk/openspace/developeragreement.html#enduserlicense\" target=\"_blank\"> EULA</a>";
WarpedOsOpenSpaceMapType.prototype.tileSize = new google.maps.Size(256, 256);
WarpedOsOpenSpaceMapType.prototype.maxZoom = 18; // limit consistent with most detailed OpenSpace mapping
WarpedOsOpenSpaceMapType.prototype.minZoom = 6; // limit to UK area
WarpedOsOpenSpaceMapType.prototype.name = "OS OpenSpace";
WarpedOsOpenSpaceMapType.prototype.alt = "OS OpenSpace";
WarpedOsOpenSpaceMapType.prototype.idPrefix = 'WarpedOsOpenSpaceMapType';

// OS OpenSpace zoom levels from Google zoom level
WarpedOsOpenSpaceMapType.prototype.oZoomFromGzoom =
        [
            0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 4, 5, 6, 7, 8, 8, 9, 10, 10, 10, 10, 10, 10
        ];

//index these by OS zoom to get metres per pixel
WarpedOsOpenSpaceMapType.prototype.osResolutions =
        [
            2500.0, // overview1, 
            1000.0, // overview2, 
            500.0, // overview3, 
            200.0, // mini scale, 
            100.0, // mini scale, 
            50.0, // road book, 
            25.0, // road book, 
            10.0, // 50K, 
            5.0, // 50K, 
            2.0, // streetview
            1.0 //streetview
        ];

//index these by OS zoom to get OS tile size
WarpedOsOpenSpaceMapType.prototype.osTileSizes =
        [
            200, // overview1, 
            200, // overview2, 
            200, // overview3, 
            200, // mini scale, 
            200, // mini scale, 
            200, // road book, 
            200, // road book, 
            200, // 50K, 
            200, // 50K, 
            250, // streetview
            250  // streetview
        ];

//index these by OS zoom to get OS tile back colors where appropriate
WarpedOsOpenSpaceMapType.prototype.osBackColors =
        [
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "white",
            "white",
            "#ffffee",
            "#ffffee"            
        ];


//index these by OS zoom to get OS tile URL - replace Key, Url and BBOX coords
WarpedOsOpenSpaceMapType.prototype.osUrls =
        [
   "http://openspace.ordnancesurvey.co.uk/osmapapi/ts?FORMAT=image%2Fpng&KEY=YourOsKey&URL=YourOsUrl&SERVICE=WMS&VERSION=1.1.1&REQUEST=GetMap&STYLES=&EXCEPTIONS=application%2Fvnd.ogc.se_inimage&LAYERS=2500&SRS=EPSG%3A27700&BBOX=bbxl,bbxb,bbxr,bbxt&WIDTH=200&HEIGHT=200",
   "http://openspace.ordnancesurvey.co.uk/osmapapi/ts?FORMAT=image%2Fpng&KEY=YourOsKey&URL=YourOsUrl&SERVICE=WMS&VERSION=1.1.1&REQUEST=GetMap&STYLES=&EXCEPTIONS=application%2Fvnd.ogc.se_inimage&LAYERS=1000&SRS=EPSG%3A27700&BBOX=bbxl,bbxb,bbxr,bbxt&WIDTH=200&HEIGHT=200",
   "http://openspace.ordnancesurvey.co.uk/osmapapi/ts?FORMAT=image%2Fpng&KEY=YourOsKey&URL=YourOsUrl&SERVICE=WMS&VERSION=1.1.1&REQUEST=GetMap&STYLES=&EXCEPTIONS=application%2Fvnd.ogc.se_inimage&LAYERS=500&SRS=EPSG%3A27700&BBOX=bbxl,bbxb,bbxr,bbxt&WIDTH=200&HEIGHT=200",
   "http://openspace.ordnancesurvey.co.uk/osmapapi/ts?FORMAT=image%2Fpng&KEY=YourOsKey&URL=YourOsUrl&SERVICE=WMS&VERSION=1.1.1&REQUEST=GetMap&STYLES=&EXCEPTIONS=application%2Fvnd.ogc.se_inimage&LAYERS=200&SRS=EPSG%3A27700&BBOX=bbxl,bbxb,bbxr,bbxt&WIDTH=200&HEIGHT=200",
   "http://openspace.ordnancesurvey.co.uk/osmapapi/ts?FORMAT=image%2Fpng&KEY=YourOsKey&URL=YourOsUrl&SERVICE=WMS&VERSION=1.1.1&REQUEST=GetMap&STYLES=&EXCEPTIONS=application%2Fvnd.ogc.se_inimage&LAYERS=100&SRS=EPSG%3A27700&BBOX=bbxl,bbxb,bbxr,bbxt&WIDTH=200&HEIGHT=200",
   "http://openspace.ordnancesurvey.co.uk/osmapapi/ts?FORMAT=image%2Fpng&KEY=YourOsKey&URL=YourOsUrl&SERVICE=WMS&VERSION=1.1.1&REQUEST=GetMap&STYLES=&EXCEPTIONS=application%2Fvnd.ogc.se_inimage&LAYERS=50&SRS=EPSG%3A27700&BBOX=bbxl,bbxb,bbxr,bbxt&WIDTH=200&HEIGHT=200",
   "http://openspace.ordnancesurvey.co.uk/osmapapi/ts?FORMAT=image%2Fpng&KEY=YourOsKey&URL=YourOsUrl&SERVICE=WMS&VERSION=1.1.1&REQUEST=GetMap&STYLES=&EXCEPTIONS=application%2Fvnd.ogc.se_inimage&LAYERS=25&SRS=EPSG%3A27700&BBOX=bbxl,bbxb,bbxr,bbxt&WIDTH=200&HEIGHT=200",
   "http://openspace.ordnancesurvey.co.uk/osmapapi/ts?FORMAT=image%2Fpng&KEY=YourOsKey&URL=YourOsUrl&SERVICE=WMS&VERSION=1.1.1&REQUEST=GetMap&STYLES=&EXCEPTIONS=application%2Fvnd.ogc.se_inimage&LAYERS=10&SRS=EPSG%3A27700&BBOX=bbxl,bbxb,bbxr,bbxt&WIDTH=200&HEIGHT=200",
   "http://openspace.ordnancesurvey.co.uk/osmapapi/ts?FORMAT=image%2Fpng&KEY=YourOsKey&URL=YourOsUrl&SERVICE=WMS&VERSION=1.1.1&REQUEST=GetMap&STYLES=&EXCEPTIONS=application%2Fvnd.ogc.se_inimage&LAYERS=5&SRS=EPSG%3A27700&BBOX=bbxl,bbxb,bbxr,bbxt&WIDTH=200&HEIGHT=200",
   "http://openspace.ordnancesurvey.co.uk/osmapapi/ts?FORMAT=image%2Fpng&KEY=YourOsKey&URL=YourOsUrl&SERVICE=WMS&VERSION=1.1.1&REQUEST=GetMap&STYLES=&EXCEPTIONS=application%2Fvnd.ogc.se_inimage&LAYERS=2&SRS=EPSG%3A27700&BBOX=bbxl,bbxb,bbxr,bbxt&WIDTH=250&HEIGHT=250",
   "http://openspace.ordnancesurvey.co.uk/osmapapi/ts?FORMAT=image%2Fpng&KEY=YourOsKey&URL=YourOsUrl&SERVICE=WMS&VERSION=1.1.1&REQUEST=GetMap&STYLES=&EXCEPTIONS=application%2Fvnd.ogc.se_inimage&LAYERS=1&SRS=EPSG%3A27700&BBOX=bbxl,bbxb,bbxr,bbxt&WIDTH=250&HEIGHT=250"
    ];

WarpedOsOpenSpaceMapType.prototype.getOpacity = function() { return this._opacity; };




if (navigator.userAgent.indexOf("MSIE") == -1) {

    //standards based browser supporting svg

    WarpedOsOpenSpaceMapType.prototype.setOpacity = function(op) {
        this._opacity = op;
        for (var i = 0; i < this._tiles.length; i++) {
            this._tiles[i].setAttribute("opacity", this._opacity);            
        }
    };

    WarpedOsOpenSpaceMapType.prototype.getTile = function(coord, zoom, ownerDocument) {

        if ((zoom < this.minZoom) || (zoom > this.maxZoom)) {
            var d = document.createElement("div");
            d.innerHTML = "No OS Data";
            d.style.color = "yellow";
            return d;
        }

        var s = 1 << zoom; //google scale for zoom

        var svgNS = "http://www.w3.org/2000/svg";
        var svgXlink = 'http://www.w3.org/1999/xlink';

        var svgRoot = ownerDocument.createElementNS(svgNS, "svg");
        svgRoot.setAttribute("width", this.tileSize.width + 'px');
        svgRoot.setAttribute("height", this.tileSize.height + 'px');
        svgRoot.setAttribute("style", "position:relative; top:" + 0 + "px; left:" + 0 + "px");
        svgRoot.setAttribute("image-rendering", "optimiseSpeed"); //optimizeQuality
        var svgNode = ownerDocument.createElementNS(svgNS, "g");

        //lat/lng bounds of google tile
        var gTl = this._map.getProjection().fromPointToLatLng(new google.maps.Point(coord.x * this.tileSize.width / s, coord.y * this.tileSize.height / s));
        var gTr = this._map.getProjection().fromPointToLatLng(new google.maps.Point((coord.x + 1) * this.tileSize.width / s, coord.y * this.tileSize.height / s));
        var gBl = this._map.getProjection().fromPointToLatLng(new google.maps.Point(coord.x * this.tileSize.width / s, (coord.y + 1) * this.tileSize.height / s));
        var gBr = this._map.getProjection().fromPointToLatLng(new google.maps.Point((coord.x + 1) * this.tileSize.width / s, (coord.y + 1) * this.tileSize.height / s));

        //convert to OS and get containing bounds
        var oTl = this._osProjection.getOgbPointFromLonLat(gTl);
        var oTr = this._osProjection.getOgbPointFromLonLat(gTr);
        var oBl = this._osProjection.getOgbPointFromLonLat(gBl);
        var oBr = this._osProjection.getOgbPointFromLonLat(gBr);

        var osLeft = oTl.east;
        var osRight = oBr.east;
        if (oBl.east < osLeft)
            osLeft = oBl.east;
        if (oTr.east > osRight)
            osRight = oTr.east;

        var osTop = oTl.north;
        var osBottom = oBr.north;
        if (oTr.north > osTop)
            osTop = oTr.north;
        if (oBl.north < osBottom)
            osBottom = oBl.north;

        var oz = this.oZoomFromGzoom[zoom];
        var res = this.osResolutions[oz];
        var ts = this.osTileSizes[oz];
        var tileMeters = res * ts;

        //iterate OS tiles, enough to cover the google tile

        var west = Math.floor(osLeft / tileMeters);
        var east = Math.ceil(osRight / tileMeters);
        var north = Math.ceil(osTop / tileMeters);
        var south = Math.floor(osBottom / tileMeters);

        var x = 0;
        for (var e = west; e < east; e++) {
            var y = 0;
            for (n = north; n > south; n--) {

                //work out the os URL     
                var uC = this.osUrls[oz];
                uC = uC.replace("YourOsKey", this._openSpaceKey);
                uC = uC.replace("YourOsUrl", this._openSpaceUrl);
                uC = uC.replace("bbxl", (e * tileMeters).toFixed(0));
                uC = uC.replace("bbxr", ((e + 1) * tileMeters).toFixed(0));
                uC = uC.replace("bbxb", ((n - 1) * tileMeters).toFixed(0));
                uC = uC.replace("bbxt", (n * tileMeters).toFixed(0));

                var svgImg = ownerDocument.createElementNS(svgNS, "image");
                svgImg.setAttributeNS(svgXlink, "xlink:href", uC);
                svgImg.setAttribute("x", (x * ts) + 'px');
                svgImg.setAttribute("y", (y * ts) + 'px');
                svgImg.setAttribute("width", ts + 'px');
                svgImg.setAttribute("height", ts + 'px');
                svgImg.setAttribute("opacity", this._opacity);
                svgImg.setAttribute("style", 'border:0px;');
                this._tiles.push(svgImg); //save for opacity control


                svgNode.appendChild(svgImg);

                y++;
            }
            x++;
        }

        //now compute the affine transformation matrix for the grid of OS tiles to the Google tile
        var gcps =
            [
             { source: { x: (oTl.east - (west * tileMeters)) / res, y: ((north * tileMeters) - oTl.north) / res }, dest: { x: 0, y: 0} },
             { source: { x: (oTr.east - (west * tileMeters)) / res, y: ((north * tileMeters) - oTr.north) / res }, dest: { x: this.tileSize.width, y: 0} },
             { source: { x: (oBl.east - (west * tileMeters)) / res, y: ((north * tileMeters) - oBl.north) / res }, dest: { x: 0, y: this.tileSize.height} },
             { source: { x: (oBr.east - (west * tileMeters)) / res, y: ((north * tileMeters) - oBr.north) / res }, dest: { x: this.tileSize.width, y: this.tileSize.height} }
            ];

        var mtx = affineFromGcps(gcps);
        svgNode.setAttribute("transform", 'matrix(' + mtx[1] + "," + mtx[4] + "," + mtx[2] + "," + mtx[5] + "," + mtx[0] + "," + mtx[3] + ')');
        svgRoot.appendChild(svgNode);

        return svgRoot;
    };

    WarpedOsOpenSpaceMapType.prototype.releaseTile = function(node) {

        for (var c = 0; c < node.childNodes.length; c++) {
            var cn = node.childNodes[c];
            for (var cc = 0; cc < cn.childNodes.length; cc++) {
                var tile = cn.childNodes[cc];
                for (var i = 0; i < this._tiles.length; i++) {
                    if (this._tiles[i] == tile) {
                        this._tiles.splice(i, 1);
                        break;
                    }
                }
            }
        }
    }
    
}
else {

    //non standards based browser - MSIE

    WarpedOsOpenSpaceMapType.prototype.setOpacity = function(op) {
        this._opacity = op;
        var ops = parseInt(this._opacity * 100, 10).toString();
        for (var i = 0; i < this._tiles.length; i++) {
            this._tiles[i].filters.item("DXImageTransform.Microsoft.Alpha").opacity = ops;
            if (this._backColor == "") {
                this._tiles[i].filters.item("DXImageTransform.Microsoft.Chroma").enabled = false;
            }
            else {
                this._tiles[i].filters.item("DXImageTransform.Microsoft.Chroma").color = this._backColor;
                this._tiles[i].filters.item("DXImageTransform.Microsoft.Chroma").enabled = true;
            }
        }
    };

    WarpedOsOpenSpaceMapType.prototype.getTile = function(coord, zoom, ownerDocument) {

        if ((zoom < this.minZoom) || (zoom > this.maxZoom)) {
            var d = document.createElement("div");
            d.innerHTML = "No OS Data";
            d.style.color = "yellow";
            return d;
        }

        var s = 1 << zoom; //google scale for zoom

        var tileRoot = ownerDocument.createElement("div");
        tileRoot.style.left = '0px';
        tileRoot.style.top = '0px';
        tileRoot.style.position = 'absolute';
        tileRoot.style.width = this.tileSize.width + 'px';
        tileRoot.style.height = this.tileSize.height + 'px';
        tileRoot.style.overflow = 'hidden';
        tileRoot.style.borderWidth = '0px';
        tileRoot.style.borderStyle = 'solid';
        //tileRoot.style.borderWidth = '1px';
        //tileRoot.style.borderColor = '#0000AA';

        var tc = ownerDocument.createElement("div");
        tc.style.left = this._ieTileOffset; //buggy IE8 can render outside its container if we use 0,0, IE7 seems better
        tc.style.top = this._ieTileOffset;
        tc.style.position = 'relative';
        tc.style.overflow = 'hidden';
        tc.style.borderStyle = 'solid';
        tc.style.borderWidth = '0px';

        tileRoot.appendChild(tc);

        //lat/lng bounds of google tile
        var gTl = this._map.getProjection().fromPointToLatLng(new google.maps.Point(coord.x * this.tileSize.width / s, coord.y * this.tileSize.height / s));
        var gTr = this._map.getProjection().fromPointToLatLng(new google.maps.Point((coord.x + 1) * this.tileSize.width / s, coord.y * this.tileSize.height / s));
        var gBl = this._map.getProjection().fromPointToLatLng(new google.maps.Point(coord.x * this.tileSize.width / s, (coord.y + 1) * this.tileSize.height / s));
        var gBr = this._map.getProjection().fromPointToLatLng(new google.maps.Point((coord.x + 1) * this.tileSize.width / s, (coord.y + 1) * this.tileSize.height / s));

        //convert to OS and get containing bounds
        var oTl = this._osProjection.getOgbPointFromLonLat(gTl);
        var oTr = this._osProjection.getOgbPointFromLonLat(gTr);
        var oBl = this._osProjection.getOgbPointFromLonLat(gBl);
        var oBr = this._osProjection.getOgbPointFromLonLat(gBr);

        var osLeft = oTl.east;
        var osRight = oBr.east;
        if (oBl.east < osLeft)
            osLeft = oBl.east;
        if (oTr.east > osRight)
            osRight = oTr.east;

        var osTop = oTl.north;
        var osBottom = oBr.north;
        if (oTr.north > osTop)
            osTop = oTr.north;
        if (oBl.north < osBottom)
            osBottom = oBl.north;

        var oz = this.oZoomFromGzoom[zoom];
        var res = this.osResolutions[oz];
        var ts = this.osTileSizes[oz];
        var tileMeters = res * ts;

        this._backColor = this.osBackColors[oz];

        //iterate OS tiles, enough to cover the google tile

        var west = Math.floor(osLeft / tileMeters);
        var east = Math.ceil(osRight / tileMeters);
        var north = Math.ceil(osTop / tileMeters);
        var south = Math.floor(osBottom / tileMeters);

        var x = 0;
        var y;
        for (var e = west; e < east; e++) {
            y = 0;
            for (n = north; n > south; n--) {

                //work out the os URL     
                var uC = this.osUrls[oz];
                uC = uC.replace("YourOsKey", this._openSpaceKey);
                uC = uC.replace("YourOsUrl", this._openSpaceUrl);
                uC = uC.replace("bbxl", (e * tileMeters).toFixed(0));
                uC = uC.replace("bbxr", ((e + 1) * tileMeters).toFixed(0));
                uC = uC.replace("bbxb", ((n - 1) * tileMeters).toFixed(0));
                uC = uC.replace("bbxt", (n * tileMeters).toFixed(0));

                //os source image
                var image = ownerDocument.createElement("img");
                image.src = uC;
                image.style.left = (x * ts) + 'px';
                image.style.top = (y * ts) + 'px';
                image.style.width = ts + 'px';
                image.style.height = ts + 'px';
                image.style.position = 'absolute';
                image.style.overflow = 'hidden';
                image.style.borderWidth = '0px';
                image.style.borderStyle = 'solid';
                
                //image.style.borderStyle = 'solid';
                //image.style.borderWidth = '1px';
                //image.style.borderColor = '#AA0000';
                this._tiles.push(image);

                var ops = parseInt(this._opacity * 100, 10).toString();
                image.style.filter = "progid:DXImageTransform.Microsoft.Chroma(enabled=" + (this._backColor != "") + ", color=" + this._backColor + ") progid:DXImageTransform.Microsoft.Alpha(opacity=" + ops + ")";

                tc.appendChild(image);

                y++;
            }
            x++;
        }

        //for the matrix transform filter to work, the container has to be oversized
        tc.style.width = (x * this.tileSize.width) + 'px';
        tc.style.height = (y * this.tileSize.width) + 'px';
        
         //now compute the affine transformation matrix for the grid of OS tiles to the Google tile
         var gcps =
            [
             { source: { x: ((oTl.east - (west * tileMeters)) / res), y: ((north * tileMeters) - oTl.north) / res }, dest: { x: 0, y: 0} },
             { source: { x: ((oTr.east - (west * tileMeters)) / res), y: ((north * tileMeters) - oTr.north) / res }, dest: { x: this.tileSize.width, y: 0} },
             { source: { x: ((oBl.east - (west * tileMeters)) / res), y: ((north * tileMeters) - oBl.north) / res }, dest: { x: 0, y: this.tileSize.height} },
             { source: { x: ((oBr.east - (west * tileMeters)) / res), y: ((north * tileMeters) - oBr.north) / res }, dest: { x: this.tileSize.width, y: this.tileSize.height} }
            ];

        var mtx = affineFromGcps(gcps);

        tc.style.filter = "progid:DXImageTransform.Microsoft.Matrix(M11=" + mtx[1] +
                    ", M12=" + mtx[2] + ", M21=" + mtx[4] + ", M22=" + mtx[5] +
                    ", Dx=" + mtx[0] + ", Dy=" + mtx[3] + ", sizingmethod='clip to original', filtertype='bilinear')";

        return tileRoot;
    };

    WarpedOsOpenSpaceMapType.prototype.releaseTile = function(node) {
        for (var c = 0; c < node.childNodes.length; c++) {
            var cn = node.childNodes[c];
            for (var cc = 0; cc < cn.childNodes.length; cc++) {
                var tile = cn.childNodes[cc];
                for (var i = 0; i < this._tiles.length; i++) {
                    if (this._tiles[i] == tile) {
                        this._tiles.splice(i, 1);
                        break;
                    }
                }
            }
        }
    }

}

/// <summary>
/// Construct the least squares best fit affine transformation matrix from a set of ground control points
/// From Mapping Hacks #33
/// </summary>
/// <param name="gcps">Three or more ground control points having .source.x , .source.y and .dest.x and .dest.y</param>
/// <returns>Affine transformation matrix elements</returns>
//[0] is x offset
//[1] is x scale
//[2] is x rotation
//[3] is y offset
//[4] is y rotation
//[5] is y scale

function affineFromGcps(gcps) {

    var sum_x = 0.0, sum_y = 0.0, sum_xy = 0.0, sum_xx = 0.0, sum_yy = 0.0;
    var sum_Lon = 0.0, sum_Lonx = 0.0, sum_Lony = 0.0;
    var sum_Lat = 0.0, sum_Latx = 0.0, sum_Laty = 0.0;
    var divisor = 0.0;

    var affine = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0];

    if (gcps.length < 3)
        return null;

    for (var i = 0; i < gcps.length; ++i) {
        sum_x += gcps[i].source.x;
        sum_y += gcps[i].source.y;
        sum_xy += gcps[i].source.x * gcps[i].source.y;
        sum_xx += gcps[i].source.x * gcps[i].source.x;
        sum_yy += gcps[i].source.y * gcps[i].source.y;
        sum_Lon += gcps[i].dest.x;
        sum_Lonx += gcps[i].dest.x * gcps[i].source.x;
        sum_Lony += gcps[i].dest.x * gcps[i].source.y;
        sum_Lat += gcps[i].dest.y;
        sum_Latx += gcps[i].dest.y * gcps[i].source.x;
        sum_Laty += gcps[i].dest.y * gcps[i].source.y;
    }

    divisor = gcps.length * (sum_xx * sum_yy - sum_xy * sum_xy)
            + 2 * sum_x * sum_y * sum_xy - sum_y * sum_y * sum_xx
            - sum_x * sum_x * sum_yy;

    /* -------------------------------------------------------------------- */
    /*      If the divisor is zero, there is no valid solution.             */
    /* -------------------------------------------------------------------- */
    if (divisor == 0.0)
        return null;

    /* -------------------------------------------------------------------- */
    /*      Compute top/left origin.                                        */
    /* -------------------------------------------------------------------- */

    affine[0] = (sum_Lon * (sum_xx * sum_yy - sum_xy * sum_xy)
                               + sum_Lonx * (sum_y * sum_xy - sum_x * sum_yy)
                               + sum_Lony * (sum_x * sum_xy - sum_y * sum_xx))
            / divisor;

    affine[3] = (sum_Lat * (sum_xx * sum_yy - sum_xy * sum_xy)
                               + sum_Latx * (sum_y * sum_xy - sum_x * sum_yy)
                               + sum_Laty * (sum_x * sum_xy - sum_y * sum_xx))
            / divisor;

    /* -------------------------------------------------------------------- */
    /*      Compute X related coefficients.                                 */
    /* -------------------------------------------------------------------- */
    affine[1] = (sum_Lon * (sum_y * sum_xy - sum_x * sum_yy)
                               + sum_Lonx * (gcps.length * sum_yy - sum_y * sum_y)
                               + sum_Lony * (sum_x * sum_y - sum_xy * gcps.length))
            / divisor;

    affine[2] = (sum_Lon * (sum_x * sum_xy - sum_y * sum_xx)
                               + sum_Lonx * (sum_x * sum_y - gcps.length * sum_xy)
                               + sum_Lony * (gcps.length * sum_xx - sum_x * sum_x))
            / divisor;

    /* -------------------------------------------------------------------- */
    /*      Compute Y related coefficients.                                 */
    /* -------------------------------------------------------------------- */
    affine[4] = (sum_Lat * (sum_y * sum_xy - sum_x * sum_yy)
                               + sum_Latx * (gcps.length * sum_yy - sum_y * sum_y)
                               + sum_Laty * (sum_x * sum_y - sum_xy * gcps.length))
            / divisor;

    affine[5] = (sum_Lat * (sum_x * sum_xy - sum_y * sum_xx)
                               + sum_Latx * (sum_x * sum_y - gcps.length * sum_xy)
                               + sum_Laty * (gcps.length * sum_xx - sum_x * sum_x))
            / divisor;


    affine[0] += 0.5 * affine[1] + 0.5 * affine[2];
    affine[3] += 0.5 * affine[4] + 0.5 * affine[5];

    return affine;

}    