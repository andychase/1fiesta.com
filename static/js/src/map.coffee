BWtype = (map) ->

	# Create an array of styles.
	styles = [
		stylers: [saturation: -100]
	,
		featureType: "road"
		elementType: "labels"
		stylers: [visibility: "simplified"]
	,
		featureType: "administrative"
		elementType: "labels.text.fill"
		stylers: [
			visibility: "on"
		,
			gamma: 0.01
		]
	,
		featureType: "administrative"
		elementType: "labels.text.stroke"
		stylers: [
			weight: 3.1
		,
			color: "#ff7900"
		,
			lightness: 63
		]
	,
		featureType: "transit"
		stylers: [visibility: "off"]
	,
		featureType: "poi"
		stylers: [visibility: "off"]
	,
		featureType: "poi.park"
		stylers: [visibility: "on"]
	]

	# Create a new StyledMapType object, passing it the array of styles,
	# as well as the name to be displayed on the map type control.
	styledMap = new google.maps.StyledMapType(styles,
		name: "Styled Map"
	)

	#Associate the styled map with the MapTypeId and set it to display.
	map.mapTypes.set "map_style", styledMap
	map.setMapTypeId "map_style"


setUpMapSection = () ->
	myOptions = {
	zoom: 15,
	disableDefaultUI: true,
	mapTypeId: google.maps.MapTypeId.ROADMAP,
	mapTypeControl: false,
	mapTypeControlOptions:
		{
		mapTypeIds: [ google.maps.MapTypeId.ROADMAP, "Internet" ]
		position: google.maps.ControlPosition.RIGHT_TOP
		}
	scaleControl: false,
	panControl: true,
	panControlOptions:
		{
		style: google.maps.NavigationControlStyle.DEFAULT
		position: google.maps.ControlPosition.RIGHT_CENTER
		}
	zoomControl: true,
	zoomControlOptions:
		{
		style: google.maps.NavigationControlStyle.DEFAULT
		position: google.maps.ControlPosition.RIGHT_CENTER
		}
	}

	map = new google.maps.Map(document.getElementById("mapsection"), myOptions)

	### Initialize internet (TODO: Special) maps ###
	###internetMapType = new google.maps.ImageMapType(internetMapOptions)###
	###map.mapTypes.set "Internet", internetMapType###
	BWtype(map)


	### This is a fix to push navigation below navigation section ###
	controlDiv = document.createElement('DIV')
	controlDiv.innerHTML = "<br /> <br /> <br /> <br />"
	map.controls[google.maps.ControlPosition.TOP_RIGHT].push controlDiv


	### Set up markers, window, and geocoder ###
	markersArray = []
	markersArray.push new google.maps.Marker() for [0..numberOfMarkersToShowOnPage - 1]
	infoWindow = new google.maps.InfoWindow()
	geocoder = new google.maps.Geocoder()

	### Start rate limited event marker refresher ###
	updateTimer = null
	google.maps.event.addListener(map, 'bounds_changed', ->
		if not updateTimer? and not window.mousingovernames
			updateTimer = setTimeout(->
				updateResults()
				updateTimer = null
			,
			getNewEventsRate)
	)
	true

internetMapOptions =
	getTileUrl: (coord, zoom) ->
		normalizedCoord = getNormalizedCoord(coord, zoom)
		return null unless normalizedCoord
		bound = Math.pow(2, zoom)
		"../../../static/internetmap" + "/" + zoom + "/" + normalizedCoord.x + "/" + (bound - normalizedCoord.y - 1) + ".png"

	tileSize: new google.maps.Size(256, 256)
	maxZoom: 7
	minZoom: 0
	isPng: true
	opacity: 1
	radius: 1738000
	name: "Internet"




### Google maps helpers! ---------------------------------------------------- ###

centerMapOnAddress = (address) ->
	geocoder.geocode {'address': address}, (results, status) ->
		if (status == google.maps.GeocoderStatus.OK)
			$('#mapsection').show()
			$('#mapblanksection').hide()
			map.setCenter(results[0].geometry.location)
			map.fitBounds(results[0].geometry.viewport)
		else
			$('#mapblanksection').show()
			$('#mapsection').hide()

### The internet map page side thing helper ---------------------------------- ###
getNormalizedCoord = (coord, zoom) ->
	y = coord.y
	x = coord.x

	### tile range in one direction range is dependent on zoom level ###
	### 0 = 1 tile, 1 = 2 tiles, 2 = 4 tiles, 3 = 8 tiles, etc ###
	tileRange = 1 << zoom

	### don't repeat across y-axis (vertically) ###
	return null if y < 0 or y >= tileRange

	### repeat across x-axis ###
	if x < 0 or x >= tileRange
		x = (x % tileRange + tileRange) % tileRange

	return {x: x, y: y}

