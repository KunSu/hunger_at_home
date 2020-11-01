package controller

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"reflect"
	"strconv"
	"strings"

	"github.com/gin-gonic/gin"
	"github.com/zijianguan0204/hunger_at_home/model"
)

// Create a new item
// @Summary Add a new item
// @Description get item info and parse them to db
// @Tags order
// @Accept  json
// @Produce  json
// @Param orderInfo body model.AddItemInput true "Add an item"
// @Success 201 {object} model.Message
// @Failure 500 {object} model.Message
// @Failure 404 {object} model.Message
// @Router /order/addItem/ [post]
func (ct *Controller) QueryAddItem(c *gin.Context) {
	//getting data from request
	body := c.Request.Body
	value, err := ioutil.ReadAll(body)
	if err != nil {
		fmt.Println(err.Error())
	}

	var item model.AddItemInput
	er := json.Unmarshal([]byte(value), &item)
	if er != nil {
		fmt.Println(err.Error())
	}
	e := reflect.ValueOf(&item).Elem()
	foodName := fmt.Sprint(e.Field(0).Interface())
	foodCategory := fmt.Sprint(e.Field(1).Interface())
	expireDate := fmt.Sprint(e.Field(2).Interface())
	quantity := fmt.Sprint(e.Field(3).Interface())
	temperature := fmt.Sprint(e.Field(4).Interface())

	// connect to the db
	db, err := connectDB(c)
	if err != nil {
		message := model.Message{
			Message: "DB has something wrong",
		}
		c.JSON(500, message)
		panic(err.Error())
	}

	defer db.Close()
	//insert to db
	insert, err := db.Query("INSERT INTO item VALUES(DEFAULT,?,?,?,?,?,DEFAULT)", foodName, foodCategory, expireDate, quantity, temperature)

	if err != nil {
		fmt.Println("This item can not be submitted")
		if strings.Contains(err.Error(), "Access denied") {
			message := model.Message{
				Message: "DB access error, username or password is wrong",
			}
			c.JSON(500, message)
			panic(err.Error())
		}
		message := model.Message{
			Message: "This item can not be submitted",
		}
		c.JSON(500, message)
		panic(err.Error())
	} else {
		message := model.Message{
			Message: "This item has been created",
		}
		c.JSON(201, message)
	}
	defer insert.Close()
}

// Create a new order
// @Summary Add a new order
// @Description get order info and parse them to db
// @Tags order
// @Accept  json
// @Produce  json
// @Param orderInfo body model.AddOrderInput true "Add an order"
// @Success 201 {object} model.Message
// @Failure 500 {object} model.Message
// @Failure 404 {object} model.Message
// @Router /order/addOrder/ [post]
func (ct *Controller) QueryAddOrder(c *gin.Context) {
	//getting data from request
	body := c.Request.Body
	value, err := ioutil.ReadAll(body)
	if err != nil {
		fmt.Println(err.Error())
	}

	var order model.AddOrderInput
	er := json.Unmarshal([]byte(value), &order)
	if er != nil {
		fmt.Println(err.Error())
	}
	e := reflect.ValueOf(&order).Elem()
	note := fmt.Sprint(e.Field(0).Interface())
	addressID := fmt.Sprint(e.Field(1).Interface())
	pickUpTime := fmt.Sprint(e.Field(2).Interface())
	status := fmt.Sprint(e.Field(3).Interface())
	orderType := fmt.Sprint(e.Field(4).Interface())

	// connect to the db
	db, err := connectDB(c)
	if err != nil {
		message := model.Message{
			Message: "DB has something wrong",
		}
		c.JSON(500, message)
		panic(err.Error())
	}

	defer db.Close()
	//insert to db
	insert, err := db.Query("INSERT INTO orderRecord VALUES(DEFAULT,?,?,?,?,?,DEFAULT)", note, addressID, pickUpTime, status, orderType)
	if err != nil {
		fmt.Println("This order can not be submitted")
		if strings.Contains(err.Error(), "Access denied") {
			message := model.Message{
				Message: "DB has something wrong",
			}
			c.JSON(500, message)
			panic(err.Error())
		}
		message := model.Message{
			Message: "This order can not be submitted",
		}
		c.JSON(500, message)
		panic(err.Error())
	} else {
		message := model.Message{
			Message: "This order has been created",
		}
		c.JSON(201, message)
	}
	defer insert.Close()
}

