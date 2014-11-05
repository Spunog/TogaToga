(function () {

	var lastMovieID = 0;

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

	function hideOtherMoviePosterContainers(movieID){
	    var $clickedMovie = $(".js-movie-item-" + movieID);
	    $clickedMovie.addClass('active');

	    //Clear Previous Containers
	    $clickedMovie.prevAll(".js-movie-info-container").empty();

	    //Clear containers after the first matching container
	    $clickedMovie.nextAll('.js-movie-info-container-lg').first().nextAll('.js-movie-info-container-lg').empty();
	    $clickedMovie.nextAll('.js-movie-info-container-md').first().nextAll('.js-movie-info-container-md').empty();
	    $clickedMovie.nextAll('.js-movie-info-container-sm').first().nextAll('.js-movie-info-container-sm').empty();
	    $clickedMovie.nextAll('.js-movie-info-container-xs').first().nextAll('.js-movie-info-container-xs').empty();
	}

	//Events
	$(".js-movie-poster").on('click',function() {
		var movieID = $(this).parents('.js-movie-item').attr('data-movie-id');

		$(".movie.active").removeClass('active');

		//Show Loader
		$(".js-movie-info-container").empty().html(getLoaderHTML());
		hideOtherMoviePosterContainers(movieID);			                        

		//Show Movie
		if(lastMovieID == movieID){
			lastMovieID = 0;
			$(".js-movie-info-container").empty(); //clear previous items
		}else{
			lastMovieID = movieID;
			var infoURL  =   'movies/' + movieID + ".json";
			$.ajax({
				        type: "GET",
				        url:infoURL,
				        dataType:'json',
				        success: function( data, textStatus , jqXHR)
			                      {
		                      		var rendered = movieGetRenderedTemplate(data);
		                      		$(".js-movie-info-container").empty(); //clear previous items
			                        $(".js-movie-info-container").html(rendered);

			                        //Bind Items
			                        $(".js-movie-info-container").find('.js-close-movie-info').off().on('click',function(event){
										event.preventDefault();
										lastMovieID = 0;
										$(".movie.active").removeClass('active');
										$(".js-movie-info-container").empty(); //clear previous items
			                        });
			                        
			                        //Only use one set of info containers to display info
			                        var movieID = data.id;
			                        hideOtherMoviePosterContainers(movieID);

			                        //Scroll to item
									$('html, body').animate({
									    scrollTop: $clickedMovie.offset().top - 40
									}, 1000);

			                      },
				        error: connectionFailed
					});
		}

		
	});

	$(".js-movie-item").mouseleave(function () {
	    //$infoPanel.hide();
	});

	$(document).on('shown.bs.tab', 'a[data-toggle="tab"]', function (e) {
		var $tab = $(e.target);
		var movieID = $tab.parents('.js-movie-tabs').data('movie-id');

		$('#recommendations').empty().html(getLoaderHTML());

		switch ($tab.attr('href')) {
		  case '#recommendations':
			infoURL = '/movies/related/' + movieID + ".json";
			$.ajax({
		        type: "GET",
		        url:infoURL,
		        dataType:'json',
		        success: function( data, textStatus , jqXHR)
		                  {
							var templateMovie = $('#template-related-movie-info').html();
							Mustache.parse(templateMovie);   // optional, speeds up future uses
							var rendered = Mustache.render(templateMovie, data);
							
							$('#recommendations').empty().html(rendered);

		                  },
		        error: connectionFailed
			});
		    break;
		  default:
		    //Statements executed when none of the values match the value of the expression
		    break;
		}

	});

	$('.js-movie-tabs a:first').tab('show');

}
)();

