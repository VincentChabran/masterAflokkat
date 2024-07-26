package main

import (
	"net/http"
)



func getVersion(req *http.Request) (int, any) {
	Logger.Info("GET /version")

	return http.StatusOK, version
}