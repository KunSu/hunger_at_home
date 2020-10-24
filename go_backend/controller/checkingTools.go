package controller

import (
	"database/sql"
	"fmt"
	"log"
	"regexp"
	"strings"
	"unicode"

	"github.com/gin-gonic/gin"
	"github.com/zijianguan0204/hunger_at_home/model"
)

var emailRegex = regexp.MustCompile("^[a-zA-Z0-9.!#$%&'*+\\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$")

// isEmailValid checks if the email provided passes the required structure and length.
func isEmailValid(e string) bool {
	email := strings.ToLower(e)
	if len(email) < 3 && len(email) > 254 {
		return false
	}
	return emailRegex.MatchString(email)
}

func isPhoneValid(p string) bool {
	if len(p) != 10 {
		fmt.Print("Length is not valid")
		return false
	}
	for _, v := range p {
		if v < '0' || v > '9' {
			fmt.Print("letter is not valid")
			return false
		}
	}
	return true
}

func IsLetter(s string) bool {
	for _, r := range s {
		if !unicode.IsLetter(r) {
			return false
		}
	}
	return true
}

func getUser(userEmail string, c *gin.Context, db *sql.DB) {
	//select userID from db
	var (
		id             string
		email          string
		password       string
		firstName      string
		lastName       string
		phoneNumber    string
		userIdentity   string
		companyID      string
		secureQuestion string
		secureAnswer   string
		status         string
		timestamp      string
	)
	rows, err := db.Query("SELECT * from user WHERE email = ?", userEmail)
	if err != nil {
		if strings.Contains(err.Error(), "Access denied") {
			message := model.Message{
				Message: "DB access error, username or password is wrong",
			}
			c.JSON(500, message)
			panic(err.Error())
		}
		message := model.Message{
			Message: "Query statements has something wrong",
		}
		c.JSON(500, message)
		panic(err.Error())
	} else {
		for rows.Next() {
			err := rows.Scan(&id, &email, &password, &firstName, &lastName, &phoneNumber, &userIdentity, &companyID, &secureQuestion, &secureAnswer, &status, &timestamp)
			if err != nil {
				log.Fatal(err)
			}
		}
		if id == "0" {
			message := model.Message{
				Message: "Such user does not exist",
			}
			c.JSON(404, message)
		} else {
			signupOutput := model.SignupOutput{
				ID:             id,
				Email:          email,
				Password:       password,
				FirstName:      firstName,
				LastName:       lastName,
				PhoneNumber:    phoneNumber,
				UserIdentity:   userIdentity,
				CompanyID:      companyID,
				SecureQuestion: secureQuestion,
				SecureAnswer:   secureAnswer,
				Status:         status,
			}
			c.JSON(200, signupOutput)
		}

	}
	defer rows.Close()
}

func getCompany(comName string, c *gin.Context, db *sql.DB) {
	//select userID from db
	var (
		id          string
		companyName string
		fedID       string
		einID       string
		timestamp   string
	)
	rows, err := db.Query("SELECT * from company WHERE companyName = ?", comName)
	if err != nil {
		if strings.Contains(err.Error(), "Access denied") {
			message := model.Message{
				Message: "DB access error, username or password is wrong",
			}
			c.JSON(500, message)
			panic(err.Error())
		}
		message := model.Message{
			Message: "Query statements has something wrong",
		}
		c.JSON(500, message)
		panic(err.Error())
	} else {
		for rows.Next() {
			err := rows.Scan(&id, &companyName, &fedID, &einID, &timestamp)
			if err != nil {
				log.Fatal(err)
			}
		}
		if id == "0" {
			message := model.Message{
				Message: "Such company does not exist",
			}
			c.JSON(404, message)
		} else {
			companySignUpOutput := model.CompanySignupOutput{
				ID:          id,
				CompanyName: companyName,
				FedID:       fedID,
				EinID:       einID,
			}
			c.JSON(200, companySignUpOutput)
		}

	}
	defer rows.Close()
}
