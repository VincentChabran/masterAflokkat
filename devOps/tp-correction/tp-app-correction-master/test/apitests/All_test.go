package apitests

import "fmt"
import "net/http"
import "testing"

var initCatId string

func init() {
	// Preparation: delete all existing & create a cat
	ids := []string{}
	call("GET", "/cats", nil, nil, &ids)

	for _, id := range ids {
		call("DELETE", "/cats/" + id, nil, nil, nil)
	} 

	call("POST", "/cats", &CatModel{Name: "Toto"}, nil, &initCatId)
}

func TestGetCats(t *testing.T) {

	code := 0
	result := []string{}
	err := call("GET", "/cats", nil, &code, &result)
	if err != nil {
		t.Error("Request error", err)
	}

	fmt.Println("GET /cats ->", code, result)

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

func TestGetOneCat(t *testing.T) {

	code := 0
	result := CatModel{}
	err := call("GET", "/cats/" + initCatId, nil, &code, &result)
	if err != nil {
		t.Error("Request error", err)
	}

	fmt.Println("GET /cats/" + initCatId, code, result)
	if code != http.StatusOK {
		t.Error("We should get code 200, got", code)
	}
	if result.Name != "Toto" {
		t.Error("We should get Toto, got", result.Name)
	}
}

func TestCreateAndDelete(t *testing.T) {

	// Init
	resultBefore := []string{}
	err := call("GET", "/cats", nil, nil, &resultBefore)
	nbBefore := len(resultBefore)

	// Creation
	code := 0
	catId := ""
	err = call("POST", "/cats", &CatModel{Name: "Chat"}, &code, &catId)
	if err != nil {
		t.Error("Request error", err)
	}
	if code != http.StatusCreated {
		t.Error("The code should be", http.StatusCreated, "got", code)
	}

	// Check creation
	code = 0
	resultAfterCreate := []string{}
	err = call("GET", "/cats", nil, &code, &resultAfterCreate)
	if err != nil {
		t.Error("Request error", err)
	}

	nbAfterCreate := len(resultAfterCreate)

	if nbAfterCreate != nbBefore + 1 {
		t.Error("We should observe one more cat", nbBefore, nbAfterCreate)
	}


	// Deletion
	code = 0
	err = call("DELETE", "/cats/" + catId, nil, &code, nil)
	if err != nil {
		t.Error("Request error", err)
	}
	if code != http.StatusNoContent {
		t.Error("The code should be", http.StatusNoContent, "got", code)
	}

	// Check deletion
	code = 0
	resultAfterDelete := []string{}
	err = call("GET", "/cats", nil, &code, &resultAfterDelete)
	if err != nil {
		t.Error("Request error", err)
	}

	nbAfterDelete := len(resultAfterDelete)

	if nbAfterCreate != nbAfterDelete + 1 {
		t.Error("We should observe one less cat", nbAfterDelete, nbAfterCreate)
	}
}