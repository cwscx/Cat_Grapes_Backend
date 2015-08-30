Student: {
	Registration: {
		url: 	localhost:3000/students,
		method: POST,
		paras: {
			"student": {
				"name",			// This is not optional.
				"email", 		// Email must follow the format
				"password", 	// Password needs to be at least 8 digits
				"grade"
			}
		},
		return: {
			Created: {
				json: {
					student: resource, 
					status: "Created"
				}, 
				status: 201
			},
			Existed: {
				json: {
					student: resource, 
					status: "Existed"     // Due to duplicated email
				}, 
				status: 202
			},
		}
	},
	Login: {
		url:	localhost:3000/students/sign_in,
		method:	POST,
		paras: {
			"student": {
				"email", 				// Only email can be used as login, since name may be duplicated.
				"password"
			}
		},
		return: {
			Login Failure: {
				json: {
					status: "Login Failure"
				},
				status: 202
			},
			Unconfirmed Email: {
				json: {
					status: "Unconfirmed Email"
				}, 
				status: 203
			},
			Login Success: {
				json: {
					student: resource, 
					status: "Login Success"
				}, 
				status: 200
			}
		}
	},
	Logout: {
		url:	localhost:3000/students/sign_out,
		method: DELETE,
		paras: nil,
		return: nil
	},
	GetCase: {
		url:	localhost:3000/cases,
		method: GET,
		paras: {
			"caseInfo": {		// All the three ids should start at 1
				"book_id"		
				"unit_number"
				"case_number"
			}
		},
		return: {
			Book Not Found: {
				json: {
					message: errmsg, 
					reason: "Book Not Found"
				}, 
				status: 404
			},
			Unit Not Found: {
				json: {
					message: errmsg, 
					reason: "Unit Not Found"
				}, 
				status: 404
			},
			Case Not Found: {
				json: {
					message: errmsg,
					reason: "Case Not Found"
				}, 
				status: 404
			},
			Case Found: {
				json: {
				  vedio_resource: vrsc
				  exercise_resources: ersc
				}, 
				status: 200
			}
		},
		relationship: {
			a Book has many Units.
			a Unit has many cases in sequence.
			a Case has many exercises and videos in sequence.
		}
	},
	Get Current Record: {
		url:	localhost:3000/student/current_record,
		method:	GET,
		paras:	nil,
		return: {
			Invalid Record: {     	// When both exercise_id and vedio_id have values or both not
				json: {
					message: "Invalid Record"
				}, 
				status: 500
			},
			Record Not Found: {
				json: {
					message: "Records Not Found."
				}, 
				status: 404
			},
			Found: {
				json: {
			  	  current_record: {
			    	  book_id: 
			    	  unit_id: 
			    	  case_id: 
			    	  exercise_id: 
			    	  video_id:
			  	},
			  	status: 200
			}
		}
	}
}