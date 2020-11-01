package main

import (
	"fmt"

	"github.com/gin-gonic/gin"
	swaggerFiles "github.com/swaggo/files"
	ginSwagger "github.com/swaggo/gin-swagger"

	"github.com/zijianguan0204/hunger_at_home/controller"
	_ "github.com/zijianguan0204/hunger_at_home/docs"
)

// @title Hunger At Home API
// @version 1.0
// @description This is a hunger at home application backend server.
// @termsOfService http://swagger.io/terms/

// @contact.name API Support
// @contact.url http://www.swagger.io/support
// @contact.email support@swagger.io

// @license.name Apache 2.0
// @license.url http://www.apache.org/licenses/LICENSE-2.0.html

// @host localhost:8080/api
// @BasePath /v1

func main() {

	// r := gin.New()
	fmt.Println("Hello World")

	r := gin.Default()
	c := controller.NewController()

	v1 := r.Group("/api/v1")
	{
		user := v1.Group("/user")
		{
			user.POST("signup", c.QuerySignUp)
			user.GET("login/:email/:password", c.QueryLogin)
			user.POST("updateUserStatus", c.QueryUpdateUserStatus)
			user.POST("getUserID", c.QueryGetUserID)
			// user.GET("resetPassword", c.QueryResetPassword)
		}

		company := v1.Group("/company")
		{
			company.POST("companySignup", c.QueryCompanySignUp)
			company.POST("companyList", c.QueryGetCompanyList)
			company.POST("addressCompanyAssociate", c.QueryAddCompanyAddressAssociate)
			company.POST("addressSignUp", c.QueryAddressSignUp)
			company.POST("addressList", c.QueryGetAddressList)
		}

		order := v1.Group("/order")
		{
			order.POST("addItem", c.QueryAddItem)
			order.POST("updateItemTemperature", c.QueryUpdateItemTemperature)
			order.POST("updateOrderStatus", c.QueryUpdateOrderStatus)
			order.POST("addOrder", c.QueryAddOrder)
			order.POST("addOrderItemAssociate", c.QueryAddItemOrderAssociate)
			order.POST("addOrderAssociate", c.QueryAddOrderAssociate)
			order.POST("updateOrderAssociate", c.QueryUpdateOrderAssociate)
			order.POST("getOrderListByDonorID", c.QueryGetOrderListByDonorID)
			order.POST("getOrderListByEmployeeID", c.QueryGetOrderListByEmployeeID)
			order.POST("getOrderListByRecipientID", c.QueryGetOrderListByRecipientID)
		}
	}

	url := ginSwagger.URL("http://localhost:8080/swagger/doc.json") // The url pointing to API definition
	r.GET("/swagger/*any", ginSwagger.WrapHandler(swaggerFiles.Handler, url))

	r.Run()
}