// Update the status of an existing order
// @Summary Update the order status
// @Description get orderID and status info and update them in db
// @Tags order
// @Accept  json
// @Produce  json
// @Param orderInfo body model.UpdateOrderStatusInput true "update an order status"
// @Success 201 {object} model.Message
// @Failure 500 {object} model.Message
// @Failure 404 {object} model.Message
// @Router /order/updateOrderStatus/ [post]
func (ct *Controller) QueryUpdateOrderStatus(c *gin.Context) {

	body := c.Request.Body
	value, err := ioutil.ReadAll(body)
	if err != nil {
		fmt.Println(err.Error())
	}

	var update model.UpdateOrderStatusInput
	er := json.Unmarshal([]byte(value), &update)
	if er != nil {
		fmt.Println(err.Error())
	}
	e := reflect.ValueOf(&update).Elem()
	id := fmt.Sprint(e.Field(0).Interface())
	status := fmt.Sprint(e.Field(1).Interface())

	// connect to the db
	db, err := connectDB(c)
	if db == nil {
		message := model.Message{
			Message: "DB has something wrong",
		}
		c.JSON(500, message)
		panic(err.Error())
	}

	updateQuery, err := db.Query("UPDATE orderRecord SET status = ? WHERE id = ?", status, id)
	if err != nil {
		fmt.Println("Update error")
		if strings.Contains(err.Error(), "Access denied") {
			message := model.Message{
				Message: "DB access error, username or password is wrong",
			}
			c.JSON(500, message)
			panic(err.Error())
		}
		message := model.Message{
			Message: "Does not found such order",
		}
		c.JSON(404, message)
		panic(err.Error())
	} else { //TODO:check if item exist...
		message := model.Message{
			Message: "The order status has been updated",
		}
		c.JSON(201, message)
	}
	defer updateQuery.Close()
	defer db.Close()
}

// Get order list
// @Summary Get order details by donor ID while status is not input status
// @Description DonorID, the status exclude and amount of records as input
// @Tags order
// @Accept  json
// @Produce  json
// @Param orderInfo body model.GetOrderListByUserIDInput true "get an order list with amount of records exclude input status by its donor ID"
// @Success 200 {array} model.GetOrderListByUserIDOutput
// @Failure 500 {object} model.Message
// @Failure 404 {object} model.Message
// @Router /order/getOrderListByDonorID/ [post]
func (ct *Controller) QueryGetOrderListByDonorID(c *gin.Context) {
	body := c.Request.Body
	value, err := ioutil.ReadAll(body)
	if err != nil {
		fmt.Println(err.Error())
	}

	var input model.GetOrderListByUserIDInput
	er := json.Unmarshal([]byte(value), &input)
	if er != nil {
		fmt.Println(err.Error())
	}
	e := reflect.ValueOf(&input).Elem()
	userID := fmt.Sprint(e.Field(0).Interface())
	status := fmt.Sprint(e.Field(1).Interface())
	amount := fmt.Sprint(e.Field(2).Interface())
	amountInt, _ := strconv.Atoi(amount)
	//connect to DB
	db, err := connectDB(c)
	if err != nil {
		message := model.Message{
			Message: "DB has something wrong",
		}
		c.JSON(500, message)
		panic(err.Error())
	}
	defer db.Close()
	//get company names
	var (
		note       string
		addressID  string
		pickUpTime string
		orderType  string
	)

	orderList := []model.GetOrderListByUserIDOutput{}
	counter := 0

	rows, err := db.Query("SELECT orderRecord.note, orderRecord.addressID, orderRecord.pickUpTime, orderRecord.orderType FROM orderRecord INNER JOIN orderAssociate ON orderRecord.id = orderAssociate.orderID WHERE orderAssociate.donorID = ? AND orderRecord.status != ?", userID, status)
	if err != nil {
		if strings.Contains(err.Error(), "Access denied") {
			message := model.Message{
				Message: "DB access error, username or password is wrong",
			}
			c.JSON(500, message)
			panic(err.Error())
		}
		message := model.Message{
			Message: "Query statement has something wrong",
		}
		c.JSON(500, message)
		panic(err.Error())
	} else {
		for rows.Next() {
			err := rows.Scan(&note, &addressID, &pickUpTime, &orderType)
			if err != nil {
				log.Fatal(err)
			}
			orderRecord := model.GetOrderListByUserIDOutput{
				Note:       note,
				Address:    addressID,
				PickUpTime: pickUpTime,
				OrderType:  orderType,
			}
			// fmt.Println(orderRecord)
			// orderInJSON, err := json.Marshal(orderRecord)
			// if err != nil {
			// 	log.Fatal("Cannot encode to JSON ", err)
			// }
			// fmt.Println(string(orderInJSON))
			if counter < amountInt {
				counter = counter + 1
				orderList = append(orderList, orderRecord)
			}
		}
	}
	c.JSON(200, orderList)
	defer rows.Close()
}

