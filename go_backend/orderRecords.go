package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"reflect"
	"strings"

	"github.com/gin-gonic/gin"
)

//donation order
func queryDonation(c *gin.Context) {
	//getting data from request
	body := c.Request.Body
	value, err := ioutil.ReadAll(body)
	if err != nil {
		fmt.Println(err.Error())
	}
	type Signup struct {
		// ID
		FoodName     string `json:"foodName"`
		FoodCategory string `json:"foodCategory"`
		ExpireDate   string `json:"expireDate"`
		Quantity     string `json:"quantity"`
		Note         string `json:"note"`
		Address      string `json:"address"`
		City         string `json:"city"`
		State        string `json:"state"`
		ZipCode      string `json:"zipCode"`
		PickUpTime   string `json:"pickUpTime"`
		DonorID      string `json:"donorID"`
		DriverID     string `json:"driverID"`
		Status       string `json:"status"`
		// Timestamp string `json:"timestamp"`
	}

	var signup Signup
	er := json.Unmarshal([]byte(value), &signup)
	if er != nil {
		fmt.Println(err.Error())
	}
	e := reflect.ValueOf(&signup).Elem()
	foodName := fmt.Sprint(e.Field(0).Interface())
	foodCategory := fmt.Sprint(e.Field(1).Interface())
	expireDate := fmt.Sprint(e.Field(2).Interface())
	quantity := fmt.Sprint(e.Field(3).Interface())
	note := fmt.Sprint(e.Field(4).Interface())
	address := fmt.Sprint(e.Field(5).Interface())
	city := fmt.Sprint(e.Field(6).Interface())
	state := fmt.Sprint(e.Field(7).Interface())
	zipCode := fmt.Sprint(e.Field(8).Interface())
	pickUpTime := fmt.Sprint(e.Field(9).Interface())
	donorID := fmt.Sprint(e.Field(10).Interface())
	driverID := fmt.Sprint(e.Field(11).Interface())
	status := fmt.Sprint(e.Field(12).Interface())

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
	insert, err := db.Query("INSERT INTO donation VALUES(DEFAULT,?,?,?,?,?,?,?,?,?,?,?,?,?,DEFAULT)", foodName, foodCategory, expireDate, quantity, note, address, city, state, zipCode, pickUpTime, donorID, driverID, status)

	if err != nil {
		fmt.Println("This donation order can not be submitted")
		if strings.Contains(err.Error(), "Access denied") {
			c.JSON(500, gin.H{
				"message": "DB access error, username or password is wrong",
			})
			panic(err.Error())
		}
		c.JSON(500, gin.H{
			"message": "This donation order can not be submitted",
		})
		panic(err.Error())
	} else {
		c.JSON(201, gin.H{
			"message": "This donation order has been assigned or created",
		})
	}
	defer insert.Close()
}

// request order
func queryRequest(c *gin.Context) {
	//getting data from request
	body := c.Request.Body
	value, err := ioutil.ReadAll(body)
	if err != nil {
		fmt.Println(err.Error())
	}
	type Signup struct {
		// ID
		FoodName     string `json:"foodName"`
		FoodCategory string `json:"foodCategory"`
		ExpireDate   string `json:"expireDate"`
		Quantity     string `json:"quantity"`
		Note         string `json:"note"`
		Address      string `json:"address"`
		City         string `json:"city"`
		State        string `json:"state"`
		ZipCode      string `json:"zipCode"`
		PickUpTime   string `json:"pickUpTime"`
		DonorID      string `json:"donorID"`
		Status       string `json:"status"`
		// Timestamp string `json:"timestamp"`
	}

	var signup Signup
	er := json.Unmarshal([]byte(value), &signup)
	if er != nil {
		fmt.Println(err.Error())
	}
	e := reflect.ValueOf(&signup).Elem()
	foodName := fmt.Sprint(e.Field(0).Interface())
	foodCategory := fmt.Sprint(e.Field(1).Interface())
	expireDate := fmt.Sprint(e.Field(2).Interface())
	quantity := fmt.Sprint(e.Field(3).Interface())
	note := fmt.Sprint(e.Field(4).Interface())
	address := fmt.Sprint(e.Field(5).Interface())
	city := fmt.Sprint(e.Field(6).Interface())
	state := fmt.Sprint(e.Field(7).Interface())
	zipCode := fmt.Sprint(e.Field(8).Interface())
	pickUpTime := fmt.Sprint(e.Field(9).Interface())
	donorID := fmt.Sprint(e.Field(10).Interface())
	status := fmt.Sprint(e.Field(11).Interface())

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
	insert, err := db.Query("INSERT INTO request VALUES(DEFAULT,?,?,?,?,?,?,?,?,?,?,?,?,DEFAULT)", foodName, foodCategory, expireDate, quantity, note, address, city, state, zipCode, pickUpTime, donorID, status)
	if err != nil {
		fmt.Println("This request order can not be submitted")
		if strings.Contains(err.Error(), "Access denied") {
			c.JSON(500, gin.H{
				"message": "DB access error, username or password is wrong",
			})
			panic(err.Error())
		}
		c.JSON(500, gin.H{
			"message": "This donation order can not be submitted",
		})
		panic(err.Error())
	} else {
		c.JSON(201, gin.H{
			"message": "This request order has been assigned or created",
		})
	}
	defer insert.Close()
}
