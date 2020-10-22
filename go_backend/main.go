package main

import (
	"fmt"

	"github.com/gin-gonic/gin"
	"github.com/zijianguan0204/hunger_at_home/controller"
)

func main() {
	fmt.Println("Hello World")

	r := gin.Default()
	c := controller.NewController()

	v1 := r.Group("/api/v1")
	{
		user := v1.Group("/user")
		{
			user.POST("signup", c.QuerySignUp)
			user.GET("login", c.QueryLogin)
			user.POST("updateUserStatus", c.QueryUpdateUserStatus)
			user.GET("resetPassword", c.QueryResetPassword)
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
		}
	}
	//TODO: URL design and catagorize them into different /
	// r.POST("api/signup", controller.QuerySignUp)
	// r.GET("api/login", controller.QueryLogin)
	// r.POST("api/updateUserStatus", controller.QueryUpdateUserStatus)
	// r.GET("api/reset", controller.QueryResetPassword)

	// r.POST("api/companySignup", controller.QueryCompanySignUp)
	// r.POST("api/companyList", controller.QueryGetCompanyList)
	// r.POST("api/addressCompanyAssociate", controller.QueryAddCompanyAddressAssociate)
	// r.POST("api/addressSignUp", controller.QueryAddressSignUp)
	// r.POST("api/addressList", controller.QueryGetAddressList)

	// r.POST("api/addItem", controller.QueryAddItem)
	// r.POST("api/updateItemTemperature", controller.QueryUpdateItemTemperature)
	// r.POST("api/updateOrderStatus", controller.QueryUpdateOrderStatus)
	// r.POST("api/addOrder", controller.QueryAddOrder)
	// r.POST("api/addOrderItemAssociate", controller.QueryAddItemOrderAssociate)
	// r.POST("api/addOrderAssociate", controller.QueryAddOrderAssociate)
	// r.POST("api/updateOrderAssociate", controller.QueryUpdateOrderAssociate)
	// r.POST("api/getOrderListByDonorID", controller.QueryGetOrderListByDonorID)

	r.Run()
}
