(function () {

	var lastMovieID = 0;

	//Main Functions

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
			                      	var html = HandlebarsTemplates['pages/movie_info'](data);
		                      		$(".js-movie-info-container").empty(); //clear previous items
			                        $(".js-movie-info-container").html(html);

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
			                        var $clickedMovie = $(".js-movie-item-" + movieID);
									$('html, body').animate({
									    scrollTop: $clickedMovie.offset().top - 40
									}, 1000);

			                      },
				        error: connectionFailed
					});
		}

	});

	$(document).on('shown.bs.tab', 'a[data-toggle="tab"]', function (e) {
		var $tab = $(e.target);
		var itemSelector = $tab.attr('href');
		var movieID = $tab.parents('.js-movie-tabs').data('movie-id');

		switch (itemSelector) {
		  case '#recommendations':
		  	$(itemSelector).empty().html(getLoaderHTML());
			infoURL = '/movies/related/' + movieID + ".json";
			$.ajax({
		        type: "GET",
		        url:infoURL,
		        dataType:'json',
		        success: function(data, textStatus , jqXHR)
		                  {
		                  	data.mainMovieTitle = $('.js-main-movie-title').text();
							var html = HandlebarsTemplates['pages/related_movies'](data);
							$('#recommendations').empty().html(html);
		                  },
		        error: function(){
		        			var errorHTML = '<div class="alert alert-warning col-md-6 col-md-offset-3" role="alert">Unable to retrieve recommendations at this time. Please try again later.</div>';
		        			$('#recommendations').empty().html(errorHTML);
		        		}
			});
		    break;
			  case '#Rotten-Tomatoes-Reviews':
			  	$(itemSelector).empty().html(getLoaderHTML());
				infoURL = '/movies/rt.json';
				$.ajax({
			        type: "GET",
			        url:infoURL,
			        dataType:'json',
			        success: function( data, textStatus , jqXHR)
			                  {
								var html = HandlebarsTemplates['pages/rotten_tomatoes_review'](data);
								$('#Rotten-Tomatoes-Reviews').empty().html(html);
			                  },
			        error: function(){
			        			var errorHTML = '<div class="alert alert-warning col-md-6 col-md-offset-3" role="alert">Unable to retrieve Rotten Tomatoes Reviews at this time. Please try again later.</div>';
			        			$('#Rotten-Tomatoes-Reviews').empty().html(errorHTML);
			        		}
				});
			    break;
			  case '#reddit':
			  	$(itemSelector).empty().html(getLoaderHTML());
				infoURL = '/movies/reddit.json?id=' + movieID;
				$.ajax({
			        type: "GET",
			        url:infoURL,
			        dataType:'json',
			        success: function( data, textStatus , jqXHR)
			                  {
			                  	var html = HandlebarsTemplates['pages/reddit_list'](data);
								$('#reddit').empty().html(html);
			                  },
			        error: function(){
			        			var errorHTML = '<div class="alert alert-warning col-md-6 col-md-offset-3" role="alert">Unable to retrieve Reddit items at this time. Please try again later.</div>';
			        			$('#reddit').empty().html(errorHTML);
			        		}
				});
			    break;
			  case '#cinema-times':
			  	$(itemSelector).empty().html('Cinema Times - WIP');
			    break;

		  default:
		    //Statements executed when none of the values match the value of the expression
		    break;
		}

	});

	$('.js-movie-tabs a:first').tab('show');

}
)();

