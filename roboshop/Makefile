# Add the following 'help' target to your Makefile
# And add help text after each target name starting with '\#\#'

help:         		    ## Show this help.
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

common:
	@sh Components/common.sh

cart: common
cart: 				     ## Install cart component
	@sh Components/cart.sh

catalogue: common
catalogue: 				 ## Install catalogue component
	@sh Components/catalogue.sh

frontend: common
frontend: 				 ## Install Frontend component
	@sh Components/frontend.sh

mongodb: common
mongodb: 				 ## Install mongodb component
	@sh Components/mongodb.sh

redis: common
redis: 				     ## Install redis component
	@sh Components/redis.sh


user: common
user: 				     ## Install user component
	@sh Components/user.sh

cart: common
cart: 				     ## Install cart component
	@sh Components/cart.sh

mysql: common
mysql: 				     ## Install mysql component
	@sh Components/mysql.sh

shipping: common
shipping: 				  ## Install shipping component
	@sh Components/shipping.sh

rabbitmq: common
rabbitmq: 				  ## Install rabbitmq component
	@sh Components/rabitmq.sh

payment: common
payment: 				  ## Install payment component
	@sh Components/payment.sh