// Get order list
// @Summary Get order details by EmployeeID while status is not input status
// @Description EmployeeID, the status exclude and amount of records as input
// @Tags order
// @Accept  json
// @Produce  json
// @Param orderInfo body model.GetOrderListByUserIDInput true "get an order list with amount of records exclude input status by its EmployeeID"
// @Success 200 {array} model.GetOrderListByUserIDOutput
// @Failure 500 {object} model.Message
// @Failure 404 {object} model.Message
// @Router /order/getOrderListByEmployeeID/ [post]
func (ct *Controller) QueryGetOrderListByEmployeeID(c *gin.Context) {
	body := c.Request.Body
	value, err := ioutil.ReadAll(body)
	if err != nil {
		fmt.Println(err.Error())
	}

	var input model.GetOrderListByUserIDInput
	er := json.Unmarshal([]byte(value), &input)
	if er != nil {
		fmt.Println(err.Error())
	}
	e := reflect.ValueOf(&input).Elem()
	userID := fmt.Sprint(e.Field(0).Interface())
	status := fmt.Sprint(e.Field(1).Interface())
	amount := fmt.Sprint(e.Field(2).Interface())
	amountInt, _ := strconv.Atoi(amount)
	//connect to DB
	db, err := connectDB(c)
	if err != nil {
		message := model.Message{
			Message: "DB has something wrong",
		}
		c.JSON(500, message)
		panic(err.Error())
	}
	defer db.Close()
	//get company names
	var (
		note       string
		addressID  string
		pickUpTime string
		orderType  string
	)

	orderList := []model.GetOrderListByUserIDOutput{}
	counter := 0

	rows, err := db.Query("SELECT orderRecord.note, orderRecord.addressID, orderRecord.pickUpTime, orderRecord.orderType FROM orderRecord INNER JOIN orderAssociate ON orderRecord.id = orderAssociate.orderID WHERE orderAssociate.driverID = ? AND orderRecord.status != ?", userID, status)
	if err != nil {
		if strings.Contains(err.Error(), "Access denied") {
			message := model.Message{
				Message: "DB access error, username or password is wrong",
			}
			c.JSON(500, message)
			panic(err.Error())
		}
		message := model.Message{
			Message: "Query statement has something wrong",
		}
		c.JSON(500, message)
		panic(err.Error())
	} else {
		for rows.Next() {
			err := rows.Scan(&note, &addressID, &pickUpTime, &orderType)
			if err != nil {
				log.Fatal(err)
			}
			orderRecord := model.GetOrderListByUserIDOutput{
				Note:       note,
				Address:    addressID,
				PickUpTime: pickUpTime,
				OrderType:  orderType,
			}
			// fmt.Println(orderRecord)
			// orderInJSON, err := json.Marshal(orderRecord)
			// if err != nil {
			// 	log.Fatal("Cannot encode to JSON ", err)
			// }
			// fmt.Println(string(orderInJSON))
			if counter < amountInt {
				counter = counter + 1
				orderList = append(orderList, orderRecord)
			}
		}
	}
	c.JSON(200, orderList)
	defer rows.Close()
}

