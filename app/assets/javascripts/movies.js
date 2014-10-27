(function () {

	//Main Functions
	function movieGetRenderedTemplate(data){
		var templateMovie = $('#template-movie-info').html();
		Mustache.parse(templateMovie);   // optional, speeds up future uses
		var rendered = Mustache.render(templateMovie, { 
			 id: 					data.id
			,title: 				data.title
			,overview: 				data.overview
			,year: 					data.year
			,released: 				data.released
			,trailer: 				data.trailer
			,runtime: 				data.runtime
			,tagline: 				data.tagline
			,certification: 		data.certification
			,imdb_id: 				data.imdb_id
			,tmdb_id: 				data.tmdb_id
			,poster: 				data.poster
			,released_formatted: 	data.released_formatted
		});
		return rendered;
	};

	//Events
	$(".js-movie-poster").on('click',function() {
		var movieID = $(this).parents('.js-movie-item').attr('data-movie-id');
		var infoURL  =   movieID + ".json";

		$.ajax({
			        type: "GET",
			        url:infoURL,
			        dataType:'json',
			        success: function( data, textStatus , jqXHR)
		                      {
	                      		var rendered = movieGetRenderedTemplate(data);
		                        $('body').append(rendered);
		                      },
			        error: connectionFailed
				});
	});

	$(".js-movie-item").mouseleave(function () {
	    //$infoPanel.hide();
	});

}
)();