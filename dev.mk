AWS_PROFILE ?= dev
AWS_REGION ?= ap-southeast-2

PROJECT_SCOPE =
PROJECT_NAME =

AWS_STACK_NAME ?= cf-lambda-step-$(ENV)

PROJECT_ID ?= $(PROJECT_SCOPE)-$(PROJECT_NAME)-$(ENV)

AWS_BUCKET_NAME ?= $(PROJECT_SCOPE)-$(PROJECT_NAME)-bucket-$(ENV)

FILE_TEMPLATE = cloudformation.yaml
FILE_PACKAGE = ./dist/stack-$(ENV).yaml
