FUNCTION_NAME="test"
RUNTIME="nodejs8.10"
HANDLER_NAME="index.handler" # filename.handlerName
ROLE = ${ROLE_ARN}
ZIP_FILE="fileb://$(shell pwd)/handler.zip"

PACKAGES = hello world

zip-function:
	$(foreach source, $(PACKAGES), \
		$(call print-source, $(package)))
	# rm ./handler.zip
	# zip handler.zip handler.js

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


loop:
	$(foreach source, $(SOURCES), \
		$(call print-source, $(source)))

define zip-code
	zip -j handler.zip packages/test-package/main.js

endef