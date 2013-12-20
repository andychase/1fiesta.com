###
Review JS
This is used for the review section of the site.
###

output = {}
logged_in = false
total_lines = null
test_area = null
skip_array = null
output.line = null
output.event_id = null
output.reviewer_id = null
output.answer = null

$(document).ready ->
	test_area = $("#test_area")
	$("#reviewer_id_submit").click ->
		reviewer_id = $("#reviewer_id").val()
		login(reviewer_id)
	$("#reviewer_id").keydown (e) ->
		if e.keyCode == 13
			reviewer_id = $("#reviewer_id").val()
			login(reviewer_id)
	$(window).keydown (e) ->
		if output.event_id != null
			switch e.keyCode
				when 81 then next_line 'q'
				when 87 then next_line 'w'
				when 69 then next_line 'e'
				when 82 then next_line 'r'
				when 84 then next_line 't'
				when 89 then prev_line 'y'

login = (reviewer_id) ->
	$.post "review/login", {"reviewer_id": reviewer_id}, (data, textStatus, jqXHR) ->
		if data != null and data.success == true
			if logged_in
				return
			logged_in = true
			output.reviewer_id = data.reviewer_id
			$("#setting_info_area").empty()
			$("#legend").show()
			$("#bottom").show()
			$("#setting_info_area").append(data.name)
			get_next_event()

review_event = (event) ->
	$("#test_area").empty()
	output.event_id = event._id
	total_lines = event.value.length
	output.line = 0
	skip_array = []
	for line in event.value
		$("#test_area").append "<div id='line#{line.pos}'><div class='lc'>#{line.value}<br /></div></div>"
		skip_array.push(line.skip)
	set_line(0)

prev_line = ->
	if output.line == 0
		return
	reset_line(output.line)
	output.line -= 1
	set_line(output.line)

next_line = (key) ->
	output.answer = key
	send_data()
	reset_line(output.line, key)
	output.line += 1
	while skip_array[output.line] == true
		output.line += 1
	if output.line > total_lines-1
		get_next_event()
	else
		set_line(output.line)

set_line = (line_number) ->
	line = test_area.children().eq(line_number)
	line.css("background-color", "grey")
	amount_to_move_up = (($(window).height() / 2) - 12) - line.offset().top
	test_area_top = test_area.offset().top
	test_area.animate({top:test_area_top+amount_to_move_up}, 100);

reset_line = (line_number, key) ->
	line = test_area.children().eq(line_number)
	switch key
		when 'q' then set_label line, 'DATE_'
		when 'w' then set_label line, 'TITLE'
		when 'e' then set_label line, 'ADDR_'
		when 'r' then set_label line, 'SPLIT'
		when 't' then set_label line, ''
	line.css("background-color", "transparent")

set_label = (line, label) ->
	line = line.children().eq(0)
	line.find("strong").remove()
	if label then line.prepend("<strong>#{label}</strong>")

send_data = ->
	switch output.answer
		when 'q' then output.answer = 'date'
		when 'w' then output.answer = 'title'
		when 'e' then output.answer = 'addr'
		when 'r' then output.answer = 'split'
		when 't' then output.answer = ''
	$.post("review/post", output)

get_next_event = ->
	$.post "review/post", {"get_next_event" : true}, (data, success, other) ->
		review_event(data)