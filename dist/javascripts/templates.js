(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['application'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<div id='gmap'></div>\n<div id='graph'></div>\n<div id='content'>\n  <div id='main_content'></div>\n  <div id='user_controls'></div>\n</div>\n<div id='view_toggle'>\n  <a class='expand'>></a>\n  <a class='collapse'><</a>\n</div>\n<div id='notice'></div>\n<div id='action'></div>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['attachments/admin_list_item'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<span>\n  <a class='file_icon minimal'></a>\n</span>\n<span class='editable name' data-placeholder='file name'></span>\n<a class='delete'>\u232B</a>\n<input class='file' type='file'>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['attachments/empty'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("You can use this space to attach entry forms, fliers, maps, instructions or anything else you like. \n<a class='add add_attachment' href='#'>\n  add a file.\n</a>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['attachments/list_item'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<a class='file_icon' data-window='true'></a>\n<a class='file_name' data-window='true'></a>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['categories/option'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<label>\n  <input class='category' type='checkbox'>\n  <span class='name'></span>\n</label>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['categories/picker'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<h4>\n  Categories offered\n</h4>\n<div class='categories'>\n  <ul class='flat male'></ul>\n  <ul class='female flat'></ul>\n  <ul class='flat junior'></ul>\n</div>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['checkpoints/admin_list_item'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<span class='symbol unfixed'>o</span>\n<span class='pos'></span>\n<span class='editable name' data-placeholder='name'></span>\n<span class='gridref'></span>\n<a class='place'>add to map</a>\n<a class='delete'>\u232B</a>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['checkpoints/empty'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("You can add checkpoints by typing in grid references here or by clicking on the map above.\n<a class='add add_checkpoint' href='#'>\n  add a checkpoint.\n</a>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['checkpoints/list_item'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<a class='name'></a>\n<span class='gridref'></span>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['clubs/admin_row'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<td>\n  <span class='id'></span>\n</td>\n<td>\n  <span class='name'></span>\n</td>\n<td>\n  <span class='alias_of'></span>\n  <span class='not_merging'>\n    <a class='go merge_to microbutton'>merge to</a>\n    <a class='microbutton remove remove_alias'>x</a>\n  </span>\n  <a class='cancel_merge microbutton'>cancel</a>\n</td>\n<td>\n  <span class='display_name editable' data-placeholder='display name' data-plain></span>\n</td>\n<td>\n  <span class='editable full_name' data-placeholder='full name' data-plain></span>\n</td>\n<td>\n  <span class='editable short_name' data-placeholder='short name' data-plain></span>\n</td>\n<td>\n  <span class='not_merging'>\n    <a class='go merge microbutton'>complete merge</a>\n  </span>\n</td>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['clubs/admin_table'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<table class='clubs'>\n  <thead>\n    <tr>\n      <th>id</th>\n      <th>name</th>\n      <th>alias of</th>\n      <th>display name</th>\n      <th>full name</th>\n      <th>short name</th>\n      <th></th>\n    </tr>\n  </thead>\n  <tbody></tbody>\n</table>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['clubs/link'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<a class='name'></a>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['clubs/list_item'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<a class='name'></a>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['clubs/list'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<h1 class='title'>Clubs</h1>\n<div class='clubs'></div>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['clubs/show'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<h1 class='name'></h1>\n<a class='website'>Club website</a>\n<div class='competitors'></div>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['clubs/suggestion'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<span class='name'></span>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['competitors/admin'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<div class='head'>\n  <div class='picture'></div>\n  <div class='title'>\n    <h2 class='name'>\n      <span class='forename'></span>\n      <span class='middlename'></span>\n      <span class='surname'></span>\n    </h2>\n    <div class='owner'>\n      <a class='cancel'>exit</a>\n    </div>\n  </div>\n</div>\n<div class='body'>\n  <p class='club onecol'>\n    <span class='col'>\n      <label for='club'>Club</label>\n      <input id='club_name' name='club_name' type='text'>\n    </span>\n    <span class='note'>\n      Your club should appear in the list of suggestions when you start typing.\n      If yours is not there, please give its full name. Choose 'Unattached' if no club.\n    </span>\n  </p>\n  <p>\n    <a class='button save'>save</a>\n  </p>\n</div>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['competitors/competitor'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<div id='competitor'></div>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['competitors/entries'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<h3>Entries</h3>\n<table class='entries'>\n  <thead>\n    <tr>\n      <th class='date'>date</th>\n      <th class='race_name'>race</th>\n    </tr>\n  </thead>\n  <tbody></tbody>\n</table>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['competitors/entry'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<td class='date'>\n  <span class='date'></span>\n</td>\n<td class='race'>\n  <a class='race'></a>\n</td>\n<td>\n  <a class='cancel'>x</a>\n  <span class='cancelled'>cancelled</span>\n</td>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['competitors/list_item'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<a class='name'></a>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['competitors/main'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<a class='main_name'></a>\n(\n<span class='main_club'></span>\n)\n<span class='main_gender'></span>\n<span class='main_dob'></span>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['competitors/match_row'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<td>\n  <a class='name'>\n    <span class='forename'></span>\n    <span class='middlename'></span>\n    <span class='surname'></span>\n  </a>\n</td>\n<td>\n  <span class='club'></span>\n</td>\n<td>\n  <a class='merge microbutton'>Merge</a>\n</td>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['competitors/match_table'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<h3>Matches</h3>\n<table class='matches'>\n  <thead>\n    <th>name</th>\n    <th>club</th>\n  </thead>\n  <tbody></tbody>\n</table>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['competitors/merge_row'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<td class='main_competitor'></td>\n<td>\ <<<<</td>\n<td class='duplicate'>\n  <a class='name'></a>\n  (\n  <span class='club'></span>\n  )\n  <span class='gender'></span>\n  <span class='dob'></span>\n</td>\n<td class='controls'>\n  <a class='accept'>Accept</a>\n  <a class='reject'>Reject</a>\n</td>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['competitors/merge_table'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<h1 class='title'>\n  <a class='back' href='/runners'><</a>\n  Competitor merge requests\n</h1>\n<table class='competitors'></table>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['competitors/performance'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<td class='date'>\n  <span class='date'></span>\n</td>\n<td class='race'>\n  <a class='race_name'></a>\n</td>\n<td class='time'>\n  <span class='time'></span>\n</td>\n<td class='pos'>\n  <span class='total_competitors'></span>\n  <span class='pos'></span>\n</td>\n<td class='winner'>\n  <a class='winner'></a>\n  <span class='winning_time'></span>\n</td>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['competitors/performances'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<h3>Results</h3>\n<table class='results'>\n  <thead>\n    <tr>\n      <th class='date'>date</th>\n      <th class='race_name'>race</th>\n      <th class='time'>time</th>\n      <th class='pos'>pos</th>\n      <th class='winner'>winner</th>\n    </tr>\n  </thead>\n  <tbody></tbody>\n</table>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['competitors/race'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      return $o.join("\n");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['competitors/results'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<nav>\n  <a id='by_date'>Date</a>\n  <a id='by_year'>Year</a>\n  <a id='by_category'>Category</a>\n</nav>\n<table id='results_by_race'></table>\n<table id='results_by_year'></table>\n<table id='results_by_category'></table>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['competitors/row'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<td>\n  <a class='name'></a>\n</td>\n<td class='club'></td>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['competitors/show'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<div class='head'>\n  <div class='picture'></div>\n  <div class='title'>\n    <h2 class='name'>\n      <span class='forename'></span>\n      <span class='middlename'></span>\n      <span class='surname'></span>\n    </h2>\n    <div class='owner'>\n      <a class='edit'>edit</a>\n    </div>\n  </div>\n  <!-- .social -->\n  <!--   %a.fb facebook -->\n  <!--   %a.twit twitter -->\n  <!--   %a.strava strava -->\n</div>\n<div class='body'>\n  <div class='entries'></div>\n  <div class='results'></div>\n  <div class='matches'></div>\n</div>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['competitors/table'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<h1 class='title'>\n  <a class='back' href='/'><</a>\n  Find runners\n</h1>\n<div class='search_form'>\n  <span class='editable forename param' data-placeholder='forename'></span>\n  <span class='editable param surname' data-placeholder='surname'></span>\n  <!-- %span.club.editable{:data => {:placeholder => \"forename\"} -->\n  <a class='search' href=''>Search</a>\n</div>\n<div class='competitors'></div>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['entries/admin_row'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<td>\n  <a class='name'>\n    <span class='fore'></span>\n    <span class='middle'></span>\n    <span class='sur'></span>\n  </a>\n</td>\n<td>\n  <span class='cat'></span>\n</td>\n<td>\n  <span class='club_name'></span>\n</td>\n<td>\n  <span class='paid_or_accepted'></span>\n</td>\n<td>\n  <a class='withdraw'>\n    withdraw\n  </a>\n</td>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['entries/admin_table'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<thead>\n  <tr>\n    <th>name</th>\n    <th>cat</th>\n    <th>club</th>\n    <th></th>\n  </tr>\n</thead>\n<tbody></tbody>");
      return $o.join("\n");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['entries/cancelled_admin_row'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<td>\n  <a class='name'>\n    <span class='fore'></span>\n    <span class='middle'></span>\n    <span class='sur'></span>\n  </a>\n</td>\n<td>\n  <span class='cat'></span>\n</td>\n<td>\n  <span class='club_name'></span>\n</td>\n<td>\n  <span class='paid_or_accepted'></span>\n</td>\n<td>\n  <a class='reinstate'>\n    reinstate\n  </a>\n</td>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['entries/edit_competitor'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<p class='name twocol'>\n  <span class='col'>\n    <label for='forename'>Forename</label>\n    <input id='forename' name='firstname' type='text'>\n  </span>\n  <span class='col last'>\n    <label for='surname'>Surname</label>\n    <input id='surname' name='surname' type='text'>\n  </span>\n</p>\n<p class='cat twocol'>\n  <span class='col'>\n    <label>\n      Gender\n    </label>\n    <input id='male' name='gender' type='radio' value='m'>\n    <label class='inline' for='male'>Male</label>\n    <input id='female' name='gender' type='radio' value='f'>\n    <label class='inline' for='female'>Female</label>\n    <br>\n  </span>\n  <span class='col last'>\n    <label for='dob'>Date of birth</label>\n    <input id='dob' name='dob' type='text' placeholder='YYYY-MM-DD'>\n  </span>\n  <span class='note'>\n    Race category will be based on your gender and age.\n  </span>\n</p>\n<p class='club onecol'>\n  <span class='col'>\n    <label for='club'>Club</label>\n    <input id='club_name' name='club_name' type='text'>\n  </span>\n  <span class='note'>\n    Your club should appear in the list of suggestions when you start typing.\n    If yours is not there, please give its full name. Choose 'Unattached' if no club.\n  </span>\n</p>\n<p class='contacts twocol'>\n  <span class='col'>\n    <label for='postal_address_line_1'>Address</label>\n    <input id='postal_address_line_1' name='address 1' type='text' placeholder='Line 1'>\n    <input id='postal_address_line_2' name='address 2' type='text' placeholder='Line 2'>\n    <input id='postal_town' name='city' type='text' placeholder='Post town'>\n    <input id='postcode' name='postalcode' type='text' placeholder='Postcode'>\n    <select id='postal_county'>\n      <option value=''>County...</option>\n      <option value='Avon'>Avon</option>\n      <option value='Bedfordshire'>Bedfordshire</option>\n      <option value='Berkshire'>Berkshire</option>\n      <option value='Borders'>Borders</option>\n      <option value='Buckinghamshire'>Buckinghamshire</option>\n      <option value='Cambridgeshire'>Cambridgeshire</option>\n      <option value='Central'>Central</option>\n      <option value='Cheshire'>Cheshire</option>\n      <option value='Cleveland'>Cleveland</option>\n      <option value='Clwyd'>Clwyd</option>\n      <option value='Cornwall'>Cornwall</option>\n      <option value='County Antrim'>County Antrim</option>\n      <option value='County Armagh'>County Armagh</option>\n      <option value='County Down'>County Down</option>\n      <option value='County Fermanagh'>County Fermanagh</option>\n      <option value='County Londonderry'>County Londonderry</option>\n      <option value='County Tyrone'>County Tyrone</option>\n      <option value='Cumbria'>Cumbria</option>\n      <option value='Derbyshire'>Derbyshire</option>\n      <option value='Devon'>Devon</option>\n      <option value='Dorset'>Dorset</option>\n      <option value='Dumfries and Galloway'>Dumfries and Galloway</option>\n      <option value='Durham'>Durham</option>\n      <option value='Dyfed'>Dyfed</option>\n      <option value='East Sussex'>East Sussex</option>\n      <option value='Essex'>Essex</option>\n      <option value='Fife'>Fife</option>\n      <option value='Gloucestershire'>Gloucestershire</option>\n      <option value='Grampian'>Grampian</option>\n      <option value='Greater Manchester'>Greater Manchester</option>\n      <option value='Gwent'>Gwent</option>\n      <option value='Gwynedd County'>Gwynedd County</option>\n      <option value='Hampshire'>Hampshire</option>\n      <option value='Herefordshire'>Herefordshire</option>\n      <option value='Hertfordshire'>Hertfordshire</option>\n      <option value='Highlands and Islands'>Highlands and Islands</option>\n      <option value='Humberside'>Humberside</option>\n      <option value='Isle of Wight'>Isle of Wight</option>\n      <option value='Kent'>Kent</option>\n      <option value='Lancashire'>Lancashire</option>\n      <option value='Leicestershire'>Leicestershire</option>\n      <option value='Lincolnshire'>Lincolnshire</option>\n      <option value='Lothian'>Lothian</option>\n      <option value='Merseyside'>Merseyside</option>\n      <option value='Mid Glamorgan'>Mid Glamorgan</option>\n      <option value='Norfolk'>Norfolk</option>\n      <option value='North Yorkshire'>North Yorkshire</option>\n      <option value='Northamptonshire'>Northamptonshire</option>\n      <option value='Northumberland'>Northumberland</option>\n      <option value='Nottinghamshire'>Nottinghamshire</option>\n      <option value='Oxfordshire'>Oxfordshire</option>\n      <option value='Powys'>Powys</option>\n      <option value='Rutland'>Rutland</option>\n      <option value='Shropshire'>Shropshire</option>\n      <option value='Somerset'>Somerset</option>\n      <option value='South Glamorgan'>South Glamorgan</option>\n      <option value='South Yorkshire'>South Yorkshire</option>\n      <option value='Staffordshire'>Staffordshire</option>\n      <option value='Strathclyde'>Strathclyde</option>\n      <option value='Suffolk'>Suffolk</option>\n      <option value='Surrey'>Surrey</option>\n      <option value='Tayside'>Tayside</option>\n      <option value='Tyne and Wear'>Tyne and Wear</option>\n      <option value='Warwickshire'>Warwickshire</option>\n      <option value='West Glamorgan'>West Glamorgan</option>\n      <option value='West Midlands'>West Midlands</option>\n      <option value='West Sussex'>West Sussex</option>\n      <option value='West Yorkshire'>West Yorkshire</option>\n      <option value='Wiltshire'>Wiltshire</option>\n      <option value='Worcestershire'>Worcestershire</option>\n    </select>\n    <select id='postal_country'>\n      <option value='AF'>Afghanistan</option>\n      <option value='AX'>Åland Islands</option>\n      <option value='AL'>Albania</option>\n      <option value='DZ'>Algeria</option>\n      <option value='AS'>American Samoa</option>\n      <option value='AD'>Andorra</option>\n      <option value='AO'>Angola</option>\n      <option value='AI'>Anguilla</option>\n      <option value='AQ'>Antarctica</option>\n      <option value='AG'>Antigua and Barbuda</option>\n      <option value='AR'>Argentina</option>\n      <option value='AM'>Armenia</option>\n      <option value='AW'>Aruba</option>\n      <option value='AU'>Australia</option>\n      <option value='AT'>Austria</option>\n      <option value='AZ'>Azerbaijan</option>\n      <option value='BS'>Bahamas</option>\n      <option value='BH'>Bahrain</option>\n      <option value='BD'>Bangladesh</option>\n      <option value='BB'>Barbados</option>\n      <option value='BY'>Belarus</option>\n      <option value='BE'>Belgium</option>\n      <option value='BZ'>Belize</option>\n      <option value='BJ'>Benin</option>\n      <option value='BM'>Bermuda</option>\n      <option value='BT'>Bhutan</option>\n      <option value='BO'>Bolivia, Plurinational State of</option>\n      <option value='BQ'>Bonaire, Sint Eustatius and Saba</option>\n      <option value='BA'>Bosnia and Herzegovina</option>\n      <option value='BW'>Botswana</option>\n      <option value='BV'>Bouvet Island</option>\n      <option value='BR'>Brazil</option>\n      <option value='IO'>British Indian Ocean Territory</option>\n      <option value='BN'>Brunei Darussalam</option>\n      <option value='BG'>Bulgaria</option>\n      <option value='BF'>Burkina Faso</option>\n      <option value='BI'>Burundi</option>\n      <option value='KH'>Cambodia</option>\n      <option value='CM'>Cameroon</option>\n      <option value='CA'>Canada</option>\n      <option value='CV'>Cape Verde</option>\n      <option value='KY'>Cayman Islands</option>\n      <option value='CF'>Central African Republic</option>\n      <option value='TD'>Chad</option>\n      <option value='CL'>Chile</option>\n      <option value='CN'>China</option>\n      <option value='CX'>Christmas Island</option>\n      <option value='CC'>Cocos (Keeling) Islands</option>\n      <option value='CO'>Colombia</option>\n      <option value='KM'>Comoros</option>\n      <option value='CG'>Congo</option>\n      <option value='CD'>Congo, the Democratic Republic of the</option>\n      <option value='CK'>Cook Islands</option>\n      <option value='CR'>Costa Rica</option>\n      <option value='CI'>Côte d'Ivoire</option>\n      <option value='HR'>Croatia</option>\n      <option value='CU'>Cuba</option>\n      <option value='CW'>Cura\u00e7ao</option>\n      <option value='CY'>Cyprus</option>\n      <option value='CZ'>Czech Republic</option>\n      <option value='DK'>Denmark</option>\n      <option value='DJ'>Djibouti</option>\n      <option value='DM'>Dominica</option>\n      <option value='DO'>Dominican Republic</option>\n      <option value='EC'>Ecuador</option>\n      <option value='EG'>Egypt</option>\n      <option value='SV'>El Salvador</option>\n      <option value='GQ'>Equatorial Guinea</option>\n      <option value='ER'>Eritrea</option>\n      <option value='EE'>Estonia</option>\n      <option value='ET'>Ethiopia</option>\n      <option value='FK'>Falkland Islands (Malvinas)</option>\n      <option value='FO'>Faroe Islands</option>\n      <option value='FJ'>Fiji</option>\n      <option value='FI'>Finland</option>\n      <option value='FR'>France</option>\n      <option value='GF'>French Guiana</option>\n      <option value='PF'>French Polynesia</option>\n      <option value='TF'>French Southern Territories</option>\n      <option value='GA'>Gabon</option>\n      <option value='GM'>Gambia</option>\n      <option value='GE'>Georgia</option>\n      <option value='DE'>Germany</option>\n      <option value='GH'>Ghana</option>\n      <option value='GI'>Gibraltar</option>\n      <option value='GR'>Greece</option>\n      <option value='GL'>Greenland</option>\n      <option value='GD'>Grenada</option>\n      <option value='GP'>Guadeloupe</option>\n      <option value='GU'>Guam</option>\n      <option value='GT'>Guatemala</option>\n      <option value='GG'>Guernsey</option>\n      <option value='GN'>Guinea</option>\n      <option value='GW'>Guinea-Bissau</option>\n      <option value='GY'>Guyana</option>\n      <option value='HT'>Haiti</option>\n      <option value='HM'>Heard Island and McDonald Islands</option>\n      <option value='VA'>Holy See (Vatican City State)</option>\n      <option value='HN'>Honduras</option>\n      <option value='HK'>Hong Kong</option>\n      <option value='HU'>Hungary</option>\n      <option value='IS'>Iceland</option>\n      <option value='IN'>India</option>\n      <option value='ID'>Indonesia</option>\n      <option value='IR'>Iran, Islamic Republic of</option>\n      <option value='IQ'>Iraq</option>\n      <option value='IE'>Ireland</option>\n      <option value='IM'>Isle of Man</option>\n      <option value='IL'>Israel</option>\n      <option value='IT'>Italy</option>\n      <option value='JM'>Jamaica</option>\n      <option value='JP'>Japan</option>\n      <option value='JE'>Jersey</option>\n      <option value='JO'>Jordan</option>\n      <option value='KZ'>Kazakhstan</option>\n      <option value='KE'>Kenya</option>\n      <option value='KI'>Kiribati</option>\n      <option value='KP'>Korea, Democratic People's Republic of</option>\n      <option value='KR'>Korea, Republic of</option>\n      <option value='KW'>Kuwait</option>\n      <option value='KG'>Kyrgyzstan</option>\n      <option value='LA'>Lao People's Democratic Republic</option>\n      <option value='LV'>Latvia</option>\n      <option value='LB'>Lebanon</option>\n      <option value='LS'>Lesotho</option>\n      <option value='LR'>Liberia</option>\n      <option value='LY'>Libya</option>\n      <option value='LI'>Liechtenstein</option>\n      <option value='LT'>Lithuania</option>\n      <option value='LU'>Luxembourg</option>\n      <option value='MO'>Macao</option>\n      <option value='MK'>Macedonia, the former Yugoslav Republic of</option>\n      <option value='MG'>Madagascar</option>\n      <option value='MW'>Malawi</option>\n      <option value='MY'>Malaysia</option>\n      <option value='MV'>Maldives</option>\n      <option value='ML'>Mali</option>\n      <option value='MT'>Malta</option>\n      <option value='MH'>Marshall Islands</option>\n      <option value='MQ'>Martinique</option>\n      <option value='MR'>Mauritania</option>\n      <option value='MU'>Mauritius</option>\n      <option value='YT'>Mayotte</option>\n      <option value='MX'>Mexico</option>\n      <option value='FM'>Micronesia, Federated States of</option>\n      <option value='MD'>Moldova, Republic of</option>\n      <option value='MC'>Monaco</option>\n      <option value='MN'>Mongolia</option>\n      <option value='ME'>Montenegro</option>\n      <option value='MS'>Montserrat</option>\n      <option value='MA'>Morocco</option>\n      <option value='MZ'>Mozambique</option>\n      <option value='MM'>Myanmar</option>\n      <option value='NA'>Namibia</option>\n      <option value='NR'>Nauru</option>\n      <option value='NP'>Nepal</option>\n      <option value='NL'>Netherlands</option>\n      <option value='NC'>New Caledonia</option>\n      <option value='NZ'>New Zealand</option>\n      <option value='NI'>Nicaragua</option>\n      <option value='NE'>Niger</option>\n      <option value='NG'>Nigeria</option>\n      <option value='NU'>Niue</option>\n      <option value='NF'>Norfolk Island</option>\n      <option value='MP'>Northern Mariana Islands</option>\n      <option value='NO'>Norway</option>\n      <option value='OM'>Oman</option>\n      <option value='PK'>Pakistan</option>\n      <option value='PW'>Palau</option>\n      <option value='PS'>Palestine, State of</option>\n      <option value='PA'>Panama</option>\n      <option value='PG'>Papua New Guinea</option>\n      <option value='PY'>Paraguay</option>\n      <option value='PE'>Peru</option>\n      <option value='PH'>Philippines</option>\n      <option value='PN'>Pitcairn</option>\n      <option value='PL'>Poland</option>\n      <option value='PT'>Portugal</option>\n      <option value='PR'>Puerto Rico</option>\n      <option value='QA'>Qatar</option>\n      <option value='RE'>Réunion</option>\n      <option value='RO'>Romania</option>\n      <option value='RU'>Russian Federation</option>\n      <option value='RW'>Rwanda</option>\n      <option value='BL'>Saint Barthélemy</option>\n      <option value='SH'>Saint Helena, Ascension and Tristan da Cunha</option>\n      <option value='KN'>Saint Kitts and Nevis</option>\n      <option value='LC'>Saint Lucia</option>\n      <option value='MF'>Saint Martin (French part)</option>\n      <option value='PM'>Saint Pierre and Miquelon</option>\n      <option value='VC'>Saint Vincent and the Grenadines</option>\n      <option value='WS'>Samoa</option>\n      <option value='SM'>San Marino</option>\n      <option value='ST'>Sao Tome and Principe</option>\n      <option value='SA'>Saudi Arabia</option>\n      <option value='SN'>Senegal</option>\n      <option value='RS'>Serbia</option>\n      <option value='SC'>Seychelles</option>\n      <option value='SL'>Sierra Leone</option>\n      <option value='SG'>Singapore</option>\n      <option value='SX'>Sint Maarten (Dutch part)</option>\n      <option value='SK'>Slovakia</option>\n      <option value='SI'>Slovenia</option>\n      <option value='SB'>Solomon Islands</option>\n      <option value='SO'>Somalia</option>\n      <option value='ZA'>South Africa</option>\n      <option value='GS'>South Georgia and the South Sandwich Islands</option>\n      <option value='SS'>South Sudan</option>\n      <option value='ES'>Spain</option>\n      <option value='LK'>Sri Lanka</option>\n      <option value='SD'>Sudan</option>\n      <option value='SR'>Suriname</option>\n      <option value='SJ'>Svalbard and Jan Mayen</option>\n      <option value='SZ'>Swaziland</option>\n      <option value='SE'>Sweden</option>\n      <option value='CH'>Switzerland</option>\n      <option value='SY'>Syrian Arab Republic</option>\n      <option value='TW'>Taiwan, PoC</option>\n      <option value='TJ'>Tajikistan</option>\n      <option value='TZ'>Tanzania, United Republic of</option>\n      <option value='TH'>Thailand</option>\n      <option value='TL'>Timor-Leste</option>\n      <option value='TG'>Togo</option>\n      <option value='TK'>Tokelau</option>\n      <option value='TO'>Tonga</option>\n      <option value='TT'>Trinidad and Tobago</option>\n      <option value='TN'>Tunisia</option>\n      <option value='TR'>Turkey</option>\n      <option value='TM'>Turkmenistan</option>\n      <option value='TC'>Turks and Caicos Islands</option>\n      <option value='TV'>Tuvalu</option>\n      <option value='UG'>Uganda</option>\n      <option value='UA'>Ukraine</option>\n      <option value='AE'>United Arab Emirates</option>\n      <option value='GB'>United Kingdom</option>\n      <option value='US'>United States</option>\n      <option value='UM'>United States Minor Outlying Islands</option>\n      <option value='UY'>Uruguay</option>\n      <option value='UZ'>Uzbekistan</option>\n      <option value='VU'>Vanuatu</option>\n      <option value='VE'>Venezuela, Bolivarian Republic of</option>\n      <option value='VN'>Viet Nam</option>\n      <option value='VG'>Virgin Islands, British</option>\n      <option value='VI'>Virgin Islands, U.S.</option>\n      <option value='WF'>Wallis and Futuna</option>\n      <option value='EH'>Western Sahara</option>\n      <option value='YE'>Yemen</option>\n      <option value='ZM'>Zambia</option>\n      <option value='ZW'>Zimbabwe</option>\n    </select>\n  </span>\n  <span class='col'>\n    <span class='field'>\n      <label for='email'>Email</label>\n      <input id='email' name='email' type='email' disabled='disabled'>\n    </span>\n    <span class='field'>\n      <label for='phone'>Phone</label>\n      <input id='phone' name='phone' type='text'>\n    </span>\n    <span class='field'>\n      <label for='mobile'>Mobile</label>\n      <input id='mobile' name='mobile phone' type='text'>\n    </span>\n  </span>\n</p>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['entries/edit_payment'] = function(context) {
    return (function() {
      var $c, $e, $o;
      $e = function(text, escape) {
        return ("" + text).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/'/g, '&#39;').replace(/\//g, '&#47;').replace(/"/g, '&quot;');
      };
      $c = function(text) {
        switch (text) {
          case null:
          case void 0:
            return '';
          case true:
          case false:
            return '' + text;
          default:
            return text;
        }
      };
      $o = [];
      $o.push("<h3 class='secure'>\n  Payment details\n</h3>\n<p class='onecol'>\n  <span class='col'>\n    <label for='card_number'>\n      Card number\n      <span class='amex card'></span>\n      <span class='card mastercard'></span>\n      <span class='card visa'></span>\n    </label>\n    <input id='card_number' type='text' placeholder='Just the numbers, please'>\n  </span>\n</p>\n<p class='threecol'>\n  <span class='col'>\n    <label for='expiry_month'>Expires</label>\n    <input class='month' id='expiry_month' name='expiry-month' type='text' limit='" + ($e($c(2))) + "' placeholder='MM'>\n    <input class='year' id='expiry_year' name='expiry-year' type='text' limit='" + ($e($c(4))) + "' placeholder='YY'>\n  </span>\n  <span class='col'>\n    <label for='cvc'>CVC</label>\n    <input class='cvc' id='cvc' name='cvc' type='text' limit='" + ($e($c(3))) + "' placeholder='123'>\n  </span>\n  <span class='col'>\n    <br>\n    <a class='button create'>Enter race</a>\n  </span>\n</p>\n<p>\n  <span class='error_message'></span>\n</p>");
      return $o.join("\n").replace(/\s([\w-]+)='true'/mg, ' $1').replace(/\s([\w-]+)='false'/mg, '').replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['entries/my_entry'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<a class='big close'></a>\n<h2>\n  My entry:\n  <a class='race_name'></a>\n  <span class='instance_name'></span>\n</h2>\n<p>\n  You have entered\n  <span class='race_name'></span>\n  <span class='instance_name'></span>\n  \. You can see yourself in the entry list\n  <a class='entry_list'>here</a>\n  \, but if the entry is brand new, you may need to reload the page.\n</p>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['entries/new'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<p>\n  Please check that the details shown below are correct and fill in anything that we don't know yet.\n  All your answers will be remembered for next time.\n</p>\n<form>\n  <section class='competitor'></section>\n  <section class='affirmation'>\n    <p>\n      Please read the following carefully and then check the box below to indicate your agreement:\n    </p>\n    <ul>\n      <li>\n        I accept the hazards inherent in fell running and acknowledge that I am entering and running this race at my own risk. \n      </li>\n      <li>\n        I confirm that I am aware of the rules imposed on me by the Race Organiser and that I will comply with them. \n      </li>\n      <li>\n        I confirm that I have read and will comply with the \n        <a href='http://fellrunner.org.uk/pdf/committee/14_Competitors_Safety_Rules_and_Equipment.pdf' target='_blank'>\n          Fell Running - Requirements for Runners. \n        </a>\n      </li>\n      <li>\n        I acknowledge and agree that I am responsible for determining whether I have the skills equipment and fitness to participate in this event. \n      </li>\n      <li>\n        I accept that neither the Race Organiser nor the Fell Runners Association shall be liable to me for any injury, loss or damage of any nature to me or my property arising out of my participation in this race (other than in respect of death or personal injury as a result of their negligence).\n      </li>\n    </ul>\n  </section>\n  <p>\n    Please also note that purchases on fellrace.org.uk are not refundable except at the discretion of the race organiser.\n    See our \n    <a href='/faq/terms'>terms and conditions </a>\n    for more information.\n  </p>\n  <p>\n    <input id='terms_accepted' type='checkbox'>\n    <label class='warning' for='terms_accepted'>I understand and accept these terms</label>\n  </p>\n  <section class='contact'>\n    <p class='emergency twocol'>\n      <span class='col'>\n        <label for='emergency_contact'>Emergency contact on the day</label>\n        <input id='emergency_contact_name' type='text'>\n      </span>\n      <span class='col last'>\n        <label for='emergency_contact_phone'>Phone number</label>\n        <input id='emergency_contact_phone' type='text'>\n      </span>\n    </p>\n  </section>\n  <section class='payment'></section>\n  <p class='footnote'>\n    Your card will be charged a total of\n    <strong>\n      <span class='currency' id='amount'></span>\n    </strong>\n    which includes a processing fee of \n    <span class='currency' id='deduction'></span>\n    See the\n    <a href='/faq/online_entries'>online payments page</a>\n    for details of where that goes.\n  </p>\n  <p class='warning'>\n    We're going to change this form soon so that you can enter more than one race and buy entries for other people.\n    That should happen over Christmas. If anything else goes wrong or should work better, please\n    <a href='mailto:will@spanner.org'>let Will know</a>\n    right away.\n  </p>\n</form>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['entries/no_entry_row'] = function(context) {
    return (function() {
      var $c, $e, $o;
      $e = function(text, escape) {
        return ("" + text).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/'/g, '&#39;').replace(/\//g, '&#47;').replace(/"/g, '&quot;');
      };
      $c = function(text) {
        switch (text) {
          case null:
          case void 0:
            return '';
          case true:
          case false:
            return '' + text;
          default:
            return text;
        }
      };
      $o = [];
      $o.push("<td colspan='" + ($e($c(5))) + "'>\n  <span class='waiter'>\n    Either this is still loading or you have no entries yet.\n  </span>\n</td>");
      return $o.join("\n").replace(/\s([\w-]+)='true'/mg, ' $1').replace(/\s([\w-]+)='false'/mg, '').replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['entries/row'] = function(context) {
    return (function() {
      var $c, $e, $o;
      $e = function(text, escape) {
        return ("" + text).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/'/g, '&#39;').replace(/\//g, '&#47;').replace(/"/g, '&quot;');
      };
      $c = function(text) {
        switch (text) {
          case null:
          case void 0:
            return '';
          case true:
          case false:
            return '' + text;
          default:
            return text;
        }
      };
      $o = [];
      $o.push("<td class='name'>\n  <a class='name'>\n    <span class='fore'></span>\n    <span class='sur'></span>\n  </a>\n</td>\n<td class='cat'></td>\n<td class='club' colspan='" + ($e($c(2))) + "'></td>");
      return $o.join("\n").replace(/\s([\w-]+)='true'/mg, ' $1').replace(/\s([\w-]+)='false'/mg, '').replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['entries/table'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<thead>\n  <tr>\n    <th>name</th>\n    <th>cat</th>\n    <th>club</th>\n    <th>\n      <input class='filter' type='text' name='filter' placeholder='Filter...'>\n    </th>\n  </tr>\n</thead>\n<tbody></tbody>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['index'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<div class='head'>\n  <div class='home picture'></div>\n  <div class='title'>\n    <h2 class='name on_picture'>\n      Welcome!\n    </h2>\n  </div>\n</div>\n<div class='welcome'>\n  <div class='getting_started'>\n    <p>\n      <strong>\n        fellrace.org.uk\n      </strong>\n      provides free sites for fell races.\n      Each race gets an address like\n      <a class='sample' href='/races/caw'>caw.fellrace.org.uk</a>\n      and a set of editing and map-drawing tools that will get you up and running in a few minutes.\n      It&rsquo;s built purely for fell races, by \n      <a href='/faq/about'>three fell runners</a>\n      who like maps and are trying very hard to avoid doing their real work.\n    </p>\n    <p class='get_yours'>\n      <a class='sign_up_for_event'>\n        Get your race page here\n        &#9656;\n      </a>\n    </p>\n  </div>\n  <div id='instances'>\n    <h2>Coming up</h2>\n    <div id='future_instances'></div>\n    <h2>Recent</h2>\n    <div id='past_instances'></div>\n  </div>\n</div>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['instances/add_results'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("This is where you upload your results.\nPlease save them as a CSV file with column headers in the top row.\n<a class='add add_instance'>\n  upload a file\n</a>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['instances/admin_entries_import'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<label class='microbutton upload' for='entries_file'>▲ import</label>\n<input class='file' id='entries_file' type='file' style='display:none' accept='text/csv'>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['instances/admin_future_list_item'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<a class='name'></a>\n<span class='date'></span>\n<span class='time'></span>\n<span class='note total_entries'></span>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['instances/admin_future'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<a class='close'></a>\n<div class='header'>\n  <h2>\n    <a class='race_name'></a>\n    <span class='instance_name'></span>\n  </h2>\n  <div class='date_and_time'>\n    <p>\n      Race date:\n      <span class='calendar'></span>\n      <span class='date race_date'></span>\n      at\n      <span class='clock'></span>\n      <span class='editable time' data-attributes='time' data-placeholder='hh:mm'></span>\n      <br>\n      <input id='limited_entry' type='checkbox'>Entry limit:</input>\n      <span class='editable entry_limit' data-placeholder='e.g. 500'></span>\n    </p>\n  </div>\n</div>\n<div class='dashboard'>\n  <div class='row'>\n    <div class='block ct-chart entries_chart'>\n      <span class='centered total total_count'></span>\n    </div>\n    <div class='block categories_chart ct-chart double'></div>\n  </div>\n  <div class='row'>\n    <div class='income'>\n      <h4>\n        Online income:\n      </h4>\n      <p>\n        <span class='online_total_income verylarge'></span>\n        <span class='online_total_fee'></span>\n      </p>\n    </div>\n    <h4>\n      <a class='more toggle' data-toggle='.entry_config'>\n        Entry configuration\n      </a>\n    </h4>\n  </div>\n  <div class='entry_config toggled'>\n    <div class='row'>\n      <div class='block narrow online optional'>\n        <p>\n          <input id='eod' type='checkbox'>\n          <label for='eod'>Entry on the day</label>\n        </p>\n        <p class='eod_details'>\n          Entry fee:\n          <span class='currency editable eod_fee' data-placeholder='0.00'></span>\n        </p>\n      </div>\n      <div class='block narrow optional postal'>\n        <p>\n          <input id='postal_entry' type='checkbox'>\n          <label for='postal_entry'>Postal entry</label>\n        </p>\n        <div class='postal_details'>\n          <p>\n            <span class='date postal_entry_opening'></span>\n            to\n            <br>\n            <span class='date postal_entry_closing'></span>\n          </p>\n          <p class='fee'>\n            Postal fee:\n            <span class='currency editable postal_entry_fee' data-placeholder='0.00'></span>\n          </p>\n          <p class='entry_form'></p>\n        </div>\n      </div>\n      <div class='block narrow online optional'>\n        <p>\n          <input id='online_entry' type='checkbox'>\n          <label for='online_entry'>Online entry</label>\n          <sup class='warning'>\n            testing\n          </sup>\n        </p>\n        <div class='online_details'>\n          <p>\n            <span class='date online_entry_opening'></span>\n            to\n            <br>\n            <span class='date online_entry_closing'></span>\n          </p>\n          <p>\n            Online fee:\n            <span class='currency editable online_entry_fee' data-placeholder='0.00'></span>\n          </p>\n        </div>\n      </div>\n    </div>\n    <div class='category_picker'></div>\n  </div>\n</div>\n<div class='entries'>\n  <div class='controls'>\n    <span class='entries_import'></span>\n    <span>\n      <a class='autodownload microbutton'>▼ for AutoDownload</a>\n    </span>\n    <span>\n      <a class='export_multisport microbutton'>▼ for MultiSport</a>\n    </span>\n    <span>\n      <a class='export_all microbutton'>▼ CSV data</a>\n    </span>\n  </div>\n  <h2>\n    Entries\n  </h2>\n  <div class='all_entries'>\n    <table class='entries'></table>\n    <h3>Withdrawn entries</h3>\n    <table class='cancelled_entries'></table>\n  </div>\n</div>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['instances/admin_past_list_item'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<a class='name'></a>\n<span class='note total'></span>\n<span class='splits'></span>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['instances/admin_past'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<a class='big close'></a>\n<h2>\n  <a class='race_name'></a>\n  <span class='instance_name'></span>\n</h2>\n<h3>\n  <span class='calendar'></span>\n  <span class='date'></span>\n  at\n  <span class='clock'></span>\n  <span class='editable time' data-placeholder='hh:mm'></span>\n</h3>\n<div class='report'>\n  <h3>Race report</h3>\n  <p class='editable report' data-placeholder='Please give a report of up to 200 words. This will appear at the top of your results list.'></p>\n  <p class='note'>\n    (This is a good place to prepare your report for the Fellrunner)\n  </p>\n</div>\n<input id='excluded' name='excluded' type='checkbox'>\n<label class='excluded' for='excluded'>Exclude from records</label>\n<span class='note'>(tick if a short/alternative course was run)</span>\n<div class='results'>\n  <h3>Results</h3>\n  <div class='results_file'></div>\n  <div class='results_preview'></div>\n</div>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['instances/admin_postal_entry_form'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<input class='file' id='picker' type='file' accept='application/pdf'>\n<label class='pick' for='picker'>Upload entry form</label>\n<span class='nofile note'>PDFs only please</span>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['instances/category_entry_size'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<td>\n  <span class='name'></span>\n</td>\n<td>\n  <span class='size'></span>\n</td>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['instances/club_size'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<td>\n  <span class='name'></span>\n</td>\n<td>\n  <span class='size'></span>\n</td>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['instances/enter'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<a class='big close'></a>\n<h2>\n  Enter race:\n  <a class='race_name'></a>\n  <span class='instance_name'></span>\n</h2>\n<section class='entry'></section>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['instances/future_list_item'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<a class='name'></a>\n<span class='date'></span>\n<span class='time'></span>\n<span class='note total'></span>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['instances/future'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<a class='big close'></a>\n<h2>\n  <a class='race_name'></a>\n  <span class='instance_name'></span>\n  <a class='edit microbutton'>edit</a>\n</h2>\n<div class='basic_details'>\n  <span class='date race_date'></span>\n  at\n  <span class='time'></span>\n  <br>\n  Entries:\n  <span class='entry_count'></span>\n  <span class='limit'>\n    of the allowed\n    <span class='entry_limit'></span>\n  </span>\n</div>\n<div class='dashboard'>\n  <div class='row'>\n    <div class='block clubs_chart ct-chart'>\n      <span class='centered total total_count'></span>\n    </div>\n    <div class='block categories_chart ct-chart double'></div>\n  </div>\n</div>\n<p class='full'>\n  <span class='warning'>This race is full! No more entries will be accepted.</span>\n</p>\n<div class='not_full'>\n  <p class='eod'>\n    <span class='heading'>Entry on the day:</span>\n    <span class='currency eod_fee'></span>\n  </p>\n  <p class='postal'>\n    <span class='heading'>Postal entry:</span>\n    <span class='currency postal_entry_fee'></span>\n    <span>\n      from\n      <span class='date postal_entry_opening'></span>\n      to\n      <span class='date postal_entry_closing'></span>\n    </span>\n    <a class='entry_form file_icon pdf' target='_blank'>download form</a>\n  </p>\n  <p class='online'>\n    <span class='heading'>Online entry:</span>\n    <span class='currency online_entry_fee'></span>\n    <span>\n      from\n      <span class='date online_entry_opening'></span>\n      to\n      <span class='date online_entry_closing'></span>\n    </span>\n    <a class='button enter'>enter</a>\n  </p>\n</div>\n<div class='entries'>\n  <h3>\n    Entries\n  </h3>\n  <table class='entries'></table>\n</div>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['instances/index/future'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<a class='race_link'>\n  <span class='profile'></span>\n  <span class='race_name'></span>\n  <span class='date'></span>\n  <a class='online_entries opener'>Online entries open</a>\n</a>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['instances/index/past'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<a class='race_link'>\n  <span class='profile'></span>\n  <span class='race_name'></span>\n  <span class='date'></span>\n</a>\n<a class='opener results_link'>\n  results\n</a>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['instances/new'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<a class='close'></a>\n<h2>\n  <span class='race_name'></span>\n</h2>\n<p class='twocol'>\n  <span class='col date'>\n    <label for='date'>Date</label>\n    <input class='date' id='date' type='text' name='date' placeholder='DD MMM YYYY'>\n  </span>\n  <span class='col name'>\n    <label for='name'>Name</label>\n    <input id='name' type='text' name='name' placeholder='name'>\n  </span>\n</p>\n<p class='name onecol'>\n  <span class='col'>\n    <span class='error_message taken'>There is already a race with this name.</span>\n    <span class='info name_info'>\n      <span>Please enter a name for the race. The year</span>\n      <span class='year'></span>\n      will probably do.\n    </span>\n  </span>\n</p>\n<p>\n  <a class='button cancel'>Cancel</a>\n  <a class='button save'>Save and continue</a>\n</p>\n<p class='club'></p>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['instances/past_list_item'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<a class='name opener'></a>\n<span class='note total'></span>\n<span class='splits'></span>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['instances/results_file'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<span class='file_name'></span>\n<input class='file' id='picker' type='file' accept='.csv' style='display:none;'>\n<label class='button pick' for='picker'>\n  Upload CSV results file\n</label>\n<div class='confirmation'>\n  <span class='filestatus'></span>\n  <span class='filename'></span>\n  <br>\n  <span class='filesize'></span>\n</div>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['instances/results_preview'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<table id='results_table'></table>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['instances/results'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<a class='big close'></a>\n<h2>\n  <a class='race_name'></a>\n  <span class='instance_name'></span>\n  <a class='edit microbutton'>edit</a>\n  <a class='addendum show_splits'>\n    show splits\n  </a>\n  <a class='addendum hide_splits'>\n    hide splits\n  </a>\n  <input class='filter' type='text' name='filter' placeholder='Filter...'>\n</h2>\n<div id='results_file'>\n  <p class='download'>\n    <a class='file_icon'></a>\n  </p>\n</div>\n<p class='summary'></p>\n<table id='results_table'></table>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['instances/show'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("Date\n<span class='day'></span>\n\-\n<span class='month'></span>\n\-\n<span class='year'></span>\nTime\n<span class='time'></span>\n<div id='past'>\n  <div class='results'>\n    <h3>Results</h3>\n    <span class='info total'></span>\n  </div>\n  <div class='report'>\n    <h3>Report</h3>\n    <p class='report'></p>\n  </div>\n</div>\n<div id='future'>\n  <div id='entry_details'>\n    <div class='fee'>\n      Fee\n      <span class='entry_fee'></span>\n    </div>\n    <div class='limit'>\n      Limit\n      <span class='entry_limit'></span>\n    </div>\n    <div class='opening'>\n      Entries open on\n      <span class='entry_opening'></span>\n    </div>\n    <div class='closing'>\n      Entries close on\n      <span class='entry_closing'></span>\n    </div>\n    <div class='entries'></div>\n  </div>\n</div>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['links/admin_list_item'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<span class='editable title' data-placeholder='text'></span>\n<span class='note'></span>\n: \n<span class='editable url' data-placeholder='www.example.com'></span>\n<a class='delete'>\u232B</a>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['links/empty'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("Click 'add' to add one or more external links here, or enter an id below for an automatic link to that site.\n<a class='add add_link'>\n  add a link\n</a>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['links/list_item'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<a class='title'></a>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['map'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<div class='map_holder'></div>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['pages/about'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<div class='head'>\n  <div class='home picture'></div>\n  <div class='title'>\n    <h2 class='name on_picture'>\n      About fellrace\n    </h2>\n  </div>\n</div>\n<div class='body'>\n  <div class='page'>\n    <p>\n      Fellrace.org.uk is the creation of \n      <a href='/runners/9765'>Will, </a>\n      <a href='/runners/1404'>Mike</a>\n      and\n      <a href='/runners/469'>Anna</a>\n      at \n      <a href='http://spanner.org'>Spanner.</a>\n      Our real work is making esoteric web machinery for academic, scientific and charity clients\n      all over the world, but we're all devoted fell runners and this is the nice side \n      project where we get to work on what we love and try out new stuff.*\n    </p>\n    <p>\n      We all run for \n      <a href='http://bcrunners.org.uk'>Black Combe,</a>\n      the most serious and widely-envied of fell clubs, \n      and we also think it's important that we do what we can for the less fortunate fell runner.\n    </p>\n    <p>\n      Spanner is based in a small barn in the South Lakes and the office always contains as many dogs as people.\n      If you need a really nice simple machine, or a collation engine for a million concurrent mobile clients, come and see us.\n    </p>\n    <p>\n      <br>\n      <br>\n      * The new stuff sometimes breaks. We are notified automatically of any major failure, but please \n      <a href='mailto:fellrace@spanner.org'>let us know</a>\n      anyway.\n    </p>\n  </div>\n</div>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['pages/online_entries'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<div class='head'>\n  <div class='home picture'></div>\n  <div class='title'>\n    <h2 class='name on_picture'>\n      Online entries\n    </h2>\n  </div>\n</div>\n<div class='body'>\n  <p>\n    Any race can be enabled for online entries. \n    All you have to do is visit the page for this year's race, tick the 'online entries' box and give a start and end date.\n    The dates will default to 'today' and 'about a week before the race', so you can probably start receiving online entries in two or three clicks.\n  </p>\n  <p>\n    You can also add entries manually and take entries on the day, and you can set different entry fees for each channel.\n  </p>\n  <h3>\n    Stripe\n  </h3>\n  <p>\n    Credit card transactions are handled for us by \n    <a href='https://stripe.com'>stripe.com. </a>\n  </p>\n  <p>\n    In the basic setup, entry fees flow into our holding account and we pass them on by bank transfer just after the closing date for online entries.\n    It is also possible, and very easy, to set up your own stripe account. In that case we can send the money straight to you.\n    It takes about seven days to get through.\n  </p>\n  <h3>\n    Fees and deductions\n  </h3>\n  <p>\n    Stripe takes 2.4% of the total charge plus a 20p flat fee. Fellrace.org.uk (that is, Spanner Ltd, the company that makes the site) takes 2.5%. \n    It works out like this:\n  </p>\n  <table>\n    <thead>\n      <tr>\n        <th>\n          Race fee\n        </th>\n        <th>\n          to stripe\n        </th>\n        <th>\n          to fellrace\n        </th>\n        <th>\n          to organiser\n        </th>\n      </tr>\n    </thead>\n    <tbody>\n      <tr>\n        <td>\n          £3.00\n        </td>\n        <td>\n          27p\n        </td>\n        <td>\n          8p\n        </td>\n        <td>\n          £2.65\n        </td>\n      </tr>\n      <tr>\n        <td>\n          £7.00\n        </td>\n        <td>\n          37p\n        </td>\n        <td>\n          18p\n        </td>\n        <td>\n          £6.45\n        </td>\n      </tr>\n      <tr>\n        <td>\n          £15.00\n        </td>\n        <td>\n          56p\n        </td>\n        <td>\n          38p\n        </td>\n        <td>\n          £14.07\n        </td>\n      </tr>\n      <tr>\n        <td>\n          £35.00\n        </td>\n        <td>\n          £1.04\n        </td>\n        <td>\n          88p\n        </td>\n        <td>\n          £33.09\n        </td>\n      </tr>\n    </tbody>\n  </table>\n  <p>\n    We're not going to become immensely rich but it might help to offset the cost of running the site.\n  </p>\n  <p>\n    Please refer to the \n    <a href='/faq/terms'>terms and conditions</a>\n    that will apply to race entries bought through this site. \n    The short version is that there are no refunds unless you, the organiser, decide to make one. \n    In that case you probably want to refund only the part that comes to you.\n  </p>\n</div>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['pages/terms'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<div class='head'>\n  <div class='home picture'></div>\n  <div class='title'>\n    <h2 class='name on_picture'>\n      Terms and Conditions\n    </h2>\n  </div>\n</div>\n<div class='body'>\n  <div class='page'>\n    <p>\n      By using this site and by entering a race you will be deemed to have accepted these terms.\n    </p>\n    <h3>\n      Online entries\n    </h3>\n    <ul>\n      <li>\n        When you enter a race, fellrace.org.uk is acting as an agent for the organiser.\n      </li>\n      <li>\n        Race entries are not refundable except at the discretion of the race organiser.\n      </li>\n      <li>\n        Race entries are not transferrable unless the race organiser decides to permit it, \n        and may only be transferrable within a club.\n      </li>\n      <li>\n        All race entry forms include the current standard FRA disclaimers and warnings. \n        By entering a race through fellrace.org.uk you affirm your acceptance of those conditions.\n      </li>\n    </ul>\n    <h3>\n      Race sites\n    </h3>\n    <ul>\n      <li>\n        All text, images, routes and other information uploaded to fellrace.org.uk is deemed to have been released \n        under the\n        <a href='http://creativecommons.org/licenses/by-sa/4.0/'>Attribution-ShareAlike 4.0 International</a>\n        creative commons license. Basically, people can do whatever they like with your information \n        but they are supposed to credit fellrace.org.uk when they do it, and they are not allowed to prevent other people from sharing it.\n      </li>\n      <li>\n        fellrace.org.uk is acting as a publishing intermediary for the fell race organiser. \n        We accept no liability for any libellous, scandalous or mischievious remarks.\n        We do not scrutinise race pages for accuracy, usefulness or legality.\n      </li>\n      <li>\n        fellrace.org.uk accepts no liability for your navigational errors either\n      </li>\n      <li>\n        or from any other injury, inconvenience or death that arises from trying to follow our routes or do what it says on our pages.\n        You are responsible for scrutinising the information provided here, assessing your own ability and preparedness and attending to your own safety.\n      </li>\n      <li>\n        The maps appearing on this site are copyright Ordnance Survey, or other providers as marked on the map.\n      </li>\n    </ul>\n  </div>\n</div>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['performances/checkpoint_cell'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<span class='elapsed'></span>\n<span class='split'></span>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['performances/competitor_table'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<table class='performances'>\n  <thead>\n    <tr>\n      <th>Date</th>\n      <th>Race</th>\n      <th>Time</th>\n      <th>Pos</th>\n    </tr>\n  </thead>\n  <tbody></tbody>\n</table>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['performances/graph_line'] = function(context) {
    return (function() {
      var $c, $e, $o;
      $e = function(text, escape) {
        return ("" + text).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/'/g, '&#39;').replace(/\//g, '&#47;').replace(/"/g, '&quot;');
      };
      $c = function(text) {
        switch (text) {
          case null:
          case void 0:
            return '';
          case true:
          case false:
            return '' + text;
          default:
            return text;
        }
      };
      $o = [];
      $o.push("<path class='performance' d='" + ($e($c(this.path))) + "'></path>");
      return $o.join("\n").replace(/\s([\w-]+)='true'/mg, ' $1').replace(/\s([\w-]+)='false'/mg, '').replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['performances/history_loading'] = function(context) {
    return (function() {
      var $c, $e, $o;
      $e = function(text, escape) {
        return ("" + text).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/'/g, '&#39;').replace(/\//g, '&#47;').replace(/"/g, '&quot;');
      };
      $c = function(text) {
        switch (text) {
          case null:
          case void 0:
            return '';
          case true:
          case false:
            return '' + text;
          default:
            return text;
        }
      };
      $o = [];
      $o.push("<td colspan='" + ($e($c(7))) + "'>\n  <h3 class='working'>\n    Please wait: loading the full race history takes a little while.\n  </h3>\n</td>");
      return $o.join("\n").replace(/\s([\w-]+)='true'/mg, ' $1').replace(/\s([\w-]+)='false'/mg, '').replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['performances/history_row'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<td class='pos'>\n  <span class='pos'></span>\n  <span class='comp_pos'></span>\n</td>\n<td class='name'>\n  <a class='name'>\n    <span class='forename'></span>\n    <span class='middlename'></span>\n    <span class='surname'></span>\n  </a>\n</td>\n<td class='club'>\n  <span class='club'></span>\n</td>\n<td class='cat'>\n  <span class='cat'></span>\n</td>\n<td class='race_position'>\n  <span class='race_position'></span>\n</td>\n<td class='time'>\n  <span class='time'></span>\n</td>\n<td class='instance'>\n  <span class='instance'></span>\n</td>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['performances/history_table'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<thead>\n  <tr>\n    <th class='pos'>\n      Pos\n    </th>\n    <th class='name'>\n      Name\n    </th>\n    <th class='club'>\n      Club\n    </th>\n    <th class='cat'>\n      Category\n    </th>\n    <th class='race_position'>\n      Race pos\n    </th>\n    <th class='time'>\n      Time\n    </th>\n    <th class='instance'>\n      Year\n    </th>\n  </tr>\n</thead>\n<tbody></tbody>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['performances/name_cell'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<a class='name'></a>\n<span class='name'></span>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['performances/result_row'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<td class='pos'>\n  <span class='pos'></span>\n</td>\n<td class='name'>\n  <span class='name'></span>\n  <a class='name'></a>\n</td>\n<td class='club'>\n  <span class='club'></span>\n  <a class='club'></a>\n</td>\n<td class='cat'>\n  <span class='cat'></span>\n</td>\n<td class='time'>\n  <span class='time'></span>\n</td>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['performances/results_table'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<thead>\n  <tr class='columns'>\n    <th class='pos'>\n      <a class='pos' data-sort='pos'>Pos</a>\n    </th>\n    <th class='name'>\n      <a class='name' data-sort='name'>Name</a>\n    </th>\n    <th class='club'>\n      <a class='club' data-sort='club'>Club</a>\n    </th>\n    <th class='cat'>\n      <a class='cat' data-sort='cat'>Category</a>\n    </th>\n    <th class='time'>\n      <a class='time' data-sort='time'>Time</a>\n    </th>\n  </tr>\n</thead>\n<tbody></tbody>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['performances/row'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<td>\n  <span class='date'></span>\n</td>\n<td>\n  <span class='race_name'></span>\n</td>\n<td>\n  <a class='time'>\n    <span class='time'></span>\n  </a>\n</td>\n<td>\n  <span class='pos'></span>\n  <span class='total'></span>\n</td>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['performances/time_cell'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<span class='time'></span>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['publications/entry'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<div id='eventhead'>\n  <h1>\n    <a id='name'></a>\n  </h1>\n</div>\n<div id='eventbody'>\n  <div id='instances'></div>\n</div>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['publications/external'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<div id='eventbody'>\n  <div id='event_details'>\n    <div id='description'></div>\n  </div>\n  <div class='races'>\n    <div class='races_list'></div>\n  </div>\n</div>\n<div id='credit'>\n  <p>\n    Map and data provided by\n    <a class='fellrace' href='http://fellrace.org.uk/'>\n      fellrace.org.uk.\n    </a>\n  </p>\n</div>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['publications/list_item'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<h3>\n  <a class='event' href='#'>\n    <span class='profile'></span>\n    <span class='name'></span>\n  </a>\n  <span class='date note'></span>\n</h3>\n<p>\n  <span class='intro'></span>\n  <!-- %a.marker -->\n  <!--   \u25B3 -->\n</p>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['publications/list'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<h1 class='title'></h1>\n<div class='publications'></div>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['publications/race_details'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<strong>\n  <span class='cat'></span>\n</strong>\n<span class='distance'></span>\nkm \u2192\n<span class='climb'></span>\nm \u2191");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['publications/show'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<div id='eventhead'>\n  <h1 id='name'></h1>\n  <div id='eventcontrols'>\n    <a class='edit'>\n      Edit\n    </a>\n    <a class='publish'>\n      Publish &raquo;\n    </a>\n    <a class='enter'>\n      Enter &raquo;\n    </a>\n  </div>\n</div>\n<div id='eventbody'>\n  <div id='event_details'>\n    <p class='date'>\n      <span class='next'>Next</span>\n      race:\n      <strong id='event_date'></strong>\n    </p>\n    <div id='description'></div>\n  </div>\n  <div class='races'>\n    <div class='races_list'></div>\n  </div>\n</div>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['race_publications/entry'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<div class='head'>\n  <div class='main_info'>\n    <div class='race_title title'>\n      <h2 class='name'></h2>\n    </div>\n  </div>\n</div>\n<div class='race_body'></div>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['race_publications/external'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<div class='head'>\n  <div class='profile'>\n    <span class='race_profile'>\n      1,1,1,1\n    </span>\n  </div>\n  <div class='main_info'>\n    <div class='race_title title'>\n      <h2>\n        <a class='opener'>\n          <span class='name'></span>\n        </a>\n        <span class='subtitle'>\n          <span class='distance'></span>\n          km /\n          <span class='climb'></span>\n          m\n        </span>\n      </h2>\n    </div>\n  </div>\n</div>\n<div class='race_body'>\n  <div class='description'></div>\n  <div class='details'>\n    <div class='attachments'>\n      <ul class='attachments'></ul>\n    </div>\n    <div class='checkpoints'>\n      <h4>\n        Checkpoints\n      </h4>\n      <ul class='checkpoints'></ul>\n    </div>\n    <div class='records'>\n      <h4>\n        Records\n      </h4>\n      <ul class='records'></ul>\n    </div>\n  </div>\n</div>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "").replace(/[\s\n]*\u0091/mg, '').replace(/\u0092[\s\n]*/mg, '');
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['race_publications/history'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<a class='big close'></a>\n<h2>\n  <a class='race_name'></a>\n  <span>\n    all-time results\n  </span>\n  <span class='addendum since'></span>\n  <input class='filter' type='text' name='filter' placeholder='Filter...'>\n</h2>\n<p>\n  <span class='all_runs'>\n    Showing all\n    <span class='performances_count'></span>\n    performances\n    <a class='addendum compact'>(show the best time for each runner)</a>\n  </span>\n  <span class='all_runners'>\n    Showing\n    <span class='competitors_count'></span>\n    personal bests\n    <a class='addendum full'>(show every performance)</a>\n  </span>\n  <p>\n    Results from alternative (bad weather/winter) courses are excluded from this table.\n  </p>\n</p>\n<table class='history'>\n  <thead>\n    <tr>\n      <th class='pos'>\n        Pos\n      </th>\n      <th class='name'>\n        Name\n      </th>\n      <th class='club'>\n        Club\n      </th>\n      <th class='cat'>\n        Category\n      </th>\n      <th class='race_position'>\n        Race pos\n      </th>\n      <th class='time'>\n        Time\n      </th>\n      <th class='instance'>\n        Year\n      </th>\n    </tr>\n  </thead>\n  <tbody class='history'></tbody>\n</table>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['race_publications/index_item'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<a class='race_link'>\n  <span class='profile'></span>\n  <span class='name'></span>\n</a>\n<div class='owner'>\n  <a class='edit'>edit</a>\n</div>\n<p class='intro'></p>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['race_publications/index'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<div class='head'>\n  <div class='home picture'></div>\n  <div class='title'>\n    <h2 class='name on_picture'>\n      Races\n    </h2>\n  </div>\n</div>\n<div class='body'>\n  <div class='races'></div>\n</div>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['race_publications/list_item'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<a class='race_name' href='#'></a>\n<div class='details'>\n  <strong>\n    <span class='cat'></span>\n  </strong>\n  <span class='distance'></span>\n  km \u2192\n  <span class='climb'></span>\n  m \u2191\n</div>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['race_publications/next_or_recent_instance'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<a class='date'></a>\nat\n<span class='time'></span>\n<p class='entry'>\n  <span class='eod'>\n    Entry on the day:\n    <span class='currency eod_fee'></span>\n  </span>\n  <span class='no_eod'>\n    No entry on the day\n  </span>\n  <a class='enter_online opener'>\n    Enter online:\n    <span class='currency online_entry_fee'></span>\n  </a>\n  <a class='enter_postal' target='_blank'>\n    Download entry form\n  </a>\n  <a class='entries opener'>\n    Entry list\n  </a>\n  <a class='history opener'>\n    All-time results\n  </a>\n</p>\n<p class='results'>\n  <a class='results'>\n    Results available\n  </a>\n</p>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['race_publications/show'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<div class='head'>\n  <div class='picture'></div>\n  <div class='title'>\n    <h2 class='name'></h2>\n    <div class='owner'>\n      <a class='edit'>edit</a>\n    </div>\n  </div>\n  <div class='social'>\n    <a class='fb'>facebook</a>\n    <a class='twit'>twitter</a>\n    <a class='shr'>SHR</a>\n    <a class='fra'>FRA</a>\n  </div>\n</div>\n<div class='race_body'>\n  <div class='summary'>\n    <div class='profile'>\n      <span class='race_profile'></span>\n      <div class='basic_details'>\n        <span class='cat'></span>\n        <span class='distance'></span>\n        km /\n        <span class='climb'></span>\n        m\n      </div>\n    </div>\n    <div class='next_or_recent'></div>\n  </div>\n  <div class='description'></div>\n  <div class='details'>\n    <div class='attachments'>\n      <h3>\n        Downloads\n      </h3>\n      <ul class='attachments'></ul>\n    </div>\n    <div class='race_requirements'>\n      <h3>\n        Requirements\n      </h3>\n      <div class='show_requirements'>\n        <p class='requirements'></p>\n      </div>\n    </div>\n    <div class='checkpoints'>\n      <h3>\n        Checkpoints\n      </h3>\n      <ul class='checkpoints published'></ul>\n    </div>\n    <div class='records'>\n      <h3>\n        Records\n      </h3>\n      <ul class='records'></ul>\n    </div>\n    <div class='links'>\n      <h3>\n        Links\n      </h3>\n      <ul class='links'></ul>\n    </div>\n  </div>\n  <div class='moredetails'>\n    <div class='race_organiser'>\n      <h3>\n        Organiser\n      </h3>\n      <ul class='show_organiser'>\n        <li>\n          <a class='organiser_name'></a>\n        </li>\n        <li>\n          <span class='organiser_phone'></span>\n        </li>\n        <li>\n          <p class='organiser_address'></p>\n        </li>\n      </ul>\n    </div>\n    <div class='past_instances'>\n      <h3>\n        Results\n        <a class='history note'>all</a>\n      </h3>\n      <ul class='past_instances'></ul>\n    </div>\n  </div>\n  <div class='conclusion'>\n    <p>\n      fellrace.org.uk is built by fell runners who ought to be doing their real work,\n      and it has been known to fall over or go the wrong way. We are notified automatically when something breaks, \n      but please \n      let us know\n      anyway, and if you have any other suggestions or comments, please send them to Will.\n    </p>\n  </div>\n</div>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['races/edit'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<div class='head'>\n  <div class='picture'></div>\n  <div class='title'>\n    <h2 class='editable name' data-placeholder='Race name'></h2>\n    <div class='owner'>\n      <a class='cancel'>exit</a>\n      <a class='publish'>publish</a>\n    </div>\n  </div>\n  <!-- .social -->\n  <!--   %a.fb facebook -->\n  <!--   %a.twit twitter -->\n  <!--   %a.shr SHR -->\n  <!--   %a.fra FRA -->\n</div>\n<div class='race_body'>\n  <div class='summary'>\n    <div class='profile'>\n      <span class='race_profile'></span>\n      <div class='basic_details'>\n        <span class='cat editable' data-placeholder='Cat (e.g. AM)'></span>\n        &nbsp;\n        <span class='distance editable' data-placeholder='dist'></span>\n        km /\n        <span class='climb editable' data-placeholder='climb'></span>\n        m\n      </div>\n    </div>\n    <div class='next_or_recent'></div>\n  </div>\n  <div class='description editable' data-placeholder='Race description' data-toolbar></div>\n  <div class='details'>\n    <div class='attachments'>\n      <h3>\n        Downloads\n        <a class='add add_attachment'>\n          add\n        </a>\n      </h3>\n      <ul class='attachments'></ul>\n    </div>\n    <div class='race_requirements'>\n      <h3>\n        Requirements\n      </h3>\n      <div class='show_requirements'>\n        <p class='editable requirements' data-placeholder='Required kit and other instructions'></p>\n      </div>\n    </div>\n    <div class='checkpoints'>\n      <h3>\n        Checkpoints\n        <a class='add add_checkpoint'>\n          add\n        </a>\n      </h3>\n      <ul class='checkpoints'></ul>\n    </div>\n    <div class='route'>\n      <h3>\n        <input class='race_show_route' type='checkbox'>\n        Route\n      </h3>\n      <div class='route_controls'>\n        <div class='no_route'>\n          <p class='note'>\n            You can either\n            <a class='add checkpoint_route'>generate a route</a>\n            from the checkpoints or\n            <a class='add draw_route'>draw one on the map</a>\n          </p>\n        </div>\n        <div class='route_details'>\n          <span class='route_distance'></span>\n          km \u2192\&nbsp;\n          <span class='route_elevation'></span>\n          m \u2191\n          <input class='route_colour' type='color'>\n          <!-- %a.extend extend -->\n          <a class='delete delete_route'>\u232B</a>\n        </div>\n      </div>\n      <p class='note'>\n        If you want to show a profile and checkpoints but not tell people\n        where to go, you can draw out a route then hide it by unchecking the \n        box next to Route.\n      </p>\n    </div>\n    <div class='records'>\n      <h3>\n        Records\n        <a class='add add_record'>\n          add\n        </a>\n      </h3>\n      <ul class='records'></ul>\n    </div>\n    <div class='links'>\n      <h3>\n        Links\n        <a class='add add_link'>\n          add\n        </a>\n      </h3>\n      <ul class='links'></ul>\n    </div>\n  </div>\n  <div class='moredetails'>\n    <div class='future_instances'>\n      <h3>\n        Next race\n        <a class='add add_instance'>\n          add\n        </a>\n      </h3>\n      <ul class='future_instances'></ul>\n    </div>\n    <div class='past_instances'>\n      <h3>\n        Results\n        <a class='add add_instance'>\n          add\n        </a>\n      </h3>\n      <ul class='past_instances'></ul>\n    </div>\n    <div class='race_organiser'>\n      <h3>\n        Organiser\n      </h3>\n      <ul class='show_organiser'>\n        <li>\n          <span class='editable organiser_name' data-placeholder='name'></span>\n        </li>\n        <li>\n          <span class='editable organiser_email' data-placeholder='email'></span>\n        </li>\n        <li>\n          <span class='editable organiser_phone' data-placeholder='phone number'></span>\n        </li>\n        <li>\n          <p class='editable organiser_address' data-placeholder='address'></p>\n        </li>\n      </ul>\n    </div>\n  </div>\n  <div class='conclusion'>\n    <p>\n      fellrace.org.uk is built by fell runners who ought to be doing their real work,\n      and it has been known to fall over or go the wrong way. We are notified automatically when something breaks, \n      but please \n      let us know\n      anyway, and if you have any other suggestions or comments, please send them to Will.\n    </p>\n  </div>\n</div>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "").replace(/[\s\n]*\u0091/mg, '').replace(/\u0092[\s\n]*/mg, '');
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['races/next_instance'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<a class='date'></a>\n<span class='date'></span>\n<span class='time'></span>\n<a class='config'>\n  Dates, entries, results\n</a>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['races/picture'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<input class='file' id='picturepicker' type='file' accept='image/*'>\n<label class='pick' for='picturepicker'>\n  set picture\n</label>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['records/admin_list_item'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<span class='record'>\n  <span class='editable label' data-placeholder='Category'></span>\n  \:\n  <span class='editable time' data-placeholder='hh:mm:ss'></span>\n</span>\n<a class='delete'>\u232B</a>\n<span class='holder'>\n  <span class='editable name' data-placeholder='name'></span>\n  \,\n  <span class='editable year' data-placeholder='year'></span>\n</span>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "").replace(/[\s\n]*\u0091/mg, '').replace(/\u0092[\s\n]*/mg, '');
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['records/empty'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("Race records usually belong to entry categories (M, L, MV50 etc) but can have any label you like.\n<a class='add add_record'>\n  Click here to add a record.\n</a>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['records/list_item'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<span class='record'>\n  <span class='label'></span>\n  \:\n  <span class='time'></span>\n</span>\n<span class='holder'>\n  <span class='name'></span>\n  \,\n  <span class='year'></span>\n</span>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['sessions/confirmation_form'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<div class='confirm'>\n  <p class='waiter'>\n    Please wait while we check your confirmation token.\n  </p>\n  <p class='refusal'>\n    Sorry: this confirmation link does not seem to be correct. Have you already confirmed your account?\n    If not, you can \n    <a class='reconfirm'>\n      request another confirmation message.\n    </a>\n    Please make sure you're using the whole link.\n  </p>\n  <form>\n    <a class='avatar hide'></a>\n    <h3>\n      Welcome back \n    </h3>\n    <p class='preamble'>\n      Thank you for all the waiting and clicking.\n      To finish setting up your account, we only need your name and password.\n    </p>\n    <fieldset>\n      <p class='names'>\n        <label for='first_name'>\n          Name\n        </label>\n        <br>\n        <input id='first_name' name='first_name' type='text' required='required' placeholder='First name'>\n        <input id='last_name' name='last_name' type='text' required='required' placeholder='Surname'>\n      </p>\n      <p>\n        <label for='password'>\n          Password\n        </label>\n        <input id='password' name='password' type='password' required='required'>\n      </p>\n      <div class='password_confirmation'>\n        <p>\n          <label for='password_confirmation'>\n            and please confirm\n          </label>\n          <input id='password_confirmation' name='password_confirmation' type='password' required='required'>\n        </p>\n      </div>\n      <!-- / #TODO: choose a running club too. -->\n      <div class='buttons'>\n        <input type='submit' value='Save me'>\n      </div>\n    </fieldset>\n    <p class='outcome'>\n      When you press 'save me' we will store this password and create a site at\n      <strong class='domain'></strong>\n    </p>\n  </form>\n  <div class='confirmation'>\n    <h3 class='robot'>\n      All done\n    </h3>\n    <p>\n      Please wait while we create your site.\n    </p>\n  </div>\n</div>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['sessions/confirmation_required'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<div class='signin'>\n  <form class='password'>\n    <a class='avatar hide'></a>\n    <h3>\n      Awaiting confirmation\n    </h3>\n    <p>\n      Thank you for signing up. We have sent a confirmation message to\n      <strong id='email'></strong>\n    </p>\n    <p>\n      Please click on its large friendly button to complete the process.\n    </p>\n  </form>\n</div>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['sessions/login_form'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<div class='signin'>\n  <a class='big close'></a>\n  <h3>\n    Sign in here\n  </h3>\n  <form>\n    <fieldset>\n      <p>\n        <label for='email'>\n          Email\n        </label>\n        <input id='email' name='email' type='email' required='required'>\n      </p>\n      <p>\n        <label for='password'>\n          Password\n        </label>\n        <a class='forgotten'>\n          forgotten?\n        </a>\n        <input id='password' name='password' type='password' required='required'>\n      </p>\n      <div class='form-actions'>\n        <input type='submit' value='Sign in'>\n        <span class='note'>\n          or\n          <a class='cancel'>cancel</a>\n        </span>\n      </div>\n      <p class='large'>\n        No account?\n        <a class='sign_up'>sign up now.</a>\n        It's free and only takes a few seconds.\n      </p>\n    </fieldset>\n  </form>\n</div>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['sessions/password_form'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<div class='signin'>\n  <a class='avatar hide'></a>\n  <p class='waiter'>\n    Please wait while we check your reset token.\n  </p>\n  <p class='refusal'>\n    Sorry: this reset link does not seem to be correct. Have you already used this reset token?\n    You can \n    <a class='reqest_reset'>\n      request another one.\n    </a>\n    Otherwise, please check your email and make sure you're getting the whole link.\n  </p>\n  <form>\n    <h3>\n      Hello\n      <span class='first_name'></span>\n    </h3>\n    <p class='preamble'>\n      Welcome back. Please use this form to choose a new password.\n    </p>\n    <fieldset>\n      <p>\n        <label for='password'>\n          New password\n        </label>\n        <input id='password' name='password' type='password' required='required'>\n        <span class='note'>\n          At least 6 characters, please\n        </span>\n      </p>\n      <div class='password_confirmation'>\n        <p>\n          <label for='password_confirmation'>\n            and please confirm\n          </label>\n          <input id='password_confirmation' name='password_confirmation' type='password' required='required'>\n        </p>\n      </div>\n      <div class='buttons'>\n        <input type='submit' value='Set password'>\n      </div>\n    </fieldset>\n    <p class='note'>\n      When you press 'set password' we will update your account with that password and discard the old one.\n      Until that point, you can \n      <a class='cancel'>cancel this operation</a>\n      and the old one will still work.\n    </p>\n  </form>\n  <div class='confirmation'>\n    <h3 class='robot'>\n      Password updated\n    </h3>\n    <p>\n      Your password has been reset and you have been signed in automatically.\n      You can\n      <a class='cancel'>get back to work.</a>\n    </p>\n  </div>\n</div>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['sessions/reconfirmation_form'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<div class='signin'>\n  <form class='password'>\n    <a class='avatar hide'></a>\n    <h3>\n      Resend confirmation\n    </h3>\n    <fieldset>\n      <p>\n        <label for='email'>\n          Email address\n        </label>\n        <input id='email' name='email' type='email' required='required'>\n      </p>\n      <div class='buttons'>\n        <input type='submit' value='Send message'>\n        <span class='note'>\n          or\n          <a class='cancel'>\n            cancel\n          </a>\n        </span>\n      </div>\n      <p class='note'>\n        When you click 'send message' we will check\n        <span class='email'></span>\n        and if it is recognised, send another confirmation message to that address.\n        Please check the email address carefully.\n      </p>\n      <p>\n        If you have confirmed your account, this isn't necessary (and won't work) but you can always\n        <a class='request_reset'>\n          reset your password\n        </a>\n        instead.\n      </p>\n    </fieldset>\n  </form>\n  <div class='confirmation'>\n    <h3 class='robot'>\n      Confirmation sent\n    </h3>\n    <p>\n      Thank you. If we recognise\n      <span class='email'></span>\n      then a new confirmation message will be sent.\n      Please allow a few minutes for it to arrive, and keep an eye on your spam folder.\n      The message will appear to come from robot@fellrace.org.uk.\n    </p>\n    <p>\n      If all else fails, you can \n      <a class='sign_up'>\n        sign up again\n      </a>\n      with another address. \n      Your address is still available until you confirm your account.\n    </p>\n  </div>\n</div>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['sessions/reset_form'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<div class='signin'>\n  <form class='password'>\n    <a class='avatar hide'></a>\n    <h3>\n      Reset your password\n    </h3>\n    <fieldset>\n      <p>\n        <label for='email'>\n          Email address\n        </label>\n        <input id='email' name='email' type='email' required='required'>\n      </p>\n      <div class='buttons'>\n        <input type='submit' value='Send instructions'>\n        <span class='note'>\n          or\n          <a class='cancel'>\n            cancel\n          </a>\n        </span>\n      </div>\n      <p class='note'>\n        When you click 'send instructions' we will check\n        <span class='email'></span>\n        and if it is recognised, send a message explaining how to reset your password.\n        Please check the email address carefully.\n      </p>\n      <p>\n        If you haven't confirmed your account yet, this won't work. You should \n        <a class='reconfirm'>\n          request a new confirmation message\n        </a>\n        instead.\n      </p>\n    </fieldset>\n  </form>\n  <div class='confirmation'>\n    <h3 class='robot'>\n      Reset message sent\n    </h3>\n    <p>\n      Thank you. If we recognised\n      <span class='email'></span>\n      then a message was sent explaining how to reset your password. \n      Please allow a few minutes for it to arrive, and keep an eye on your spam folder.\n      The message will appear to come from robot@fellrace.org.uk.\n    </p>\n    <p>\n      Nothing has changed, so if you remember your password you can still\n      <a class='sign_in'>\n        sign in\n      </a>\n      <div class=''></div>\n      <!-- or  -->\n      <!-- %a{href: \"/\"} -->\n      <!--   request a site -->\n      <!-- as usual. -->\n    </p>\n  </div>\n</div>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['users/action_menu'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<a class='big close'></a>\n<a class='avatar hide'></a>\n<h3 class='name'></h3>\n<ul class='actions'>\n  <li>\n    <a class='me' href='/users/me'>\n      Your page\n    </a>\n  </li>\n  <!-- %li -->\n  <!--   %a.prefs{href: \"/users/me/preferences\"} -->\n  <!--     Account preferences -->\n  <li>\n    <a class='signout'>\n      Sign out\n    </a>\n  </li>\n  <li class='find_me'>\n    <a class='find_me'>Where am I?</a>\n  </li>\n</ul>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['users/confirmation_notice'] = function(context) {
    return (function() {
      var $c, $e, $o;
      $e = function(text, escape) {
        return ("" + text).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/'/g, '&#39;').replace(/\//g, '&#47;').replace(/"/g, '&quot;');
      };
      $c = function(text) {
        switch (text) {
          case null:
          case void 0:
            return '';
          case true:
          case false:
            return '' + text;
          default:
            return text;
        }
      };
      $o = [];
      $o.push("<a class='avatar hide'></a>\n<h3>\n  Hello \n  <span class='first_name'></span>\n</h3>\n<p>\n  Welcome to fellrace.org.uk.\n</p>\n<p>\n  An email message has been sent to \n  <strong>");
      $o.push("    " + $e($c(this.user.email)));
      $o.push("  </strong>\n  containing a large friendly button. \n  Please push the button to confirm that the address belongs to you.\n  You will be brought back here to choose a password and start your site.\n</p>\n<p class='outcome'></p>\n<p>\n  If you can't find the confirmation message, we can send it again either to the same address or a new one: \n</p>\n<form class='resend'>\n  <fieldset>\n    <input id='email' name='email' type='email' required='required' placeholder='email address'>\n    <input type='submit' value='Resend confirmation'>\n  </fieldset>\n</form>");
      return $o.join("\n").replace(/\s([\w-]+)='true'/mg, ' $1').replace(/\s([\w-]+)='false'/mg, '').replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['users/controls'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<a class='avatar'></a>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['users/greeting'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<a class='avatar hide'></a>\n<h3>\n  Hello \n  <span class='first_name'></span>\n</h3>\n<p>\n  Welcome to fellrace.org.uk.\n</p>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['users/preferences'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<div class='head'>\n  <div class='home picture'></div>\n</div>\n<div class='body'>\n  <p class='name twocol'>\n    <span class='col'>\n      <label for='first_name'>Forename</label>\n      <input id='first_name' type='text'>\n    </span>\n    <span class='col last'>\n      <label for='last_name'>Surname</label>\n      <input id='last_name' type='text'>\n    </span>\n  </p>\n  <p class='email twocol'>\n    <span class='col'>\n      <label for='email'>Email</label>\n      <input id='email' type='email'>\n    </span>\n  </p>\n  <p class='hide onecol password'>\n    <span class='col'>\n      <label for='password'>Password</label>\n      <input id='password' type='password'>\n    </span>\n  </p>\n  <p class='hide new_password twocol'>\n    <span class='col'>\n      <label for='new_password'>New password</label>\n      <input id='new_password' type='password'>\n    </span>\n    <span class='col last'>\n      <label for='new_password_confirmation'>New password confirmation</label>\n      <input id='new_password_confirmation' type='password'>\n    </span>\n  </p>\n</div>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['users/show'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<div id='competitor'></div>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['users/sign_in_out'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<a class='sign_in' href='/sign_in'>\n  Sign in\n</a>\n<a class='sign_out' href='/sign_out'>\n  Sign out\n</a>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['users/sign_up_for_race'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<div class='check'></div>\n<div class='register'>\n  <form class='signup'>\n    <fieldset class='race'>\n      <a class='avatar hide'></a>\n      <p class='availability'></p>\n      <input id='desired_slug' name='slug' type='text' required='required'>\n      <span class='domain'>\n        \.fellrace.org.uk\n      </span>\n    </fieldset>\n    <fieldset class='user'>\n      <input id='email' name='email' type='email' required='required' placeholder='email address'>\n      <input type='submit' value='Sign up'>\n      <p class='note'>\n        When you click 'sign up' we'll send a confirmation message to \n        <span class='email'></span>\n        Click on its large friendly button\n        <span class='outcome'></span>\n      </p>\n    </fieldset>\n  </form>\n  <p>\n    Already got one? Please\n    <a class='sign_in'>\n      sign in first.\n    </a>\n  </p>\n</div>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);

(function() {
  if (FellRace.Templates == null) {
    FellRace.Templates = {};
  }

  FellRace.Templates['users/sign_up'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<a class='big close'></a>\n<a class='avatar hide'></a>\n<h3>\n  Welcome!\n</h3>\n<div class='register'>\n  <form class='signup'>\n    <fieldset class='user'>\n      <input id='email' name='email' type='email' required='required' placeholder='email address'>\n      <input type='submit' value='Sign up'>\n      <p class='note'>\n        When you click 'sign up' we'll send a confirmation message to\n        <span class='email'></span>\n        Click on its large friendly button\n        <span class='outcome'></span>\n      </p>\n    </fieldset>\n  </form>\n  <p>\n    Already got an account? Please\n    <a class='sign_in'>\n      sign in instead.\n    </a>\n  </p>\n</div>");
      return $o.join("\n").replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);
