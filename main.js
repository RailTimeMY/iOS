Parse.Cloud.define("averageStars", function(request, response) {
	var query = new Parse.Query("objectID");
	query.equalTo("coordinate", request.params.coordinate);
	query.find({
					success: function(results) {
						var sum = 0;
						response.success("Success");
					}, error: function() {
						response.error("failed");
					}
			   });
});