// Get order list
// @Summary Get order details by RecipientID while status is not input status
// @Description RecipientID, the status exclude and amount of records as input
// @Tags order
// @Accept  json
// @Produce  json
// @Param orderInfo body model.GetOrderListByUserIDInput true "get an order list with amount of records exclude input status by its RecipientID"
// @Success 200 {array} model.GetOrderListByUserIDOutput
// @Failure 500 {object} model.Message
// @Failure 404 {object} model.Message
// @Router /order/getOrderListByRecipientID/ [post]
func (ct *Controller) QueryGetOrderListByRecipientID(c *gin.Context) {
	body := c.Request.Body
	value, err := ioutil.ReadAll(body)
	if err != nil {
		fmt.Println(err.Error())
	}

	var input model.GetOrderListByUserIDInput
	er := json.Unmarshal([]byte(value), &input)
	if er != nil {
		fmt.Println(err.Error())
	}
	e := reflect.ValueOf(&input).Elem()
	userID := fmt.Sprint(e.Field(0).Interface())
	status := fmt.Sprint(e.Field(1).Interface())
	amount := fmt.Sprint(e.Field(2).Interface())
	amountInt, _ := strconv.Atoi(amount)
	//connect to DB
	db, err := connectDB(c)
	if err != nil {
		message := model.Message{
			Message: "DB has something wrong",
		}
		c.JSON(500, message)
		panic(err.Error())
	}
	defer db.Close()
	//get company names
	var (
		note       string
		addressID  string
		pickUpTime string
		orderType  string
	)

	orderList := []model.GetOrderListByUserIDOutput{}
	counter := 0

	rows, err := db.Query("SELECT orderRecord.note, orderRecord.addressID, orderRecord.pickUpTime, orderRecord.orderType FROM orderRecord INNER JOIN orderAssociate ON orderRecord.id = orderAssociate.orderID WHERE orderAssociate.recipientID = ? AND orderRecord.status != ?", userID, status)
	if err != nil {
		if strings.Contains(err.Error(), "Access denied") {
			message := model.Message{
				Message: "DB access error, username or password is wrong",
			}
			c.JSON(500, message)
			panic(err.Error())
		}
		message := model.Message{
			Message: "Query statement has something wrong",
		}
		c.JSON(500, message)
		panic(err.Error())
	} else {
		for rows.Next() {
			err := rows.Scan(&note, &addressID, &pickUpTime, &orderType)
			if err != nil {
				log.Fatal(err)
			}
			orderRecord := model.GetOrderListByUserIDOutput{
				Note:       note,
				Address:    addressID,
				PickUpTime: pickUpTime,
				OrderType:  orderType,
			}
			// fmt.Println(orderRecord)
			// orderInJSON, err := json.Marshal(orderRecord)
			// if err != nil {
			// 	log.Fatal("Cannot encode to JSON ", err)
			// }
			// fmt.Println(string(orderInJSON))
			if counter < amountInt {
				counter = counter + 1
				orderList = append(orderList, orderRecord)
			}
		}
	}
	c.JSON(200, orderList)
	defer rows.Close()
}

