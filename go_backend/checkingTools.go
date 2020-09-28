package main

import (
	"database/sql"
	"log"
	"regexp"
	"strings"

	"github.com/gin-gonic/gin"
)

var emailRegex = regexp.MustCompile("^[a-zA-Z0-9.!#$%&'*+\\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$")

// isEmailValid checks if the email provided passes the required structure and length.
func isEmailValid(e string) bool {
	if len(e) < 3 && len(e) > 254 {
		return false
	}
	return emailRegex.MatchString(e)
}

func getUser(userEmail string, c *gin.Context, db *sql.DB) {
	//select userID from db
	var (
		id             int
		email          string
		password       string
		firstName      string
		lastName       string
		phoneNumber    string
		userIdentity   string
		companyID      string
		secureQuestion string
		secureAnswer   string
		timestamp      string
	)
	rows, err := db.Query("SELECT * from user WHERE email = ?", userEmail)
	if err != nil {
		if strings.Contains(err.Error(), "Access denied") {
			c.JSON(500, gin.H{
				"httpCode": "500",
				"message":  "DB access error, username or password is wrong",
			})
			panic(err.Error())
		}
		c.JSON(500, gin.H{
			"httpCode": "500",
			"message":  "Query statements has something wrong",
		})
		panic(err.Error())
	} else {
		for rows.Next() {
			err := rows.Scan(&id, &email, &password, &firstName, &lastName, &phoneNumber, &userIdentity, &companyID, &secureQuestion, &secureAnswer, &timestamp)
			if err != nil {
				log.Fatal(err)
			}
		}
		if id == 0 {
			c.JSON(404, gin.H{
				"httpCode": "404",
				"message":  "Such user does not exist",
			})
		} else {
			c.JSON(200, gin.H{
				"httpCode":       "200",
				"id":             id,
				"email":          email,
				"password":       password,
				"firstName":      firstName,
				"lastName":       lastName,
				"phoneNumber":    phoneNumber,
				"userIdentity":   userIdentity,
				"companyID":      companyID,
				"secureQuestion": secureQuestion,
				"secureAnswer":   secureAnswer,
				"timestamp":      timestamp,
			})
		}

	}
	defer rows.Close()
}

func getCompany(comName string, c *gin.Context, db *sql.DB) {
	//select userID from db
	var (
		id          int
		companyName string
		fedID       string
		einID       string
		timestamp   string
	)
	rows, err := db.Query("SELECT * from company WHERE companyName = ?", comName)
	if err != nil {
		if strings.Contains(err.Error(), "Access denied") {
			c.JSON(500, gin.H{
				"httpCode": "500",
				"message":  "DB access error, username or password is wrong",
			})
			panic(err.Error())
		}
		c.JSON(500, gin.H{
			"httpCode": "500",
			"message":  "Query statements has something wrong",
		})
		panic(err.Error())
	} else {
		for rows.Next() {
			err := rows.Scan(&id, &companyName, &fedID, &einID, &timestamp)
			if err != nil {
				log.Fatal(err)
			}
		}
		if id == 0 {
			c.JSON(404, gin.H{
				"httpCode": "404",
				"message":  "Such company does not exist",
			})
		} else {
			c.JSON(200, gin.H{
				"httpCode":    "200",
				"id":          id,
				"companyName": companyName,
				"fedID":       fedID,
				"einID":       einID,
				"timestamp":   timestamp,
			})
		}

	}
	defer rows.Close()
}
