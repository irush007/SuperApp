
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
// 

//var addUtil = require('cloud/saveUtil.js');

Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});

Parse.Cloud.afterSave("AppUser", function(request) {
  console.log("Calling afterSave, object saved successfully.");
});

// Parse.Cloud.define("verifyUser", function(request, response) {
//   var user_info_obj = request.params.userInfo;
//   var query = new Parse.Query("Appuser");

//   query.equalTo("id", user_info_obj["id"]);
//   query.count({
//   	success: function(count) {
//   	  if (count > 0) {
//   	    //response.success("The user already there.");
//   	   	// if need update user info
  	    
//   	  } else {
//   	  	addUtil.addNewUser(user_info_obj, response);
//   	  	//response.success("New user signed in.");
//   	  }
//   	},
//   	error: function(error) {
//       // TODO when error occurs
//       console.log("User sign in failed: " + error);
//       //response.error(error);
//   	}
//   });
// });
