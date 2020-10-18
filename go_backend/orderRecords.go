package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"reflect"
	"strings"

	"github.com/gin-gonic/gin"
)

//add an item
func queryAddItem(c *gin.Context) {
	//getting data from request
	body := c.Request.Body
	value, err := ioutil.ReadAll(body)
	if err != nil {
		fmt.Println(err.Error())
	}
	type Item struct {
		// ID
		FoodName     string `json:"foodName"`
		FoodCategory string `json:"foodCategory"`
		ExpireDate   string `json:"expireDate"`
		Quantity     string `json:"quantity"`
		Temperature  string `json:"temperature"`
		// Timestamp string `json:"timestamp"`
	}

	var item Item
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
		fmt.Println("DB error")
		c.JSON(500, gin.H{
			"message": "DB connection problem",
		})
		panic(err.Error())
	}

	defer db.Close()
	//insert to db
	insert, err := db.Query("INSERT INTO item VALUES(DEFAULT,?,?,?,?,?,DEFAULT)", foodName, foodCategory, expireDate, quantity, temperature)

	if err != nil {
		fmt.Println("This item can not be submitted")
		if strings.Contains(err.Error(), "Access denied") {
			c.JSON(500, gin.H{
				"message": "DB access error, username or password is wrong",
			})
			panic(err.Error())
		}
		c.JSON(500, gin.H{
			"message": "This item can not be submitted",
		})
		panic(err.Error())
	} else {
		c.JSON(201, gin.H{
			"message": "This item has been assigned or created",
		})
	}
	defer insert.Close()
}

//add an order
func queryAddOrder(c *gin.Context) {
	//getting data from request
	body := c.Request.Body
	value, err := ioutil.ReadAll(body)
	if err != nil {
		fmt.Println(err.Error())
	}
	type Order struct {
		// ID
		Note       string `json:"note"`
		AddressID  string `json:"addressID"`
		PickUpTime string `json:"pickUpTime"`
		Status     string `json:"status"`
		OrderType  string `json:"orderType"`
		// Timestamp string `json:"timestamp"`
	}

	var order Order
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
	fmt.Println(note)
	fmt.Println(addressID)
	fmt.Println(pickUpTime)
	fmt.Println(status)
	fmt.Println(orderType)

	// connect to the db
	db, err := connectDB(c)
	if err != nil {
		fmt.Println("DB error")
		c.JSON(500, gin.H{
			"message": "DB connection problem",
		})
		panic(err.Error())
	}

	defer db.Close()
	//insert to db
	insert, err := db.Query("INSERT INTO orderRecord VALUES(DEFAULT,?,?,?,?,?,DEFAULT)", note, addressID, pickUpTime, status, orderType)
	if err != nil {
		fmt.Println("This order can not be submitted")
		if strings.Contains(err.Error(), "Access denied") {
			c.JSON(500, gin.H{
				"message": "DB access error, username or password is wrong",
			})
			panic(err.Error())
		}
		c.JSON(500, gin.H{
			"message": "This order can not be submitted",
		})
		panic(err.Error())
	} else {
		c.JSON(201, gin.H{
			"message": "This order has been assigned or created",
		})
	}
	defer insert.Close()
}

//get the order list of a user by donorID and status
func queryGetOrderListByDonorID(c *gin.Context) {
	body := c.Request.Body
	value, err := ioutil.ReadAll(body)
	if err != nil {
		fmt.Println(err.Error())
	}
	type Input struct {
		DonorID string `json:"donorID"`
		Status  string `json:"status"`
	}

	var input Input
	er := json.Unmarshal([]byte(value), &input)
	if er != nil {
		fmt.Println(err.Error())
	}
	e := reflect.ValueOf(&input).Elem()
	donorID := fmt.Sprint(e.Field(0).Interface())
	status := fmt.Sprint(e.Field(1).Interface())
	// fmt.Println(companyID)
	//connect to DB
	db, err := connectDB(c)
	if err != nil {
		fmt.Println("DB error")
		c.JSON(500, gin.H{
			"message": "DB connection problem",
		})
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
	type Order struct {
		Note       string `json:"note"`
		Address    string `json:"address"`
		PickUpTime string `json:"pickUpTime"`
		OrderType  string `json:"orderType"`
	}
	orderList := []string{}

	rows, err := db.Query("SELECT orderRecord.note, orderRecord.addressID, orderRecord.pickUpTime, orderRecord.orderType FROM orderRecord INNER JOIN orderAssociate ON orderRecord.id = orderAssociate.orderID WHERE orderAssociate.donorID = ? AND orderRecord.status = ?", donorID, status)
	if err != nil {
		if strings.Contains(err.Error(), "Access denied") {
			c.JSON(500, gin.H{
				"message": "DB access error, username or password is wrong",
			})
			panic(err.Error())
		}
		c.JSON(500, gin.H{
			"message": "Query statements has something wrong",
		})
		panic(err.Error())
	} else {
		for rows.Next() {
			err := rows.Scan(&note, &addressID, &pickUpTime, &orderType)
			if err != nil {
				log.Fatal(err)
			}
			orderRecord := &Order{
				Note:       note,
				Address:    addressID,
				PickUpTime: pickUpTime,
				OrderType:  orderType,
			}
			// fmt.Println(orderRecord)
			orderInJSON, err := json.Marshal(orderRecord)
			if err != nil {
				log.Fatal("Cannot encode to JSON ", err)
			}
			fmt.Println(string(orderInJSON))
			orderList = append(orderList, string(orderInJSON))
			fmt.Println(orderList)
		}
	}
	listInJSON, err := json.Marshal(orderList)
	if err != nil {
		log.Fatal("Cannot encode to JSON ", err)
	}

	c.String(200, string(listInJSON))
	defer rows.Close()
}

func queryUpdateItemTemperature(c *gin.Context) {

	body := c.Request.Body
	value, err := ioutil.ReadAll(body)
	if err != nil {
		fmt.Println(err.Error())
	}
	type Update struct {
		ID          string `json:"id"`
		Temperature string `json:"temperature"`
	}

	var update Update
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
		fmt.Println("DB has something wrong")
		c.JSON(500, gin.H{
			"message": "DB has something wrong",
		})
		panic(err.Error())
	}

	updateQuery, err := db.Query("UPDATE item SET temperature = ? WHERE id = ?", temperature, id)
	if err != nil {
		fmt.Println("Update error")
		if strings.Contains(err.Error(), "Access denied") {
			c.JSON(500, gin.H{
				"message": "DB access error, username or password is wrong",
			})
			panic(err.Error())
		}
		c.JSON(404, gin.H{
			"message": "Does not found such item",
		})
		panic(err.Error())
	} else { //TODO:check if item exist...
		c.JSON(404, gin.H{
			"message": "Temperature has been updated",
		})
	}
	defer updateQuery.Close()
	defer db.Close()
}

