Handlebars.registerHelper('truncate', function(str, len) {
	if (str.length > len) {
	 var new_str = str.substr(0, len + 1);

	 while (new_str.length) {
	     var ch = new_str.substr(-1);
	     new_str = new_str.substr(0, -1);

	     if (ch == ' ') {
	         break;
	     }
	 }

	 if (new_str == '') {
	     new_str = str.substr(0, len);
	 }

	 return new Handlebars.SafeString(new_str + '...');
	}
	return str;
});

Handlebars.registerHelper("prettyUnixFromNow", function(unixtime) {
    return moment.unix(unixtime).fromNow();
});

Handlebars.registerHelper("prettyUnix", function(unixtime) {
    return moment.unix(unixtime).format('MMM Do');
});

Handlebars.registerHelper("prettifyDateLong", function(dateitem) {
    return moment(dateitem).format('MMMM Do YYYY');
});

Handlebars.registerHelper("reddit_thumb", function(thumbnail) {
	var src = (thumbnail == 'self' || thumbnail == 'default' || thumbnail=='') ?  '../assets/reddit.gif' : thumbnail;
    return src;
});