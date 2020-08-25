package main

import (
	"database/sql"
	"fmt"

	"github.com/gin-gonic/gin"
	_ "github.com/go-sql-driver/mysql"
)

// func homePage(c *gin.Context) {
// 	c.JSON(200, gin.H{
// 		"message": "Hello World",
// 	})
// }

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

func queryStrings(c *gin.Context) {
	//getting data from request
	userID := c.Query("userID")
	userName := c.Query("userName")
	password := c.Query("password")
	userIdentity := c.Query("userIdentity")

	//connect to the db
	db, err := sql.Open("mysql", "root:@tcp(127.0.0.1:3306)/foodapp")
	if err != nil {
		panic(err.Error())
	}
	defer db.Close()
	fmt.Println("Connected!")

	//insert to db
	insert, err := db.Query("INSERT INTO userinfo VALUES(?,?,?,?)", userID, userName, password, userIdentity)
	if err != nil {
		panic(err.Error())
	}
	defer insert.Close()

	c.JSON(200, gin.H{
		"userID":       userID,
		"userName":     userName,
		"password":     password,
		"userIdentity": userIdentity,
	})
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
	// r.GET("/", homePage)
	// r.POST("/", postHomePage)
	r.GET("/query", queryStrings) // query?name=zhadanren&age=233
	// r.GET("/path/:name/:age", pathParameters) //query/zhadanren/233
	r.Run()
}
