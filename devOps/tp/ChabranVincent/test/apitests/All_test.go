package apitests

import (
	"fmt"
	"net/http"
	"testing"
)

var initCatId string

func init() {
	// Preparation: delete all existing & create a cat
	ids := []string{}
	call("GET", "/cats", nil, nil, &ids)

	for _, id := range ids {
		call("DELETE", "/cats/" + id, nil, nil, nil)
	} 

	// Create a single cat into the DB
	call("POST", "/cats", &CatModel{Name: "Toto"}, nil, &initCatId)
}

func TestGetCats(t *testing.T) {
	fmt.Println("$$$$$$$$$$$$$$$ GET ALL /cats $$$$$$$$$$$$$$$$$")
 
	code := 0
	result := []string{}
	err := call("GET", "/cats", nil, &code, &result)
	if err != nil {
		t.Error("Request error", err)
	}

	fmt.Println("GET ALL /cats ->", code, result)

	if code != http.StatusOK {
		t.Error("We should get code 200, got", code)
	}

	if len(result) != 1 {
		t.Error("We should get one item, got", len(result))
		return
	}

	if result[0] != initCatId {
		t.Error("Listing the IDs, got", result[0])
	}
}

func TestCreateCat(t *testing.T) {
	fmt.Println("$$$$$$$$$$$$$$$ POST /cats $$$$$$$$$$$$$$$$$")

	// Prepare the request body
	requestBody := CatModel{Name: "Tata"}

	// Send the POST request
	code := 0
	response := ""
	err := call("POST", "/cats", &requestBody, &code, &response)

	if err != nil {
		t.Error("Request error:", err)
	}

	// Check the response code
	if code != http.StatusCreated {
		t.Error("We should get code 200, got", code)
	}
}

func TestGetCat(t *testing.T) {
	fmt.Println("$$$$$$$$$$$$$$$ GET ONE /cats $$$$$$$$$$$$$$$$$")

	code := 0
	result := CatModel{}
	err := call("GET", "/cats/"+initCatId, nil, &code, &result)
	if err != nil {
		t.Error("Request error", err)
	}

	fmt.Println("GET /cats/"+initCatId+" ->", code, result)

	if code != http.StatusOK {
		t.Error("We should get code 200, got", code)
	}

	if result.ID != initCatId {
		t.Error("The retrieved cat ID is incorrect, got", result.ID)
	}
}


func TestDeleteCat(t *testing.T) {
	fmt.Println("$$$$$$$$$$$$$$$ DELETE /cats $$$$$$$$$$$$$$$$$")
	
	// Send the DELETE request
	code := 0
	err := call("DELETE", "/cats/"+initCatId, nil, &code, nil)
	if err != nil {
		t.Error("Request error:", err)
	}

	fmt.Println("DELETE /cats/"+initCatId+" ->", code)

	// Check the response code
	if code != http.StatusNoContent {
		t.Error("We should get code 200, got", code)
	}

	// Verify that the cat is deleted
	code = 0
	result := CatModel{}
	err = call("GET", "/cats/"+initCatId, nil, &code, &result)
	if err == nil {
		t.Error("Request error CAT found", err)
	}

	fmt.Println("GET dans DELETE TEST /cats/"+initCatId+" ->", code, result)

	if code != http.StatusNotFound {
		t.Error("We should get code 404, got", code)
	}
}
