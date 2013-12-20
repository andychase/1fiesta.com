###
  This script is for the placing of the markers &
    the populating of the site listing
###



### Event Icon placement on map! ---------------------------------------------- ###

shouldHideEvent = (e) ->
	if eventTooCloseToBottomOfList(e)
		hidden = true
	else if eventTooCloseToAnother(e)
		hidden = true
	else
		hidden = false
	hidden

eventTooCloseToBottomOfList = (e) ->
	last = $("#eventlist li:last").offset()
	if last != null
		$(window).height() < last.top + markersTooCloseToBotOfPage
	else
		false

dist = (x1, y1, x2, y2) ->
	xs = x2 - x1
	ys = y2 - y1
	(Math.sqrt(((xs * xs) + (ys * ys)))) * 2000

eventTooCloseToAnother = (e) ->
	for marker in markersArray
		if marker.getPosition()? and marker.getIcon() != '/static/icons/hidden.png'
			pos = marker.getPosition()
			d = dist parseFloat(e.latitude), parseFloat(e.longitude), pos.lat(), pos.lng()
			if 1 < d < smallestMarkerDist
				smallestMarkerDist = d
			if 1 < d < markersTooCloseOnMap(map.getZoom())
				return true
	false

updateMarker = (i, e, hidden) ->
	###
 	This function updates only one marker. Checks to see
 	if it's already on the map, and puts on on there if not.
	###

	### Default iconname ###
	if hidden
		e.iconname = 'hidden'
	else if e.type?
		e.iconname = iconnametypes[e.type.trim().toLowerCase()]
	if not e.iconname?
		e.iconname = 'birthday'

	position = new google.maps.LatLng(e.latitude, e.longitude)
	marker = markersArray[i]
	returnthismarker = marker

	inarray = false
	for testmarker in markersArray
		if testmarker.getPosition()? and testmarker.getPosition().equals(position)
			inarray = true
			returnthismarker = testmarker
			if testmarker.getIcon() != '/static/icons/' + e.iconname + '.png'
				testmarker.setIcon('/static/icons/' + e.iconname + '.png')
				updateInfoWindow(testmarker, e, hidden)
			break


	if !inarray
		marker.name = e.name
		marker.setPosition(position)
		marker.setMap(map)
		marker.setIcon('/static/icons/' + e.iconname + '.png')
		updateInfoWindow(marker, e, hidden)
	returnthismarker

updateInfoWindow = (marker, e, hidden) ->
	google.maps.event.clearInstanceListeners(marker)
	if hidden then return
	google.maps.event.addListener(marker, 'click', ->
		location.href = e.sourceurl
	)

	google.maps.event.addListener(marker, 'mouseover', ->
		$('#'+e._id).addClass("highlighted")
		infoWindow.setContent(buildInfoWindowContent(e))
		infoWindow.open(map, marker)
	)

	google.maps.event.addListener(marker, 'mouseout', ->
		$('#'+e._id).removeClass("highlighted")
		infoWindow.close(map, marker)
	)
	marker

clearMarkers = () ->
	for marker in markersArray
		marker.setPosition(null)
		marker.setMap(null)

### Date formatter ###

cleanFormatDate = (datestring) ->
	moment.utc(datestring).calendar()
		.replace("Today at 12:00 AM", "Tomorrow")
		.replace("Yesterday at 12:00 AM", "Today")

### Event listing formatters ###
listEvent = (e, target, marker) ->
	target.append(eventListing(e))
	$('#'+e._id).mouseover ->
		infoWindow.setContent(buildInfoWindowContent(e))
		infoWindow.open(map, marker)
	$('#'+e._id).mouseleave ->
		infoWindow.close(map, marker)

eventListing = (e) ->
	if not e.type?
		e.type = ""
	if e.venue_name == "unk"
		e.venue_name = " "
	"""
		<li id='#{e._id}'>
			<span class="toprow">
				<a href='#{e.sourceurl}'>
					<b>
						#{e.type}
					</b>
					#{e.name}
				</a>
				</span>
			<br />
		</li>
	"""

buildInfoWindowContent = (e) ->
	"""
	<div class='mapmarkerpopup'>
		<b> #{e.name}</b><br />
		#{e.venue_name}<br />
		#{cleanFormatDate(e.date)}
		<hr />
		#{e.description}<br />
		<i>(from #{e.source})</i>
		</div>
	"""