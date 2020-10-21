package controller

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"reflect"
	"strings"

	"github.com/gin-gonic/gin"
)

//Company sighup function
func queryCompanySignUp(c *gin.Context) {
	//getting data from request
	body := c.Request.Body
	value, err := ioutil.ReadAll(body)
	if err != nil {
		fmt.Println(err.Error())
	}
	type Signup struct {
		CompanyName string `json:"companyName"`
		FedID       string `json:"fedID"`
		EinID       string `json:"einID"`
	}

	var signup Signup
	er := json.Unmarshal([]byte(value), &signup)
	if er != nil {
		fmt.Println(err.Error())
	}
	e := reflect.ValueOf(&signup).Elem()
	companyName := fmt.Sprint(e.Field(0).Interface())
	fedID := fmt.Sprint(e.Field(1).Interface())
	einID := fmt.Sprint(e.Field(2).Interface())

	// connect to the db
	db, err := connectDB(c)
	if err != nil {
		fmt.Println("DB error")
		c.JSON(500, gin.H{
			"message": "DB connection problem",
		})
		panic(err.Error())
	}

	//insert to db
	insert, err := db.Query("INSERT INTO company VALUES(DEFAULT,?,?,?,DEFAULT)", companyName, fedID, einID)

	if err != nil {
		fmt.Println("Sign up error")
		if strings.Contains(err.Error(), "Access denied") {
			c.JSON(500, gin.H{
				"message": "DB access error, username or password is wrong",
			})
			panic(err.Error())
		}
		c.JSON(404, gin.H{
			"message": "Company name, FED or EIN is/are already taken",
		})
		panic(err.Error())
	} else {
		getCompany(companyName, c, db)
	}
	defer db.Close()
	defer insert.Close()
}

//Company Address signup function
func queryAddressSignUp(c *gin.Context) {
	//getting data from request
	body := c.Request.Body
	value, err := ioutil.ReadAll(body)
	if err != nil {
		fmt.Println(err.Error())
	}
	type Signup struct {
		Address string `json:"address"`
		City    string `json:"city"`
		State   string `json:"state"`
		ZipCode string `json:"zipCode"`
	}

	var signup Signup
	er := json.Unmarshal([]byte(value), &signup)
	if er != nil {
		fmt.Println(err.Error())
	}
	e := reflect.ValueOf(&signup).Elem()
	address := fmt.Sprint(e.Field(0).Interface())
	city := fmt.Sprint(e.Field(1).Interface())
	state := fmt.Sprint(e.Field(2).Interface())
	zipCode := fmt.Sprint(e.Field(3).Interface())

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
	//insert to db
	insert, err := db.Query("INSERT INTO address VALUES(DEFAULT,?,?,?,?,DEFAULT)", address, city, state, zipCode)
	if err != nil {
		fmt.Println("Sign up error")
		if strings.Contains(err.Error(), "Access denied") {
			c.JSON(500, gin.H{
				"message": "DB access error, username or password is wrong",
			})
			panic(err.Error())
		}
		c.JSON(404, gin.H{
			"message": "This address is already taken",
		})
		panic(err.Error())
	} else {
		c.JSON(201, gin.H{
			"message": "This address has been assigned or created",
		})
	}
	defer insert.Close()
}

//Getting the address list of a company based on companyID
func queryGetAddressList(c *gin.Context) {
	body := c.Request.Body
	value, err := ioutil.ReadAll(body)
	if err != nil {
		fmt.Println(err.Error())
	}
	type Input struct {
		CompanyID string `json:"companyID"`
	}

	var input Input
	er := json.Unmarshal([]byte(value), &input)
	if er != nil {
		fmt.Println(err.Error())
	}
	e := reflect.ValueOf(&input).Elem()
	companyID := fmt.Sprint(e.Field(0).Interface())
	fmt.Println(companyID)
	//connect to DB
	db, err := connectDB(c)
	if err != nil {
		fmt.Println("DB error")
		c.JSON(500, gin.H{
			"message": "DB connection problem",
		})
		panic(err.Error())
	}
	defer db.Close()
	//get company names
	var (
		address string
		city    string
		state   string
		zipCode string
	)
	addressList := []string{}
	var addressString string

	rows, err := db.Query("SELECT address.address, address.city, address.state, address.zipCode FROM address INNER JOIN companyAddressAssociate ON address.id = companyAddressAssociate.addressID WHERE companyAddressAssociate.companyID = ?", companyID)
	if err != nil {
		if strings.Contains(err.Error(), "Access denied") {
			c.JSON(500, gin.H{
				"message": "DB access error, username or password is wrong",
			})
			panic(err.Error())
		}
		c.JSON(500, gin.H{
			"message": "Query statements has something wrong",
		})
		panic(err.Error())
	} else {
		for rows.Next() {
			err := rows.Scan(&address, &city, &state, &zipCode)
			if err != nil {
				log.Fatal(err)
			}
			addressString = address + ", " + city + ", " + state + ", " + zipCode
			addressList = append(addressList, addressString)
		}
	}
	listInJSON, err := json.Marshal(addressList)
	if err != nil {
		log.Fatal("Cannot encode to JSON ", err)
	}

	c.String(200, string(listInJSON))
	defer rows.Close()

}

