package controller

import (
	"database/sql"
	"errors"
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

func connectDB(c *gin.Context) (*sql.DB, error) {
	//connect to the db
	sqlConnect := user + ":@tcp(" + host + ":" + port + ")/" + dbName
	db, err := sql.Open("mysql", sqlConnect)

	if err != nil {
		fmt.Println("here are some error in db")
		return nil, errors.New("finally you got here! I dont know how but nvm....")
	}
	return db, nil
}
