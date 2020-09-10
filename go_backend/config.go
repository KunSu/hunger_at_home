package main

import (
	"database/sql"
	"fmt"

	"github.com/gin-gonic/gin"
	_ "github.com/go-sql-driver/mysql"
)

const (
	host     = "localhost"
	port     = "3306"
	user     = "root"
	password = ""
	dbName   = "foodapp"
)

func connectDB(c *gin.Context) *sql.DB {
	//connect to the db
	sqlConnect := "root:@tcp(" + host + ":" + port + ")/" + dbName
	db, err := sql.Open("mysql", sqlConnect)
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
	return db
}
