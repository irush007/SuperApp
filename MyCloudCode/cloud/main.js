
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
// 

var helper = require('cloud/saveUtil.js');

Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});

Parse.Cloud.afterSave("AppUser", function(request) {
  console.log("Calling afterSave, object saved successfully.");
});

Parse.Cloud.define("verifyUser", function(request, response) {
  var user_info_obj = request.params.userInfo;
  var user_query = new Parse.Query("AppUser");

  var lastName = user_info_obj["lastName"];
  var linkedinId = user_info_obj["linkedinId"];
  var firstName = user_info_obj["firstName"];
  var fullName = user_info_obj["formattedName"];
  var location = user_info_obj["location"];
  var title = user_info_obj["title"];

  var education = user_info_obj["education"];
  var companyList = user_info_obj["companyList"];

  var email = user_info_obj["email_address"];

  var access_token = request.params.access_token;

  var comp_query = new Parse.Query("Company");
  var company = request.params.company_info;
  var company_id = company["company_id"];

  var linkedin_cmp_request_url = "https://api.linkedin.com/v1/companies/" 
  							   + company_id
  							   + ":(id,name,ticker,description,company-type,employee-count-range,square-logo-url,locations:(address:(city,state)))"
  							   + "?oauth2_access_token="
  							   + access_token
  							   + "&format=json";

  console.log("request url is : " + linkedin_cmp_request_url);


  // comp_query.equalTo("companyId", company_id);
  // comp_query.find().then(function(companies) {
  // 	var Company = Parse.Object.extend("Company");
  // 	var comp = new Company();
  // 	//var promise = new Parse.Promise();
  // 	if (companies.length > 0) {
  // 	  comp = companies[0];
  // 	} else {
  // 	  console.log("Query linkedin for company.");
  // 	  Parse.Cloud.httpRequest({
  // 		url: linkedin_cmp_request_url
  // 	  }).then(function(httpResponse){
  // 	  	console.log(httpResponse.data);

  // 	  }, function(error){
  // 	  	console.log("get data error");
  // 	  	console.log(error);
  // 	  });
  // 	}
  // });
  // 
  comp_query.equalTo("company_id", company_id);

  user_query.equalTo("linkedinId", linkedinId);
  var appUser = Parse.Object.extend("AppUser");
  var user = new appUser();

  user_query.find().then(function(results) {
  	if (results.length > 0) {
  	  user = results[0];
  	} else {
  	  console.log("This is first name: " + firstName);
	  user.set("linkedinId", linkedinId);
	  user.set("lastName", lastName);
	  user.set("firstName", firstName);
	  user.set("formattedName", fullName);
	  user.set("location", location);
	  user.set("title", title);
	  user.set("education", education);
	  user.set("companyList", companyList);
	  user.set("email_address", email);
  	}
  	return user.save();
  }).then(function(user) {
  	return comp_query.find();
  }).then(function(comp_results) {
  	var Company = Parse.Object.extend("Company");
  	var comp = new Company();

  	if (comp_results.length > 0) {
  	  user.set("company", comp_results[0]);
  	  user.save();
  	  console.log("company already exists");
  	  response.success("User signed in successfully.");
  	} else {
  	  console.log("Query linkedin for company.");
  	  Parse.Cloud.httpRequest({
  		url: linkedin_cmp_request_url
  	  }).then(function(httpResponse){
  	  	console.log(httpResponse.data);
  	  	comp.set("description", httpResponse.data["description"]);
  	  	comp.set("company_id", httpResponse.data["id"]);
  	  	comp.set("name", httpResponse.data["name"]);
  	  	comp.set("type", httpResponse.data["companyType"]["name"]);
  	  	comp.set("size", httpResponse.data["employeeCountRange"]["name"]);
  	  	comp.set("image_url", httpResponse.data["squareLogoUrl"]);

  	  	var address = httpResponse.data["locations"]["values"][0];
  	  	var city = address["address"]["city"];
  	  	var state = address["address"]["state"];

  	  	comp.set("city", city);
  	  	comp.set("state", state);

  	  	user.set("company", comp);
  	  	user.save();
  	  	response.success("User signed in successfully.");
  	  }, function(error){
  	  	console.log(error);
  	    response.error("Something went wrong when user signed in.");
  	  });
  	}
  });

  // query.equalTo("id", user_info_obj["linkedinId"]);
  // query.find({
  // 	success: function(results) {
  // 	  if (results.length > 0) {


  // 	  } else {
  // 	  	var user = Parse.Object.extend("AppUser");
  // 	  	user.set("linkedinId", linkedinId);
  // 	  	user.set("lastName", lastName);
  // 	  	user.set("firstName", firstName);
  // 	  	user.set("formattedName", fullName);
  // 	  	user.set("location", location);
  // 	  	user.set("title", title);
  // 	  	user.set("education", education);
  // 	  	user.set("companyList", companyList);




  // 	  }

  // 	  if (count > 0) {
  // 	    //response.success("The user already there.");
  // 	   	// if need update user info
  // 	   	updateUserInfo()
  // 	    console.log("User already exists");
  // 	  } else {
  // 	  	console.log("New user found");
  // 	  	appUser = helper.addNewUser(user_info_obj);

  // 	  	//response.success("New user signed in.");
  // 	  }
  // 	},
  // 	error: function(error) {
  //     // TODO when error occurs
  //     console.log("User sign in failed: " + error);
  //     //response.error(error);
  // 	}
  // });
});
