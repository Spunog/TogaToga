(function () {

	$(".js-movie-poster").on('click',function() {
		$('.js-movie-info:visible').hide();
		var movieID = $(this).attr('data-movie-id');
		var $infoPanel = $(".js-movie-info-" + movieID);
		$infoPanel.removeClass('hide').show();
	});

	$(".js-movie-item").mouseleave(function () {
		var movieID = $(this).attr('data-movie-id');
		var $infoPanel = $(".js-movie-info-" + movieID);
	    $infoPanel.hide();
	});

}
)();