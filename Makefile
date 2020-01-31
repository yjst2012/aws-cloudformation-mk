
#ifeq ($(ENV),$(filter $(ENV),prod pre-prod test))
#      include $(ENV).mk
#else
#   @echo wrong ENV, exiting
#   exit 1
#endif

# use dev env by default
ENV ?= dev

include $(ENV).mk

clean:
	@ rm -rf ./dist

configure:
	@ aws --profile $(AWS_PROFILE) s3api create-bucket \
		--bucket $(AWS_BUCKET_NAME) \
		--region $(AWS_REGION) \
		--create-bucket-configuration LocationConstraint=$(AWS_REGION)

lambda:
	@ mkdir -p dist
	@ -rm -f ./dist/*.zip $(FILE_PACKAGE)
	@ -for file in $$(ls ./dist/); \
	do \
		[ -f ./dist/$$file ] && zip ./dist/$$file.zip ./dist/$$file; \
		aws --profile $(AWS_PROFILE) --region $(AWS_REGION) lambda update-function-code --function-name $(PROJECT_NAME)-$$file-$(ENV) --zip-file fileb://dist/$$file.zip 2>/dev/null; \
	done
	#@ aws --profile $(AWS_PROFILE) --region $(AWS_REGION) s3 cp ./dist/*.zip s3://$(AWS_BUCKET_NAME)

package:
	@ aws --profile $(AWS_PROFILE) cloudformation package \
		--template-file $(FILE_TEMPLATE) \
		--s3-bucket $(AWS_BUCKET_NAME) \
		--region $(AWS_REGION) \
		--output-template-file $(FILE_PACKAGE)

deploy:
	@ aws --profile $(AWS_PROFILE) cloudformation deploy \
		--template-file $(FILE_PACKAGE) \
		--region $(AWS_REGION) \
		--capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM \
		--stack-name $(AWS_STACK_NAME) \
		--force-upload \
		--parameter-overrides \
			ParamProjectID=$(PROJECT_ID) \
			ParamProjectScope=$(PROJECT_SCOPE) \
			ParamProjectName=$(PROJECT_NAME) \
			ParamENV=$(ENV)

update:
	@ aws --profile $(AWS_PROFILE) cloudformation update-stack \
		--template-body file://$(FILE_TEMPLATE) \
		--capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND \
		--region $(AWS_REGION) \
		--stack-name $(AWS_STACK_NAME) \

destroy:
	@ aws --profile $(AWS_PROFILE) cloudformation delete-stack \
		--region $(AWS_REGION) \
		--stack-name $(AWS_STACK_NAME) \

describe:
	@ aws --profile $(AWS_PROFILE) cloudformation describe-stacks \
		--region $(AWS_REGION) \
		--stack-name $(AWS_STACK_NAME)

outputs:
	@ make describe \
		| jq -r '.Stacks[0].Outputs'

build-%:
	@ GOOS=linux go build -ldflags="-s -w" -o ./dist/$* ./src/$*

build: clean
build: build-check

all: build lambda package deploy

.PHONY: all build configure lambda package deploy update describe outputs