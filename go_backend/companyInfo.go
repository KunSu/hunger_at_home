package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"reflect"
	"strings"

	"github.com/gin-gonic/gin"
)

//Company sighup function
func queryCompanySignUp(c *gin.Context) {
	//getting data from request
	body := c.Request.Body
	value, err := ioutil.ReadAll(body)
	if err != nil {
		fmt.Println(err.Error())
	}
	type Signup struct {
		CompanyName string `json:"companyName"`
		FedID       string `json:"fedID"`
		EinID       string `json:"einID"`
	}

	var signup Signup
	er := json.Unmarshal([]byte(value), &signup)
	if er != nil {
		fmt.Println(err.Error())
	}
	e := reflect.ValueOf(&signup).Elem()
	companyName := fmt.Sprint(e.Field(0).Interface())
	fedID := fmt.Sprint(e.Field(1).Interface())
	einID := fmt.Sprint(e.Field(2).Interface())

	// connect to the db
	db, err := connectDB(c)
	if err != nil {
		fmt.Println("DB error")
		c.JSON(500, gin.H{
			"message": "DB connection problem",
		})
		panic(err.Error())
	}

	//insert to db
	insert, err := db.Query("INSERT INTO company VALUES(DEFAULT,?,?,?,DEFAULT)", companyName, fedID, einID)

	if err != nil {
		fmt.Println("Sign up error")
		if strings.Contains(err.Error(), "Access denied") {
			c.JSON(500, gin.H{
				"message": "DB access error, username or password is wrong",
			})
			panic(err.Error())
		}
		c.JSON(404, gin.H{
			"message": "Company name is already taken",
		})
		panic(err.Error())
	} else {
		getCompany(companyName, c, db)
	}
	defer db.Close()
	defer insert.Close()
}

//Company Address signup function
func queryAddressSignUp(c *gin.Context) {
	//getting data from request
	body := c.Request.Body
	value, err := ioutil.ReadAll(body)
	if err != nil {
		fmt.Println(err.Error())
	}
	type Signup struct {
		Address string `json:"address"`
		City    string `json:"city"`
		State   string `json:"state"`
		ZipCode string `json:"zipCode"`
	}

	var signup Signup
	er := json.Unmarshal([]byte(value), &signup)
	if er != nil {
		fmt.Println(err.Error())
	}
	e := reflect.ValueOf(&signup).Elem()
	address := fmt.Sprint(e.Field(0).Interface())
	city := fmt.Sprint(e.Field(1).Interface())
	state := fmt.Sprint(e.Field(2).Interface())
	zipCode := fmt.Sprint(e.Field(3).Interface())

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
	insert, err := db.Query("INSERT INTO address VALUES(DEFAULT,?,?,?,?,DEFAULT)", address, city, state, zipCode)
	if err != nil {
		fmt.Println("Sign up error")
		if strings.Contains(err.Error(), "Access denied") {
			c.JSON(500, gin.H{
				"message": "DB access error, username or password is wrong",
			})
			panic(err.Error())
		}
		c.JSON(404, gin.H{
			"message": "This address is already taken",
		})
		panic(err.Error())
	} else {
		c.JSON(201, gin.H{
			"message": "This address has been assigned or created",
		})
	}
	defer insert.Close()
}

//TODO
func queryGetCompany(c *gin.Context) {

	body := c.Request.Body
	value, err := ioutil.ReadAll(body)
	if err != nil {
		fmt.Println(err.Error())
	}
	type Company struct {
		CompanyID string `json:"companyID"`
	}

	var company Company
	er := json.Unmarshal([]byte(value), &company)
	if er != nil {
		fmt.Println(err.Error())
	}
	e := reflect.ValueOf(&company).Elem()
	companyID := fmt.Sprint(e.Field(0).Interface())
	db, err := connectDB(c)
	if err != nil {
		fmt.Println("DB error")
		c.JSON(500, gin.H{
			"message": "DB connection problem",
		})
		panic(err.Error())
	}
	//todo for getting company information

	defer db.Close()
}

//TODO
func queryGetUser(c *gin.Context) {

	body := c.Request.Body
	value, err := ioutil.ReadAll(body)
	if err != nil {
		fmt.Println(err.Error())
	}
	type User struct {
		UserID string `json:"userID"`
	}

	var user User
	er := json.Unmarshal([]byte(value), &user)
	if er != nil {
		fmt.Println(err.Error())
	}
	e := reflect.ValueOf(&company).Elem()
	userID := fmt.Sprint(e.Field(0).Interface())
	db, err := connectDB(c)
	if err != nil {
		fmt.Println("DB error")
		c.JSON(500, gin.H{
			"message": "DB connection problem",
		})
		panic(err.Error())
	}
	//todo for getting user information

	defer db.Close()
}

//TODO.........
func queryCompanyAddressAssociate(c *gin.Context) {
	//getting data from request
	body := c.Request.Body
	value, err := ioutil.ReadAll(body)
	if err != nil {
		fmt.Println(err.Error())
	}
	type Signup struct {
		Address string `json:"address"`
		City    string `json:"city"`
		State   string `json:"state"`
		ZipCode string `json:"zipCode"`
	}

	var signup Signup
	er := json.Unmarshal([]byte(value), &signup)
	if er != nil {
		fmt.Println(err.Error())
	}
	e := reflect.ValueOf(&signup).Elem()
	address := fmt.Sprint(e.Field(0).Interface())
	city := fmt.Sprint(e.Field(1).Interface())
	state := fmt.Sprint(e.Field(2).Interface())
	zipCode := fmt.Sprint(e.Field(3).Interface())

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
	insert, err := db.Query("INSERT INTO address VALUES(DEFAULT,?,?,?,?,DEFAULT)", address, city, state, zipCode)

	if err != nil {
		fmt.Println("Sign up error")
		if strings.Contains(err.Error(), "Access denied") {
			c.JSON(500, gin.H{
				"message": "DB access error, username or password is wrong",
			})
			panic(err.Error())
		}
		c.JSON(500, gin.H{
			"message": "This address is already taken",
		})
		panic(err.Error())
	} else {
		c.JSON(201, gin.H{
			"message": "This address has been assigned or created",
		})
	}
	defer insert.Close()
}
