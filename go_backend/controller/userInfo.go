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
// @Summary Add a new pet to the store
// @Description get string by ID
// @Tags user
// @Accept  json
// @Produce  json
// @Param userInfo body model.SignupInput true "Add a user"
// @Success 200 {object} model.SignupOutput
// @Failure 500 {string} string	"Server Issue"
// @Failure 404 {string} string	"Can not find user"
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
		c.JSON(404, gin.H{
			"message": "The email address is not valid",
		})
		return
	}
	email = strings.ToLower(string(email))

	//check if valid phone
	fmt.Print(len(phoneNumber))
	if !isPhoneValid(phoneNumber) {
		c.JSON(404, gin.H{
			"message": "The phone number is not valid",
		})
		return
	}

	//check if secure question and answer are both only containing alphabit
	if !IsLetter(secureQuestion) || !IsLetter(secureAnswer) {
		c.JSON(404, gin.H{
			"message": "The secure questions/answers are invalid, they should only contain alphabit",
		})
		return
	}
	// connect to the db
	db, err := connectDB(c)
	if db == nil {
		fmt.Println("DB has something wrong")
		c.JSON(500, gin.H{
			"message": "DB has something wrong",
		})
		panic(err.Error())
	}

	//insert to db
	insert, err := db.Query("INSERT INTO user VALUES(DEFAULT,?,?,?,?,?,?,?,?,?,?,DEFAULT)", email, password, firstName, lastName, phoneNumber, userIdentity, companyID, secureQuestion, secureAnswer, status)
	if err != nil {
		fmt.Println("Sign up error")
		if strings.Contains(err.Error(), "Access denied") {
			c.JSON(500, gin.H{
				"message": "DB access error, username or password is wrong",
			})
			panic(err.Error())
		}
		c.JSON(500, gin.H{
			"message": "This email address is already taken",
		})
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
// @Failure 404 {object} string	"Can not find user"
// @Failure 500 {object} string	"Server Issue"
// @Router /user/login/{email}/{password} [get]
func (ct *Controller) QueryLogin(c *gin.Context) {
	//getting data from request
	email := c.Param("email")
	password := c.Param("password")
	email = strings.ToLower(string(email))

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
	//select userID from db
	var (
		userID string
		status string
	)
	rows, err := db.Query("SELECT id, status from user WHERE email = ? AND password = ?", email, password)
	if err != nil {
		fmt.Println("Login error")
		if strings.Contains(err.Error(), "Access denied") {
			c.JSON(500, gin.H{
				"message": "DB access error, username or password is wrong",
			})
			panic(err.Error())
		}
		c.JSON(404, gin.H{
			"message": "Such username or password is incorrect",
		})
		panic(err.Error())
	} else {
		for rows.Next() {
			err := rows.Scan(&userID, &status)
			if err != nil {
				log.Fatal(err)
			}
		}
		if userID == "0" {
			c.JSON(404, gin.H{
				"message": "Such username or password is incorrect",
			})
		} else if status == "pending" {
			c.JSON(404, gin.H{
				"message": "Such user has not been approved by admin",
			})
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

//Set user status from pendign to approved
func (ct *Controller) QueryUpdateUserStatus(c *gin.Context) {
	body := c.Request.Body
	value, err := ioutil.ReadAll(body)
	if err != nil {
		fmt.Println(err.Error())
	}
	type Update struct {
		Email  string `json:"email"`
		Status string `json:"status"`
	}

	var update Update
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
		fmt.Println("DB has something wrong")
		c.JSON(500, gin.H{
			"message": "DB has something wrong",
		})
		panic(err.Error())
	}

	updateQuery, err := db.Query("UPDATE user SET status = ? WHERE email = ?", status, email)
	if err != nil {
		fmt.Println("Update error")
		if strings.Contains(err.Error(), "Access denied") {
			c.JSON(500, gin.H{
				"message": "DB access error, username or password is wrong",
			})
			panic(err.Error())
		}
		c.JSON(404, gin.H{
			"message": "Does not found such user",
		})
		panic(err.Error())
	} else {
		getUser(email, c, db)
	}
	defer updateQuery.Close()
	defer db.Close()
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
