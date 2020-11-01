package controller

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"reflect"
	"strings"

	"github.com/gin-gonic/gin"
	_ "github.com/go-sql-driver/mysql"
	"github.com/zijianguan0204/hunger_at_home/model"
)

func homePage(c *gin.Context) {
	c.JSON(200, gin.H{
		"message": "Hello World",
	})
}

//User Signup
// @Summary Add a new user
// @Description get user info and parse them to db
// @Tags user
// @Accept  json
// @Produce  json
// @Param userInfo body model.SignupInput true "Add a user"
// @Success 200 {object} model.SignupOutput
// @Failure 500 {object} model.Message
// @Failure 404 {object} model.Message
// @Router /user/signup/ [post]
func (ct *Controller) QuerySignUp(c *gin.Context) {

	//getting data from request
	body := c.Request.Body
	value, err := ioutil.ReadAll(body)
	if err != nil {
		fmt.Println(err.Error())
	}

	var signupInput model.SignupInput
	//TODO: Try to figure out why
	// if err := c.ShouldBindJSON(&signup); err != nil {
	// 	c.JSON(500, gin.H{
	// 		"message": "Input is not in JSON format",
	// 	})
	// 	return
	// }
	er := json.Unmarshal([]byte(value), &signupInput)
	if er != nil {
		fmt.Println(err.Error())
	}
	e := reflect.ValueOf(&signupInput).Elem()
	email := fmt.Sprint(e.Field(0).Interface())
	password := fmt.Sprint(e.Field(1).Interface())
	firstName := fmt.Sprint(e.Field(2).Interface())
	lastName := fmt.Sprint(e.Field(3).Interface())
	phoneNumber := fmt.Sprint(e.Field(4).Interface())
	userIdentity := fmt.Sprint(e.Field(5).Interface())
	companyID := fmt.Sprint(e.Field(6).Interface())
	secureQuestion := fmt.Sprint(e.Field(7).Interface())
	secureAnswer := fmt.Sprint(e.Field(8).Interface())

	//check identity
	status := "approved"
	if userIdentity == "employee" {
		status = "pending"
	}
	//check if valid email
	if !isEmailValid(email) {
		message := model.Message{
			Message: "The email address is not valid",
		}
		c.JSON(404, message)
		return
	}
	email = strings.ToLower(string(email))

	//check if valid phone
	fmt.Print(len(phoneNumber))
	if !isPhoneValid(phoneNumber) {
		message := model.Message{
			Message: "The phone number is not valid",
		}
		c.JSON(404, message)
		return
	}

	//check if secure question and answer are both only containing alphabit
	if !IsLetter(secureQuestion) || !IsLetter(secureAnswer) {
		message := model.Message{
			Message: "The secure questions/answers are invalid, they should only contain alphabit",
		}
		c.JSON(404, message)
		return
	}
	// connect to the db
	db, err := connectDB(c)
	if db == nil {
		message := model.Message{
			Message: "DB has something wrong",
		}
		c.JSON(500, message)
		panic(err.Error())
	}

	//insert to db
	insert, err := db.Query("INSERT INTO user VALUES(DEFAULT,?,?,?,?,?,?,?,?,?,?,DEFAULT)", email, password, firstName, lastName, phoneNumber, userIdentity, companyID, secureQuestion, secureAnswer, status)
	if err != nil {
		fmt.Println("Sign up error")
		if strings.Contains(err.Error(), "Access denied") {
			message := model.Message{
				Message: "DB access error, username or password is wrong",
			}
			c.JSON(500, message)
			panic(err.Error())
		}
		message := model.Message{
			Message: "This email address is already taken",
		}
		c.JSON(500, message)
		panic(err.Error())
	} else {
		getUser(email, c, db)
	}
	defer db.Close()
	defer insert.Close()

}

// User Login
// @Summary Login using an existing account
// @Description use email address and password to login
// @Tags user
// @Accept  json
// @Produce  json
// @Param email path string true "Email"
// @Param password path string true "Password"
// @Success 200 {object} model.LoginOutput
// @Failure 500 {object} model.Message
// @Failure 404 {object} model.Message
// @Router /user/login/{email}/{password} [get]
func (ct *Controller) QueryLogin(c *gin.Context) {
	//getting data from request
	email := c.Param("email")
	password := c.Param("password")
	email = strings.ToLower(string(email))

	// connect to the db
	db, err := connectDB(c)
	if err != nil {
		message := model.Message{
			Message: "DB has something wrong",
		}
		c.JSON(500, message)
		panic(err.Error())
	}

	defer db.Close()
	//select userID from db
	var (
		userID string
		status string
	)
	rows, err := db.Query("SELECT id, status from user WHERE email = ? AND password = ?", email, password)
	if err != nil {
		fmt.Println("Login error")
		if strings.Contains(err.Error(), "Access denied") {
			message := model.Message{
				Message: "DB access error, username or password is wrong",
			}
			c.JSON(500, message)
			panic(err.Error())
		}
		message := model.Message{
			Message: "Such username or password is incorrect",
		}
		c.JSON(404, message)
		panic(err.Error())
	} else {
		for rows.Next() {
			err := rows.Scan(&userID, &status)
			if err != nil {
				log.Fatal(err)
			}
		}
		if userID == "0" {
			message := model.Message{
				Message: "Such username or password is incorrect",
			}
			c.JSON(404, message)
		} else if status == "pending" {
			message := model.Message{
				Message: "Such user account is in pending",
			}
			c.JSON(404, message)
		} else {
			loginOutput := model.LoginOutput{
				UserID:  userID,
				Message: "User Found",
			}
			c.JSON(200, loginOutput)
		}

	}
	defer rows.Close()
}

