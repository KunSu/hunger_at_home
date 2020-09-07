package main

import (
	"database/sql"
	"fmt"
	"log"

	"github.com/gin-gonic/gin"
	_ "github.com/go-sql-driver/mysql"
)

func homePage(c *gin.Context) {
	c.JSON(200, gin.H{
		"message": "Hello World",
	})
}

// func postHomePage(c *gin.Context) {
// 	body := c.Request.Body
// 	value, err := ioutil.ReadAll(body)
// 	if err != nil {
// 		fmt.Println(err.Error())
// 	}
// 	c.JSON(200, gin.H{
// 		"message": string(value),
// 	})
// }

//sign up function
func querySignUp(c *gin.Context) {
	//getting data from request
	// userID := c.Query("userID")
	email := c.Query("email")
	password := c.Query("password")
	firstName := c.Query("firstName")
	lastName := c.Query("lastName")
	phoneNumber := c.Query("phoneNumber")
	userIdentity := c.Query("userIdentity")

	//connect to the db
	db, err := sql.Open("mysql", "root:@tcp(127.0.0.1:3306)/foodapp")
	if err != nil {
		fmt.Println("DB connection error")
		c.JSON(200, gin.H{
			"httpCode": "500",
			"message":  "Database is not connected",
		})
		panic(err.Error())
	} else {
		fmt.Println("DB Connected!")
	}
	defer db.Close()

	//insert to db
	insert, err := db.Query("INSERT INTO userinfo VALUES(DEFAULT,?,?,?,?,?,?)", email, password, firstName, lastName, phoneNumber, userIdentity)

	if err != nil {
		fmt.Println("Sign up error")
		c.JSON(200, gin.H{
			"httpCode": "500",
			"message":  "Signup is not vailed",
		})
		panic(err.Error())
	} else {
		c.JSON(200, gin.H{
			"httpCode": "201",
			"message":  "User created",
		})
	}
	defer insert.Close()
}

//login function
func queryLogin(c *gin.Context) {
	//getting data from request
	email := c.Query("email")
	password := c.Query("password")

	//connect to the db
	db, err := sql.Open("mysql", "root:@tcp(127.0.0.1:3306)/foodapp")
	if err != nil {
		fmt.Println("DB connection error")
		c.JSON(200, gin.H{
			"httpCode": "500",
			"message":  "Database is not connected",
		})
		panic(err.Error())
	} else {
		fmt.Println("DB Connected!")
	}
	defer db.Close()

	//select userID from db
	var (
		userID int
	)
	rows, err := db.Query("SELECT userID from userinfo WHERE email = ? AND password = ?", email, password)
	if err != nil {
		fmt.Println("Login error")
		c.JSON(200, gin.H{
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
			c.JSON(200, gin.H{
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

	//connect to the db
	db, err := sql.Open("mysql", "root:@tcp(127.0.0.1:3306)/foodapp")
	if err != nil {
		fmt.Println("DB connection error")
		c.JSON(200, gin.H{
			"httpCode": "500",
			"message":  "Database is not connected",
		})
		panic(err.Error())
	} else {
		fmt.Println("DB Connected!")
	}
	defer db.Close()

	//update to db
	if rePassword != password {
		c.JSON(200, gin.H{
			"httpCode": "500",
			"message":  "Password and confirmed password do not match",
		})
	} else {
		update, err := db.Query("UPDATE userinfo SET password = ? WHERE email = ?", password, email)
		if err != nil {
			fmt.Println("update error")
			c.JSON(200, gin.H{
				"httpCode": "500",
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

// func pathParameters(c *gin.Context) {
// 	name := c.Param("name")
// 	age := c.Param("age")

// 	c.JSON(200, gin.H{
// 		"name": name,
// 		"age":  age,
// 	})
// }
func main() {
	fmt.Println("Hello World")

	r := gin.Default()
	r.GET("/", homePage)
	// r.POST("/", postHomePage)
	r.GET("/signup", querySignUp)
	r.GET("/login", queryLogin)
	r.GET("/reset", queryResetPassword)
	// r.GET("/path/:name/:age", pathParameters) //query/zhadanren/233
	r.Run()
}