//TODO
func queryGetCompanyList(c *gin.Context) {
	//connect to DB
	db, err := connectDB(c)
	if err != nil {
		fmt.Println("DB error")
		c.JSON(500, gin.H{
			"message": "DB connection problem",
		})
		panic(err.Error())
	}
	defer db.Close()
	//get company names
	var companyName string
	companyList := []string{}

	rows, err := db.Query("SELECT companyName from company")
	if err != nil {
		if strings.Contains(err.Error(), "Access denied") {
			c.JSON(500, gin.H{
				"message": "DB access error, username or password is wrong",
			})
			panic(err.Error())
		}
		c.JSON(500, gin.H{
			"message": "Query statements has something wrong",
		})
		panic(err.Error())
	} else {
		for rows.Next() {
			err := rows.Scan(&companyName)
			if err != nil {
				log.Fatal(err)
			}
			companyList = append(companyList, companyName)
		}
	}
	listInJSON, err := json.Marshal(companyList)
	if err != nil {
		log.Fatal("Cannot encode to JSON ", err)
	}

	c.String(200, string(listInJSON))
	defer rows.Close()

}

// func queryGetCompanyList(c *gin.Context) {
// 	//connect to DB
// 	db, err := connectDB(c)
// 	if err != nil {
// 		fmt.Println("DB error")
// 		c.JSON(500, gin.H{
// 			"message": "DB connection problem",
// 		})
// 		panic(err.Error())
// 	}
// 	defer db.Close()
// 	//get company names
// 	var companyName string
// 	companyList := []string{}

// 	rows, err := db.Query("SELECT companyName from company")
// 	if err != nil {
// 		if strings.Contains(err.Error(), "Access denied") {
// 			c.JSON(500, gin.H{
// 				"message": "DB access error, username or password is wrong",
// 			})
// 			panic(err.Error())
// 		}
// 		c.JSON(500, gin.H{
// 			"message": "Query statements has something wrong",
// 		})
// 		panic(err.Error())
// 	} else {
// 		for rows.Next() {
// 			err := rows.Scan(&companyName)
// 			if err != nil {
// 				log.Fatal(err)
// 			}
// 			companyList = append(companyList, companyName)
// 		}
// 	}
// 	listInJSON, err := json.Marshal(companyList)
// 	if err != nil {
// 		log.Fatal("Cannot encode to JSON ", err)
// 	}

// 	c.String(200, string(listInJSON))
// 	defer rows.Close()

// }

//add record into companyAddressAssociate table
func queryAddCompanyAddressAssociate(c *gin.Context) {
	//getting data from request
	body := c.Request.Body
	value, err := ioutil.ReadAll(body)
	if err != nil {
		fmt.Println(err.Error())
	}
	type CompanyAddress struct {
		// ID
		AddressID string `json:"AddressID"`
		CompanyID string `json:"CompanyID"`
		// Timestamp string `json:"timestamp"`
	}

	var companyAddress CompanyAddress
	er := json.Unmarshal([]byte(value), &companyAddress)
	if er != nil {
		fmt.Println(err.Error())
	}
	e := reflect.ValueOf(&companyAddress).Elem()
	addressID := fmt.Sprint(e.Field(0).Interface())
	companyID := fmt.Sprint(e.Field(1).Interface())

	fmt.Println(addressID)
	fmt.Println(companyID)

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
	//insert to db
	insert, err := db.Query("INSERT INTO companyAddressAssociate VALUES(?,?,DEFAULT)", addressID, companyID)
	if err != nil {
		fmt.Println("This record can not be submitted")
		if strings.Contains(err.Error(), "Access denied") {
			c.JSON(500, gin.H{
				"message": "DB access error, username or password is wrong",
			})
			panic(err.Error())
		}
		c.JSON(500, gin.H{
			"message": "This record can not be submitted",
		})
		panic(err.Error())
	} else {
		c.JSON(201, gin.H{
			"message": "This record has been assigned or created",
		})
	}
	defer insert.Close()
}
