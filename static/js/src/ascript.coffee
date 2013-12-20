
###
   Script.js - Script that powers 1fiesta. By Andy Chase.
###

map = ""
geocoder = ""
markersArray = ""
infoWindow = ""
current_lang = "english"

### Script options ###
numberOfMarkersToShowOnPage = 90
getNewEventsRate = 500
### ^ Milliseconds ###
markersTooCloseToBotOfPage = 150
markersTooCloseOnMap = (zoom) ->
	if zoom > 9
		((-2.4 * zoom) + 41.8)
	else if zoom > 0
		(8000 / Math.pow(2, zoom - 1))
	else
		20000

iconnametypes = {
	"animal/agriculture": "birthday",
	"art festival": "birthday",
	"brewery": "birthday",
	"books" : "reading",
	"charity event": "fundraising",
	"cultural heritage": "gathering",
	"exhibit": "screening",
	"exhibits": "conference",
	"fair": "birthday",
	"fairs/festivals": "birthday",
	"festival": "birthday",
	"festivals": "birthday",
	"food": "birthday",
	"holiday": "deadline",
	"performing arts": "performance",
	"sports": "sports",
	"visual arts": "performance",
	"winery": "birthday",
	"artshow": "screening",
	"concert": "concert",
	"spin city": "concert",
	"music calendar, music listing" : "concert",
	"classical music" : "concert",
}

window.mousingovernames = false
window.beforeenteredcenter = null

### The main script! ###
$(document).ready ->
	### Set up map ###
	if $('#mapsection').length
		setUpMapSection()
		jumptoLocOrCookieLoc()

	### Date filter ###
	if window.QueryString['date']?
		$('.datefilter a').removeClass('active');
		$('.datefilter #'+window.QueryString['date']).addClass('active');
		window.activeDateFilter = window.QueryString['date']
		setDateFilter(window.QueryString['date'])
	$('.datefilter a').click switchDateFilter

	### Search bar Autocompleter ###
	$('#searchbox').keyup ->
		if $('#searchbox').val() == ""
			updateResults()
			return
		clearMarkers()
		updateResults()

	### Sidebar corrector ###
	$('#contentcolumn').mouseenter () ->
		if map.getCenter()?
			if not window.mousingovernames
				window.beforeenteredcenter = map.getCenter()
			window.mousingovernames = true
			clearTimeout window.mousingovertimer

	$('#contentcolumn').mouseleave () ->
		if window.beforeenteredcenter?
			map.panTo window.beforeenteredcenter
			window.mousingovertimer =
				setTimeout (() -> window.mousingovernames = false; updateResults()), 700

setDateFilter = (id) ->
	$('.datefilter li').removeClass "active"
	$('.datefilter li #' + id).addClass "active"

switchDateFilter = () ->
	$('.datefilter a').removeClass "active"
	$(this).addClass "active"
	window.activeDateFilter = $(this)[0].id
	clearMarkers()
	updateResults()

jumptoLocOrCookieLoc = () ->
	jump_location = ""
	if window.QueryString["type"] == "Location"
		jump_location = window.QueryString["q"].toString()
		if  jump_location == $.cookie("jump_location")
			jump_location = ""
		else
			$.cookie("jump_location", jump_location)
	location_value = $.cookie("location")
	location_zoom = Number($.cookie("location_zoom"))

	if jump_location != ""
		centerMapOnAddress jump_location
	else if not location_value?
		 centerMapOnAddress "Oregon, USA"
	else
		lat = location_value.split(',')[0]
		lng = location_value.split(',')[1]
		location = new google.maps.LatLng(lat, lng)
		map.setCenter location
		map.setZoom location_zoom

updateResults = () ->
	map_bounds        = if map.getBounds()? then map.getBounds() else ""
	center_map_bounds = if map.getCenter()? then map.getCenter().toUrlValue() else ""
	detect_language(map.getCenter())
	$.cookie("location", center_map_bounds)
	$.cookie("location_zoom", map.getZoom())
	queryElasticSearch map_bounds, bounderyQ, (data) ->
		data = data.hits.hits
		$('#eventlist').empty()
		numberToProcess = Math.min(data.length - 1, numberOfMarkersToShowOnPage - 1)
		if data.length > 0 then for i in [0..numberToProcess]
			e = data[i]._source
			e.longitude = e.location.lon
			e.latitude = e.location.lat
			e.location = e.address
			hidden = shouldHideEvent(e)
			marker = updateMarker(i, e, hidden)
			if not hidden then listEvent(e, $('#eventlist'), marker)
		else
			if current_lang == "chinese" then $('#eventlist').append("<span class='nothing'>&#20160;&#20040;&#20063;&#27809;&#26377;</span>")
			else $('#eventlist').append("<span class='nothing'>Nothing here, try zooming out or removing filters.</span>")


### Localization ###
detect_language = (center_of_map) ->
	lang = get_location(center_of_map)
	if lang != current_lang
		current_lang = lang
		switch get_location(center_of_map)
			when "chinese"
				chinese_nav = [ false, false, "&#35841;", "&#22238;&#39304;"]
				chinese_cal = ["&#25152;&#26377;&#20107;&#29289;",
								"&#20170;&#22825;", "&#26126;&#22825;", 
								"&#36889;&#20491;&#26143;&#26399;",
								"&#36889;&#20491;&#26376;"]
				chinese_search = "&#23547;&#25214;"
				chinese_date_title = "&#35745; &#26102;"
				change_language(chinese_search, chinese_date_title, chinese_nav, chinese_cal)
			else
				english_nav = [ false, false, "About", "Feedback"]
				english_cal = ["All", "Today", "Tomorrow", "Week", "Month"]
				english_search = "Search"
				english_date_title = "Date:"
				change_language(english_search, english_date_title, english_nav, english_cal)


change_language = (search, date_title, nav, cal) ->
	$(".navigationbar form ul li").each (i) ->
		if nav[i] then $(this).children("a").html(nav[i])
		if i == 1 then $(this).children()[1].value = $(document.createElement('div')).html(search).html()
	$(".datefilter span").html(date_title)
	$(".datefilter ul li").each (i) ->
		$(this).children("a").html(cal[i])

get_location = (center_of_map) ->
	if point_in_rect(center_of_map.lat(), center_of_map.lng(), 1.4552673222585695, 1.2456742607811258, 104.22431479101556, 103.56650839453118) then "chinese"
	else "english"

point_in_rect = (x, y, rect_high_x, rect_low_x, rect_high_y, rect_low_y) ->
	x < rect_high_x && x > rect_low_x && y < rect_high_y && y > rect_low_y


