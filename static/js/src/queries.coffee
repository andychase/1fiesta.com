###
  This is where the functions go that query google & elastic search
    as well as the actual queries themselves
###

###
	Geocode
###

geocode = (address, onSuccess) ->
	if geocoder?
		geocoder = new google.maps.Geocoder()
	geocoder.geocode { 'address': address}, (results, status) ->
		if status == google.maps.GeocoderStatus.OK
			onSuccess(results)


###
   Elastic Search
###

queryElasticSearch = (input, query, success) ->
	ajaxOptions = {
		dataType: "jsonp"
		type: "GET"
		url: "http://ec2-54-245-11-42.us-west-2.compute.amazonaws.com:9200/events/_search"
		data: {source : JSON.stringify(query(input))}
		success: success
	}
	$.ajax(ajaxOptions)

bounderyQ = (map_bounds) ->
	datefilter = do () ->
		if not window.activeDateFilter?
			window.activeDateFilter = "week"
		from: if window.activeDateFilter == "tomorrow" then "now+1d/d" else "now/d"
		to: switch window.activeDateFilter
				when "all" then null
				when "today" then "now/d"
				when "tomorrow" then "now+1d/d"
				when "week" then "now/w"
				when "month" then "now/M"
				else null
	size: numberOfMarkersToShowOnPage
	sort: [
		score:
			order:
				"asc"
	]
	query:
		filtered:
			query: getQuery()
			filter:
				and: [
					range:
						date: datefilter
				,
					geo_bounding_box:
						"location":
							top_left:
								lat: map_bounds.getNorthEast().lat()
								lon: map_bounds.getSouthWest().lng()
							bottom_right:
								lat: map_bounds.getSouthWest().lat()
								lon: map_bounds.getNorthEast().lng()
				]

complexQ = (input) ->
	size: 5
	query:
		dis_max:
			queries: [
				text:
					_all:
						query: input
						fuzziness: 0.4
						operator: "and"
			,
				custom_boost_factor:
					query:
						text_phrase_prefix:
							_all: input

					boost_factor: 2
			]
	filter:
		range:
			date:
				from: "now/d"


phrasePrefixQuery = (input) ->
	size: 5
	query:
		text_phrase_prefix:
			name:
				query: input
				,
				max_expansions: 10
	filter:
		range:
			date:
				from: "now/d"


getQuery = () ->
	if $('#searchbox').val() != ""
		return text_phrase_prefix:
					_all:
						query: $('#searchbox').val()
						,
						max_expansions: 10
	else
		{match_all:
			{}}