// Update the temperature of an existing item
// @Summary Update the order status
// @Description get itemID and temperture info and update them in db
// @Tags order
// @Accept  json
// @Produce  json
// @Param orderInfo body model.UpdateTemperatureInput true "update an item temperature"
// @Success 201 {object} model.Message
// @Failure 500 {object} model.Message
// @Failure 404 {object} model.Message
// @Router /order/updateItemTemperature/ [post]
func (ct *Controller) QueryUpdateItemTemperature(c *gin.Context) {

	body := c.Request.Body
	value, err := ioutil.ReadAll(body)
	if err != nil {
		fmt.Println(err.Error())
	}

	var update model.UpdateTemperatureInput
	er := json.Unmarshal([]byte(value), &update)
	if er != nil {
		fmt.Println(err.Error())
	}
	e := reflect.ValueOf(&update).Elem()
	id := fmt.Sprint(e.Field(0).Interface())
	temperature := fmt.Sprint(e.Field(1).Interface())

	// connect to the db
	db, err := connectDB(c)
	if db == nil {
		message := model.Message{
			Message: "DB has something wrong",
		}
		c.JSON(500, message)
		panic(err.Error())
	}

	updateQuery, err := db.Query("UPDATE item SET temperature = ? WHERE id = ?", temperature, id)
	if err != nil {
		fmt.Println("Update error")
		if strings.Contains(err.Error(), "Access denied") {
			message := model.Message{
				Message: "DB access error, username or password is wrong",
			}
			c.JSON(500, message)
			panic(err.Error())
		}
		message := model.Message{
			Message: "Did not found such item",
		}
		c.JSON(404, message)
		panic(err.Error())
	} else { //TODO:check if item exist...
		message := model.Message{
			Message: "This item temperature has been updated",
		}
		c.JSON(201, message)
	}
	defer updateQuery.Close()
	defer db.Close()
}

// Create a new orderAssociate record
// @Summary Add a new orderAssociate record
// @Description get orderAssociate record and parse them to db
// @Tags order
// @Accept  json
// @Produce  json
// @Param orderInfo body model.OrderAssociateInput true "Add an orderAssociate record"
// @Success 201 {object} model.Message
// @Failure 500 {object} model.Message
// @Failure 404 {object} model.Message
// @Router /order/addOrderAssociate/ [post]
func (ct *Controller) QueryAddOrderAssociate(c *gin.Context) {
	//getting data from request
	body := c.Request.Body
	value, err := ioutil.ReadAll(body)
	if err != nil {
		fmt.Println(err.Error())
	}

	var orderItem model.OrderAssociateInput
	er := json.Unmarshal([]byte(value), &orderItem)
	if er != nil {
		fmt.Println(err.Error())
	}
	e := reflect.ValueOf(&orderItem).Elem()
	orderID := fmt.Sprint(e.Field(0).Interface())
	driverID := fmt.Sprint(e.Field(1).Interface())
	donorID := fmt.Sprint(e.Field(2).Interface())
	recipientID := fmt.Sprint(e.Field(3).Interface())
	adminID := fmt.Sprint(e.Field(4).Interface())

	// connect to the db
	db, err := connectDB(c)
	if err != nil {
		message := model.Message{
			Message: "DB has something wrong",
		}
		c.JSON(500, message)
		panic(err.Error())
	}

	defer db.Close()
	//insert to db
	insert, err := db.Query("INSERT INTO orderAssociate VALUES(?,?,?,?,?,DEFAULT)", orderID, driverID, donorID, recipientID, adminID)
	if err != nil {
		fmt.Println("This record can not be submitted")
		if strings.Contains(err.Error(), "Access denied") {
			message := model.Message{
				Message: "DB access error, username or password is wrong",
			}
			c.JSON(500, message)
			panic(err.Error())
		}
		message := model.Message{
			Message: "This record can not be found",
		}
		c.JSON(404, message)
		panic(err.Error())
	} else {
		c.JSON(201, gin.H{
			"message": "This record has been assigned or created",
		})
	}
	defer insert.Close()
}

