package main

import (
	"fmt"
	"io/ioutil"
	"log"

	"github.com/gin-gonic/gin"
	_ "github.com/go-sql-driver/mysql"
)

func postTest(c *gin.Context) {
	body := c.Request.Body
	value, err := ioutil.ReadAll(body)
	if err != nil {
		fmt.Println(err.Error())
	}
	c.JSON(200, gin.H{
		"message": string(value),
	})
}

func homePage(c *gin.Context) {
	c.JSON(200, gin.H{
		"message": "Hello World",
	})
}

//sign up function
func querySignUp(c *gin.Context) {
	//getting data from request

	//TODO: use payload body to transfer data
	email := c.Query("email")
	password := c.Query("password")
	firstName := c.Query("firstName")
	lastName := c.Query("lastName")
	phoneNumber := c.Query("phoneNumber")
	userIdentity := c.Query("userIdentity")

	if !isEmailValid(email) {
		c.JSON(404, gin.H{
			"httpCode": "404",
			"message":  "The email address is not valid",
		})
	}

	// connect to the db
	db := connectDB(c)
	defer db.Close()
	//insert to db
	insert, err := db.Query("INSERT INTO userinfo VALUES(DEFAULT,?,?,?,?,?,?)", email, password, firstName, lastName, phoneNumber, userIdentity)

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

//login function
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

//resetPassword
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

//donor company sighup function
func queryCompanySignUp(c *gin.Context) {
	//getting data from request
	//userID := c.Query("userID")
	companyName := c.Query("companyName")
	address := c.Query("address")
	city := c.Query("city")
	state := c.Query("state")
	zipCode := c.Query("zipCode")
	fedID := c.Query("fedID")
	einID := c.Query("einID")

	// connect to the db
	db := connectDB(c)
	defer db.Close()
	//insert to db
	insert, err := db.Query("INSERT INTO companyInfo VALUES(DEFAULT,?,?,?,?,?,?,?)", companyName, address, city, state, zipCode, fedID, einID)

	if err != nil {
		fmt.Println("Sign up error")
		c.JSON(500, gin.H{
			"httpCode": "500",
			"message":  "Signup is not vailed",
		})
		panic(err.Error())
	} else {
		c.JSON(201, gin.H{
			"httpCode": "201",
			"message":  "Company has been assigned or created",
		})
	}
	defer insert.Close()
}
