package model

type Message struct {
	Message string `json:"message" example:"message"`
}

type SignupInput struct {
	Email          string `json:"email"`
	Password       string `json:"password"`
	FirstName      string `json:"firstName"`
	LastName       string `json:"lastName"`
	PhoneNumber    string `json:"phoneNumber"`
	UserIdentity   string `json:"userIdentity"`
	CompanyID      string `json:"companyID"`
	SecureQuestion string `json:"secureQuestion"`
	SecureAnswer   string `json:"secureAnswer"`
}

type SignupOutput struct {
	ID             string `json:"id"`
	Email          string `json:"email"`
	Password       string `json:"password"`
	FirstName      string `json:"firstName"`
	LastName       string `json:"lastName"`
	PhoneNumber    string `json:"phoneNumber"`
	UserIdentity   string `json:"userIdentity"`
	CompanyID      string `json:"companyID"`
	SecureQuestion string `json:"secureQuestion"`
	SecureAnswer   string `json:"secureAnswer"`
	Status         string `json:"status"`
}

type LoginOutput struct {
	UserID  string `json:"userID"`
	Message string `json:"password"`
}

type UpdateInput struct {
	Email  string `json:"email"`
	Status string `json:"status"`
}
