Student: {
	Registration: {
		url: 	localhost:3000/students,
		method: POST,
		paras: {
			"name",			// This is not optional.
			"email", 
			"password", 
			"grade"
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
			"email", 				// Only email can be used as login, since name may be duplicated.
			"password"
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
	}
}