func queryAddOrderAssociate(c *gin.Context) {
	//getting data from request
	body := c.Request.Body
	value, err := ioutil.ReadAll(body)
	if err != nil {
		fmt.Println(err.Error())
	}
	type OrderItem struct {
		// ID
		OrderID     string `json:"orderID"`
		DriverID    string `json:"driverID"`
		DonorID     string `json:"donorID"`
		RecipientID string `json:"recipientID"`
		AdminID     string `json:"adminID"`
		// Timestamp string `json:"timestamp"`
	}

	var orderItem OrderItem
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
		fmt.Println("DB error")
		c.JSON(500, gin.H{
			"message": "DB connection problem",
		})
		panic(err.Error())
	}

	defer db.Close()
	//insert to db
	insert, err := db.Query("INSERT INTO orderAssociate VALUES(?,?,?,?,?,DEFAULT)", orderID, driverID, donorID, recipientID, adminID)
	if err != nil {
		fmt.Println("This record can not be submitted")
		if strings.Contains(err.Error(), "Access denied") {
			c.JSON(500, gin.H{
				"message": "DB access error, username or password is wrong",
			})
			panic(err.Error())
		}
		c.JSON(500, gin.H{
			"message": "This record can not be submitted",
		})
		panic(err.Error())
	} else {
		c.JSON(201, gin.H{
			"message": "This record has been assigned or created",
		})
	}
	defer insert.Close()
}

func queryAddItemOrderAssociate(c *gin.Context) {
	//getting data from request
	body := c.Request.Body
	value, err := ioutil.ReadAll(body)
	if err != nil {
		fmt.Println(err.Error())
	}
	type OrderItem struct {
		// ID
		OrderID string `json:"orderID"`
		ItemID  string `json:"itemID"`
		// Timestamp string `json:"timestamp"`
	}

	var orderItem OrderItem
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
		fmt.Println("DB error")
		c.JSON(500, gin.H{
			"message": "DB connection problem",
		})
		panic(err.Error())
	}

	defer db.Close()
	//insert to db
	insert, err := db.Query("INSERT INTO orderItemAssociate VALUES(?,?,DEFAULT)", orderID, itemID)
	if err != nil {
		fmt.Println("This record can not be submitted")
		if strings.Contains(err.Error(), "Access denied") {
			c.JSON(500, gin.H{
				"message": "DB access error, username or password is wrong",
			})
			panic(err.Error())
		}
		c.JSON(500, gin.H{
			"message": "This record can not be submitted",
		})
		panic(err.Error())
	} else {
		c.JSON(201, gin.H{
			"message": "This record has been assigned or created",
		})
	}
	defer insert.Close()
}

func queryUpdateOrderAssociate(c *gin.Context) {

	body := c.Request.Body
	value, err := ioutil.ReadAll(body)
	if err != nil {
		fmt.Println(err.Error())
	}
	type Update struct {
		OrderID     string `json:"orderID"`
		DriverID    string `json:"driverID"`
		DonorID     string `json:"donorID"`
		RecipientID string `json:"recipientID"`
		AdminID     string `json:"adminID"`
	}

	var update Update
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
		fmt.Println("DB has something wrong")
		c.JSON(500, gin.H{
			"message": "DB has something wrong",
		})
		panic(err.Error())
	}

	updateQuery, err := db.Query("UPDATE orderAssociate SET driverID = ?, donorID = ?, recipientID = ?, adminID = ? WHERE orderID = ?", driverID, donorID, recipientID, adminID, orderID)
	if err != nil {
		fmt.Println("Update error")
		if strings.Contains(err.Error(), "Access denied") {
			c.JSON(500, gin.H{
				"message": "DB access error, username or password is wrong",
			})
			panic(err.Error())
		}
		c.JSON(404, gin.H{
			"message": "Does not found such order",
		})
		panic(err.Error())
	} else { //TODO:check if order exist...
		c.JSON(200, gin.H{
			"message": "Order info has been updated",
		})
	}
	defer updateQuery.Close()
	defer db.Close()
}
