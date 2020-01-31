package main

import (
	"context"
	"iqhive/vftv-migration-automation/src/common"
	"log"

	"github.com/aws/aws-lambda-go/lambda"
)

/*
type Data struct {
	Err                string `json:"Err"`
}
*/

func handleRequest(ctx context.Context, data common.Data) (common.Data, error) {

	log.Println("lamdba called with payload: ", data)
	// process the request here
	// xxx()

	// modify return value
	data.Err += "test!"
	return data, nil
}

func main() {
	lambda.Start(handleRequest)
}
