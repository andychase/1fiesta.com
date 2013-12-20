###
  --TEST PART--
This part contains the unit tests
Remove before rolling out.
###

TestCase("TestsetUpDocument"
    , setUp: ->
        ###:DOC +=<div id="mapsection"></div>###
        setUpMapSection()
    , testVariables: ->
        assertInstanceOf google.maps.Map, map
        assertInstanceOf google.maps.Geocoder, geocoder
        assertEquals	 markersArray.length, numberOfMarkersToShowOnPage
        assertInstanceOf google.maps.InfoWindow, infoWindow
    , testReturnEvents: ->
)

TestCase("TestLocationAutocompleters"
    , setUp: ->
        ###:DOC +=<textarea id="q">97223</textarea><div id="results"></div>###
        google.maps.GeocoderStatus.ZERO_RESULTS = 1234
        geocoder.geocode = (vars, func) ->
            func([], google.maps.GeocoderStatus.ZERO_RESULTS)
    , testLocationAutocompleter: ->
        locationAutocompleter($("#q"), $("#results"))
        $("#q").trigger('keyup')
        assertEquals "(Nothing found)", $("#results").html()
)

TestCase("TestUpdateResults"
    , setUp: ->
        ###:DOC +=<div id="mapsection"></div><div id="eventlist"></div>###
        map.getBounds = () ->
            obj = new Object
            obj.toUrlValue = () ->
                return "45.398212%2C-122.758096"
            return obj
        $.getJSON = (url, options, func) ->
            func([])
    , testUpdateResultsBlank: ->
        updateResults()
        assertEquals "<i>Nothing here, try zooming out or removing filters.</i>", $("#eventlist").html()
    , testUpdateResultsFull: ->
        $.getJSON = (url, options, func) ->
            func([{"id":"23","0":"23","name":"cool & fun","1":"cool & fun","description":"","2":"","date":"1344927600","3":"1344927600","location":"SW Fern St","4":"SW Fern St","latitude":"45.427685","5":"45.427685","longitude":"-122.823677","6":"-122.823677","iconname":null,"7":null}])
        updateResults()
        assertEquals "<li> <b>cool &amp; fun".substr(0,15), $('#eventlist').html().replace(/\s+/g, ' ').substr(0, 15)
)

TestCase("TestUpdateMarker"
    , setUp: ->
        ###:DOC +=<div id="mapsection"></div> ###
        setUpMapSection()
    , testNewMarker: ->
        testLatLng = new google.maps.LatLng(45.427685, -122.823677)
        assertInstanceOf google.maps.Marker, markersArray[0]
        newEvent = Object
        newEvent.latitude  = testLatLng.lat()
        newEvent.longitude = testLatLng.lng()
        updateMarker(0, newEvent)
        assertInstanceOf google.maps.Marker, markersArray[0]
        assertEquals testLatLng.lat(), markersArray[0].getPosition().lat()
    , testClearMarker: ->
        testLatLng = new google.maps.LatLng(45.427685, -122.823677)
        markersArray[0].setPosition(testLatLng)
        assertTrue markersArray[0].getPosition()?
        clearMarkers()
        assertFalse markersArray[0].getPosition()?
)











