#!make

# Include .gitignored env vars
include .env
export

RUNTIME = "nodejs8.10"
HANDLER_NAME = "handler.handler" # filename.handlerName
ROLE = ${ROLE_ARN}
ZIP_FILE = "fileb://$(shell pwd)/${ZIP_FILE_PATH}" # relative with no ./
FUNCTION_NAME = ${NAME}

PACKAGES=$(shell ls packages) # list all packages
WD = $(shell pwd)

# Dangerous - Remember to set $ROLE_ARN
create-all:
	make package-all
	$(foreach package, $(PACKAGES), \
		$(call create-function,$(package)))
	make clean-packages

package-all:
	make bundle-packages
	make zip-packages

bundle-packages:
	$(foreach package, $(PACKAGES), \
		$(call bundle-package,$(package)))

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

define bundle-package
	yarn
	yarn parcel build -t node \
		$(WD)/packages/$(1)/index.js \
		-o bundle.js \
		-d ./packages/test-package \
		--no-source-maps \
		--no-minify \
		--bundle-node-modules

endef

define create-function
	aws lambda create-function \
		--function-name=$(1) \
		--runtime=$(RUNTIME) \
		--handler=$(HANDLER_NAME) \
		--role=$(ROLE) \
		--zip-file="fileb://$(WD)/packages/$(1)/handler.zip"

endef