////User status update
// @Summary Update a status from "pending" to {status}
// @Description update status by userID
// @Tags user
// @Accept  json
// @Produce  json
// @Param userInfo body model.UpdateInput true "Update user status"
// @Success 200 {object} model.SignupOutput
// @Failure 500 {object} model.Message
// @Failure 404 {object} model.Message
// @Router /user/updateUserStatus/ [post]
func (ct *Controller) QueryUpdateUserStatus(c *gin.Context) {
	body := c.Request.Body
	value, err := ioutil.ReadAll(body)
	if err != nil {
		fmt.Println(err.Error())
	}

	var update model.UpdateInput
	er := json.Unmarshal([]byte(value), &update)
	if er != nil {
		fmt.Println(err.Error())
	}
	e := reflect.ValueOf(&update).Elem()
	email := fmt.Sprint(e.Field(0).Interface())
	status := fmt.Sprint(e.Field(1).Interface())
	email = strings.ToLower(string(email))

	// connect to the db
	db, err := connectDB(c)
	if db == nil {
		message := model.Message{
			Message: "DB has something wrong",
		}
		c.JSON(500, message)
		panic(err.Error())
	}

	updateQuery, err := db.Query("UPDATE user SET status = ? WHERE email = ?", status, email)
	if err != nil {
		fmt.Println("Update error")
		if strings.Contains(err.Error(), "Access denied") {
			message := model.Message{
				Message: "DB access error, username or password is wrong",
			}
			c.JSON(500, message)
			panic(err.Error())
		}
		message := model.Message{
			Message: "Does not found such user",
		}
		c.JSON(500, message)
		panic(err.Error())
	} else {
		getUser(email, c, db)
	}
	defer updateQuery.Close()
	defer db.Close()
}

// User ID from email
// @Summary Get userID from email
// @Description User email as input and ID is returned
// @Tags user
// @Accept  json
// @Produce  json
// @Param userInfo body model.GetUserIDInput true "Get userID"
// @Success 200 {object} model.GetUserIDOutput
// @Failure 500 {object} model.Message
// @Failure 404 {object} model.Message
// @Router /user/getUserID [post]
func (ct *Controller) QueryGetUserID(c *gin.Context) {
	//getting data from request
	body := c.Request.Body
	value, err := ioutil.ReadAll(body)
	if err != nil {
		fmt.Println(err.Error())
	}

	var getUserIDInput model.GetUserIDInput
	//TODO: Try to figure out why
	// if err := c.ShouldBindJSON(&signup); err != nil {
	// 	c.JSON(500, gin.H{
	// 		"message": "Input is not in JSON format",
	// 	})
	// 	return
	// }
	er := json.Unmarshal([]byte(value), &getUserIDInput)
	if er != nil {
		fmt.Println(err.Error())
	}
	e := reflect.ValueOf(&getUserIDInput).Elem()
	email := fmt.Sprint(e.Field(0).Interface())

	// connect to the db
	db, err := connectDB(c)
	if err != nil {
		message := model.Message{
			Message: "DB has something wrong",
		}
		c.JSON(500, message)
		panic(err.Error())
	}

	defer db.Close()
	//select userID from db
	var (
		userID string
		status string
	)
	rows, err := db.Query("SELECT id, status from user WHERE email = ?", email)
	if err != nil {
		fmt.Println("Login error")
		if strings.Contains(err.Error(), "Access denied") {
			message := model.Message{
				Message: "DB access error, username or password is wrong",
			}
			c.JSON(500, message)
			panic(err.Error())
		}
		message := model.Message{
			Message: "Such username or password is incorrect",
		}
		c.JSON(404, message)
		panic(err.Error())
	} else {
		for rows.Next() {
			err := rows.Scan(&userID, &status)
			if err != nil {
				log.Fatal(err)
			}
		}
		if userID == "" {
			message := model.Message{
				Message: "No such user",
			}
			c.JSON(404, message)
		} else if status == "pending" {
			message := model.Message{
				Message: "Such user is in pending",
			}
			c.JSON(404, message)
		} else {
			getUserIDOutput := model.GetUserIDOutput{
				UserID: userID,
				Status: status,
			}
			c.JSON(200, getUserIDOutput)
		}

	}
	defer rows.Close()
}

//Reset Password, TODO: need to be improved later
func (ct *Controller) QueryResetPassword(c *gin.Context) {
	//getting data from request
	email := c.Query("email")
	password := c.Query("password")
	rePassword := c.Query("rePassword")

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
			if strings.Contains(err.Error(), "Access denied") {
				c.JSON(500, gin.H{
					"message": "DB access error, username or password is wrong",
				})
				panic(err.Error())
			}
			c.JSON(404, gin.H{
				"message": "Update is not vailed",
			})
			panic(err.Error())
		} else {
			c.JSON(200, gin.H{
				"message": "Password is updated",
			})

		}
		defer update.Close()
	}
}