// Create a new orderItem associate record
// @Summary Add a new orderItem record
// @Description get orderItem record and parse them to db
// @Tags order
// @Accept  json
// @Produce  json
// @Param orderInfo body model.OrderItemInput true "Add an orderItem record"
// @Success 201 {object} model.Message
// @Failure 500 {object} model.Message
// @Failure 404 {object} model.Message
// @Router /order/addOrderItemAssociate/ [post]
func (ct *Controller) QueryAddItemOrderAssociate(c *gin.Context) {
	//getting data from request
	body := c.Request.Body
	value, err := ioutil.ReadAll(body)
	if err != nil {
		fmt.Println(err.Error())
	}

	var orderItem model.OrderItemInput
	er := json.Unmarshal([]byte(value), &orderItem)
	if er != nil {
		fmt.Println(err.Error())
	}
	e := reflect.ValueOf(&orderItem).Elem()
	orderID := fmt.Sprint(e.Field(0).Interface())
	itemID := fmt.Sprint(e.Field(1).Interface())

	fmt.Println(orderID)
	fmt.Println(itemID)

	// connect to the db
	db, err := connectDB(c)
	if err != nil {
		message := model.Message{
			Message: "DB has something wrong",
		}
		c.JSON(500, message)
		panic(err.Error())
	}

	defer db.Close()
	//insert to db
	insert, err := db.Query("INSERT INTO orderItemAssociate VALUES(?,?,DEFAULT)", orderID, itemID)
	if err != nil {
		fmt.Println("This record can not be submitted")
		if strings.Contains(err.Error(), "Access denied") {
			message := model.Message{
				Message: "DB access error, username or password is wrong",
			}
			c.JSON(500, message)
			panic(err.Error())
		}
		message := model.Message{
			Message: "This record can not be submitted",
		}
		c.JSON(404, message)
		panic(err.Error())
	} else {
		message := model.Message{
			Message: "This record has been created",
		}
		c.JSON(201, message)
	}
	defer insert.Close()
}

// Update an OrderAssociate record
// @Summary Update the ID information, used by Admin
// @Description get ID information and update it in db
// @Tags order
// @Accept  json
// @Produce  json
// @Param orderInfo body model.UpdateOrderAssociateInput true "update the ID inforamtion of a record"
// @Success 201 {object} model.Message
// @Failure 500 {object} model.Message
// @Failure 404 {object} model.Message
// @Router /order/updateOrderAssociate/ [post]
func (ct *Controller) QueryUpdateOrderAssociate(c *gin.Context) {

	body := c.Request.Body
	value, err := ioutil.ReadAll(body)
	if err != nil {
		fmt.Println(err.Error())
	}

	var update model.UpdateOrderAssociateInput
	er := json.Unmarshal([]byte(value), &update)
	if er != nil {
		fmt.Println(err.Error())
	}
	e := reflect.ValueOf(&update).Elem()
	orderID := fmt.Sprint(e.Field(0).Interface())
	driverID := fmt.Sprint(e.Field(1).Interface())
	donorID := fmt.Sprint(e.Field(2).Interface())
	recipientID := fmt.Sprint(e.Field(3).Interface())
	adminID := fmt.Sprint(e.Field(4).Interface())

	// connect to the db
	db, err := connectDB(c)
	if db == nil {
		message := model.Message{
			Message: "DB has something wrong",
		}
		c.JSON(500, message)
		panic(err.Error())
	}

	updateQuery, err := db.Query("UPDATE orderAssociate SET driverID = ?, donorID = ?, recipientID = ?, adminID = ? WHERE orderID = ?", driverID, donorID, recipientID, adminID, orderID)
	if err != nil {
		fmt.Println("Update error")
		if strings.Contains(err.Error(), "Access denied") {
			message := model.Message{
				Message: "DB access error, username or password is wrong",
			}
			c.JSON(500, message)
			panic(err.Error())
		}
		message := model.Message{
			Message: "Does not found such order",
		}
		c.JSON(404, message)
		panic(err.Error())
	} else { //TODO:check if order exist...
		message := model.Message{
			Message: "This record has been updated",
		}
		c.JSON(201, message)
	}
	defer updateQuery.Close()
	defer db.Close()
}
