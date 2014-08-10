// This is the file for helping save/update info in the backend.


exports.addNewUser = function(user_info, response) {
  var User = Parse.Object.extend("AppUser");
  var user = new User();

  //var Education = Parse.Object.extend("Eduction");
  var School = Parse.Object.extend("School");
  var Company = Parse.Object.extend("Company");

  var Position = Parse.Object.extend("Position");
  
  var lastName = user_info["lastName"];
  var userid = user_info["id"];
  var firstName = user_info["firstName"];
  var educations = user_info["educations"];
  var full_name = user_info["formattedName"];
  var positions = user_info["positions"];
  var location = user_info["location"]["name"];

  user.set("userid", userid);
  user.set("firstName", firstName);
  user.set("full_name", full_name);
  user.set("location", location);

  var education_obj_array = educations["values"];
  var edu_relation = user.relation("educations");

  var position_obj_array = positions["values"];
  var pos_relation = user.relation("positions"); 

  

  var school_array = new Array();
  // get the school, in the school array
  for (var i=0; i<educations["_total"]; i++) {
  	school_array.push(education_obj_array[i]["schoolName"]);
  }

  user.set("school", school_array);

  var cmp_obj;
  for (var i=0; i<positions["_total"]; i++) {
  	if (position_obj_array[i]["isCurrent"]) {
  	  cmp_obj = position_obj_array[i]["company"];
  	  break;
  	}
  }

  if (cmp_obj != null) {
  	var cmp_query = new Parse.Query(Company);
  	cmp_query.equalTo("cmpId", cmp_obj["id"]);

  	cmp_query.find().then(function(comp) {
  	  if (comp.length > 0) {
  	  	user.set("company", comp[0]);
  	  	return cmp_query.find();
  	  } else {
  	  	var cp = new Company();
  	  	cp.set("cmpId", cmp_obj["id"]);
  	  	cp.set("name", cmp_obj["name"]);
  	  	return cp.save();
  	  }
  	}).then(
  	)
  }


  user.save(null, {
  	success: function(user) {
  	  console.log("User saved.");
  	  response.success("User saved successfully.");
  	},
  	error: function(user, error) {
  	  console.log(error);
  	  response.error("Faild to save user.");
  	}
  });
}