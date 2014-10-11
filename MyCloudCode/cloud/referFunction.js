// This is the file for backend refer function

exports.referBroadCast = function(requester_id, company_id) {
  console.log("Broad casting started on cloud...");

  var user_query = new Parse.Query("AppUser");
  //user_query.equalTo("objectId", requester_id);

  console.log(requester_id);

  //var companyObj = Parse.Object.extend("Company");
  var comp_query = new Parse.Query("Company");
  //comp_query.equalTo
  console.log(company_id);

  user_query.get(requester_id).then(function(user) {
  	console.log("hello");
  	return comp_query.get(company_id);
  }).then(function(comp) {
  	console.log("what happedn");
  	var userName = user["formattedName"];
  	var companyName = comp["name"];

  	var message = userName + "please refer me at " + companyName;

  	console.log(companyName);
  	console.log(message);

  	Parse.Push.send({
  	  channels: [companyName],
  	  data: {
  	  	alert: message
  	  }
  	},{
  	   success: function() {
  	  	 // Push was successful
  	  	 console.log("request sent to referer.");
  	   },
  	   error: function(error) {
  	  	 // Handle error
  	  	 console.log("Sending request braodcasting get wrong: " + error);
  	   }
  	});
  });


  //var applyObj = Parse.Object.extend("Apply");
  //var apply_query = Parse.Query(applyObj);


  //var message = user_name + " asking refer from you!";
  //console.log(message);

  // Parse.Push.send({
  // 	channels: [company_name],
  // 	data: {
  //     alert: message
  // 	}
  // }, {
  // 	success: function() {
  //     // Push was successful
  //     console.log("request sent to referer.");
  // 	},
  // 	error: function(error) {
  //     // Handle error
  //     console.log("Sending request broadcasting get wrong: " + error);
  // 	}
  // });
}