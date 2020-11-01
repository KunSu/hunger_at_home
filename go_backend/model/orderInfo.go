package model

type AddItemInput struct {
	FoodName     string `json:"foodName"`
	FoodCategory string `json:"foodCategory"`
	ExpireDate   string `json:"expireDate"`
	Quantity     string `json:"quantity"`
	Temperature  string `json:"temperature"`
	// Timestamp string `json:"timestamp"`
}

type AddOrderInput struct {
	Note       string `json:"note"`
	AddressID  string `json:"addressID"`
	PickUpTime string `json:"pickUpTime"`
	Status     string `json:"status"`
	OrderType  string `json:"orderType"`
	// Timestamp string `json:"timestamp"`
}

type UpdateOrderStatusInput struct {
	ID     string `json:"id"`
	Status string `json:"status"`
}

type UpdateTemperatureInput struct {
	ID          string `json:"id"`
	Temperature string `json:"temperature"`
}

type OrderAssociateInput struct {
	// ID
	OrderID     string `json:"orderID"`
	DriverID    string `json:"driverID"`
	DonorID     string `json:"donorID"`
	RecipientID string `json:"recipientID"`
	AdminID     string `json:"adminID"`
	// Timestamp string `json:"timestamp"`
}

type OrderItemInput struct {
	// ID
	OrderID string `json:"orderID"`
	ItemID  string `json:"itemID"`
	// Timestamp string `json:"timestamp"`
}

type UpdateOrderAssociateInput struct {
	OrderID     string `json:"orderID"`
	DriverID    string `json:"driverID"`
	DonorID     string `json:"donorID"`
	RecipientID string `json:"recipientID"`
	AdminID     string `json:"adminID"`
}

type GetOrderListByUserIDInput struct {
	UserID string `json:"userID"`
	Status string `json:"status"`
	Amount string `json:"amount"`
}

type GetOrderListByUserIDOutput struct {
	Note       string `json:"note"`
	Address    string `json:"address"`
	PickUpTime string `json:"pickUpTime"`
	OrderType  string `json:"orderType"`
}
