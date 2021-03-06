// Generated by CoffeeScript 1.3.3
/*
Review JS
This is used for the review section of the site.
*/

var get_next_event, logged_in, login, next_line, output, prev_line, reset_line, review_event, send_data, set_label, set_line, skip_array, test_area, total_lines;

output = {};

logged_in = false;

total_lines = null;

test_area = null;

skip_array = null;

output.line = null;

output.event_id = null;

output.reviewer_id = null;

output.answer = null;

$(document).ready(function() {
  test_area = $("#test_area");
  $("#reviewer_id_submit").click(function() {
    var reviewer_id;
    reviewer_id = $("#reviewer_id").val();
    return login(reviewer_id);
  });
  $("#reviewer_id").keydown(function(e) {
    var reviewer_id;
    if (e.keyCode === 13) {
      reviewer_id = $("#reviewer_id").val();
      return login(reviewer_id);
    }
  });
  return $(window).keydown(function(e) {
    if (output.event_id !== null) {
      switch (e.keyCode) {
        case 81:
          return next_line('q');
        case 87:
          return next_line('w');
        case 69:
          return next_line('e');
        case 82:
          return next_line('r');
        case 84:
          return next_line('t');
        case 89:
          return prev_line('y');
      }
    }
  });
});

login = function(reviewer_id) {
  return $.post("review/login", {
    "reviewer_id": reviewer_id
  }, function(data, textStatus, jqXHR) {
    if (data !== null && data.success === true) {
      if (logged_in) {
        return;
      }
      logged_in = true;
      output.reviewer_id = data.reviewer_id;
      $("#setting_info_area").empty();
      $("#legend").show();
      $("#bottom").show();
      $("#setting_info_area").append(data.name);
      return get_next_event();
    }
  });
};

review_event = function(event) {
  var line, _i, _len, _ref;
  $("#test_area").empty();
  output.event_id = event._id;
  total_lines = event.value.length;
  output.line = 0;
  skip_array = [];
  _ref = event.value;
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    line = _ref[_i];
    $("#test_area").append("<div id='line" + line.pos + "'><div class='lc'>" + line.value + "<br /></div></div>");
    skip_array.push(line.skip);
  }
  return set_line(0);
};

prev_line = function() {
  if (output.line === 0) {
    return;
  }
  reset_line(output.line);
  output.line -= 1;
  return set_line(output.line);
};

next_line = function(key) {
  output.answer = key;
  send_data();
  reset_line(output.line, key);
  output.line += 1;
  while (skip_array[output.line] === true) {
    output.line += 1;
  }
  if (output.line > total_lines - 1) {
    return get_next_event();
  } else {
    return set_line(output.line);
  }
};

set_line = function(line_number) {
  var amount_to_move_up, line, test_area_top;
  line = test_area.children().eq(line_number);
  line.css("background-color", "grey");
  amount_to_move_up = (($(window).height() / 2) - 12) - line.offset().top;
  test_area_top = test_area.offset().top;
  return test_area.animate({
    top: test_area_top + amount_to_move_up
  }, 100);
};

reset_line = function(line_number, key) {
  var line;
  line = test_area.children().eq(line_number);
  switch (key) {
    case 'q':
      set_label(line, 'DATE_');
      break;
    case 'w':
      set_label(line, 'TITLE');
      break;
    case 'e':
      set_label(line, 'ADDR_');
      break;
    case 'r':
      set_label(line, 'SPLIT');
      break;
    case 't':
      set_label(line, '');
  }
  return line.css("background-color", "transparent");
};

set_label = function(line, label) {
  line = line.children().eq(0);
  line.find("strong").remove();
  if (label) {
    return line.prepend("<strong>" + label + "</strong>");
  }
};

send_data = function() {
  switch (output.answer) {
    case 'q':
      output.answer = 'date';
      break;
    case 'w':
      output.answer = 'title';
      break;
    case 'e':
      output.answer = 'addr';
      break;
    case 'r':
      output.answer = 'split';
      break;
    case 't':
      output.answer = '';
  }
  return $.post("review/post", output);
};

get_next_event = function() {
  return $.post("review/post", {
    "get_next_event": true
  }, function(data, success, other) {
    return review_event(data);
  });
};
