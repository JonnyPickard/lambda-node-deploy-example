FUNCTION_NAME="test"
RUNTIME="nodejs8.10"
HANDLER_NAME="handler.handler" # filename.handlerName
ROLE = ${ROLE_ARN}
ZIP_FILE="fileb://$(shell pwd)/handler.zip"

PACKAGES=$(shell ls packages) # list all packages
WD = $(shell pwd)

zip-packages:
	$(foreach package, $(PACKAGES), \
		$(call zip-package,$(package)))

clean-packages:
	$(foreach package, $(PACKAGES), \
		$(call clean-package,$(package)))

create-function:
	aws lambda create-function \
    --function-name=$(FUNCTION_NAME) \
    --runtime=$(RUNTIME) \
    --handler=$(HANDLER_NAME) \
    --role=$(ROLE) \
    --zip-file=$(ZIP_FILE)

update-function:
	aws lambda update-function-code \
    --function-name=$(FUNCTION_NAME) \
    --zip-file=$(ZIP_FILE)

delete-function:
	aws lambda delete-function \
    --function-name=$(FUNCTION_NAME)


define zip-package
	zip -j -r $(WD)/packages/$(1)/handler.zip \
		$(WD)/packages/$(1)/handler.js \
		$(WD)/packages/$(1)/bundle.js

endef

define clean-package
	rm $(WD)/packages/$(1)/bundle.js
	rm $(WD)/packages/$(1)/handler.zip

endef