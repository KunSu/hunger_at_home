package main

import (
	"fmt"
	"io/ioutil"

	"github.com/gin-gonic/gin"
)

func homePage(c *gin.Context) {
	c.JSON(200, gin.H{
		"message": "Hello World",
	})
}

func postHomePage(c *gin.Context) {
	body := c.Request.Body
	value, err := ioutil.ReadAll(body)
	if err != nil {
		fmt.Println(err.Error())
	}
	c.JSON(200, gin.H{
		"message": string(value),
	})
}

func queryStrings(c *gin.Context) {
	name := c.Query("name")
	age := c.Query("age")

	c.JSON(200, gin.H{
		"name": name,
		"age":  age,
	})
}

func pathParameters(c *gin.Context) {
	name := c.Param("name")
	age := c.Param("age")

	c.JSON(200, gin.H{
		"name": name,
		"age":  age,
	})
}
func main() {
	fmt.Println("Hello World")

	r := gin.Default()
	r.GET("/", homePage)
	r.POST("/", postHomePage)
	r.GET("/query", queryStrings)             // query?name=zhadanren&age=233
	r.GET("/path/:name/:age", pathParameters) //query/zhadanren/233
	r.Run()
}
