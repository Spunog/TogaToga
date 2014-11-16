function favourite_create(movieID,userID){

	$.ajax({
	     url: "/users/" + userID + "/favourites.json"
	    ,type: "POST"
	    ,data: {
	    			 "favourite[movie_id]"	: movieID
			   }
	    ,success: function(resp){
	    			var currentCount = $('.js-favourite-count').text();
	    			currentCount++;
	    			$('.js-favourite-count').text(currentCount);
	    			$('.js-add-to-favs').text('Added!').attr('disabled', true);
	    		}
        ,error: function(){
        			alert('Unable to add movie to your favourites at this time.\nPlease try again later.')
        		}
		,statusCode: {
							304: function() {
												alert( "Movie is already on favourite list. Unable to add a second time." );
											}
					   }
	});

};