package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"reflect"

	"github.com/gin-gonic/gin"
	_ "github.com/go-sql-driver/mysql"
)

func homePage(c *gin.Context) {
	c.JSON(200, gin.H{
		"message": "Hello World",
	})
}

//sign up function
func querySignUp(c *gin.Context) {
	//getting data from request
	body := c.Request.Body
	value, err := ioutil.ReadAll(body)
	if err != nil {
		fmt.Println(err.Error())
	}
	type Signup struct {
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

	var signup Signup
	er := json.Unmarshal([]byte(value), &signup)
	if er != nil {
		fmt.Println(err.Error())
	}
	e := reflect.ValueOf(&signup).Elem()
	email := fmt.Sprint(e.Field(0).Interface())
	password := fmt.Sprint(e.Field(1).Interface())
	firstName := fmt.Sprint(e.Field(2).Interface())
	lastName := fmt.Sprint(e.Field(3).Interface())
	phoneNumber := fmt.Sprint(e.Field(4).Interface())
	userIdentity := fmt.Sprint(e.Field(5).Interface())
	companyID := fmt.Sprint(e.Field(6).Interface())
	secureQuestion := fmt.Sprint(e.Field(7).Interface())
	secureAnswer := fmt.Sprint(e.Field(8).Interface())

	if !isEmailValid(email) {
		c.JSON(404, gin.H{
			"httpCode": "404",
			"message":  "The email address is not valid",
		})
	}

	// c.JSON(200, gin.H{
	// 	"email":          string(email),
	// 	"password":       string(password),
	// 	"firstName":      string(firstName),
	// 	"lastName":       string(lastName),
	// 	"phoneNumber":    string(phoneNumber),
	// 	"userIdentity":   string(userIdentity),
	// 	"companyID":      string(companyID),
	// 	"secureQuestion": string(secureQuestion),
	// 	"secureAnswer":   string(secureAnswer),
	// })

	// connect to the db
	db := connectDB(c)
	defer db.Close()
	//insert to db
	insert, err := db.Query("INSERT INTO user VALUES(DEFAULT,?,?,?,?,?,?,?,?,?,DEFAULT)", email, password, firstName, lastName, phoneNumber, userIdentity, companyID, secureQuestion, secureAnswer)

	if err != nil {
		fmt.Println("Sign up error")
		c.JSON(404, gin.H{
			"httpCode": "404",
			"message":  "This email address is already taken",
		})
		panic(err.Error())
	} else {
		c.JSON(201, gin.H{
			"httpCode": "201",
			"message":  "Congrats! Your signup is successful",
		})
	}
	defer insert.Close()
}

//Login Function
func queryLogin(c *gin.Context) {
	//getting data from request
	email := c.Query("email")
	password := c.Query("password")

	//TODO: MD5 for encode and decode password

	// connect to the db
	db := connectDB(c)
	defer db.Close()
	//select userID from db
	var (
		userID int
	)
	rows, err := db.Query("SELECT userID from userinfo WHERE email = ? AND password = ?", email, password)
	if err != nil {
		fmt.Println("Login error")
		c.JSON(404, gin.H{
			"httpCode": "404",
			"message":  "Such username or password is incorrect",
		})
		panic(err.Error())
	} else {
		for rows.Next() {
			err := rows.Scan(&userID)
			if err != nil {
				log.Fatal(err)
			}
		}
		if userID == 0 {
			c.JSON(404, gin.H{
				"httpCode": "404",
				"message":  "Such username or password is incorrect",
			})
		} else {
			c.JSON(200, gin.H{
				"httpCode": "200",
				"userID":   userID,
				"message":  "User Found",
			})
		}

	}
	defer rows.Close()
}

//Reset Password, TODO: need to be improved later
func queryResetPassword(c *gin.Context) {
	//getting data from request
	email := c.Query("email")
	password := c.Query("password")
	rePassword := c.Query("rePassword")

	// connect to the db
	db := connectDB(c)
	defer db.Close()
	//update to db
	if rePassword != password {
		c.JSON(404, gin.H{
			"httpCode": "404",
			"message":  "Password and confirmed password do not match",
		})
	} else {
		update, err := db.Query("UPDATE userinfo SET password = ? WHERE email = ?", password, email)
		if err != nil {
			fmt.Println("update error")
			c.JSON(404, gin.H{
				"httpCode": "404",
				"message":  "Update is not vailed",
			})
			panic(err.Error())
		} else {
			c.JSON(200, gin.H{
				"httpCode": "200",
				"message":  "Password is updated",
			})

		}
		defer update.Close()
	}
}
