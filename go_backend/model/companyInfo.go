package model

type CompanySignupInput struct {
	CompanyName string `json:"companyName"`
	FedID       string `json:"fedID"`
	EinID       string `json:"einID"`
}

type CompanySignupOutput struct {
	ID          string `json:"id"`
	CompanyName string `json:"companyName"`
	FedID       string `json:"fedID"`
	EinID       string `json:"einID"`
}

type AddressSignupInput struct {
	Address string `json:"address"`
	City    string `json:"city"`
	State   string `json:"state"`
	ZipCode string `json:"zipCode"`
}

type CompanyAddressRecordSignupInput struct {
	AddressID string `json:"AddressID"`
	CompanyID string `json:"CompanyID"`
}
