package main

import (
	"reflect"
	"testing"
)

func TestListMapKeys(t *testing.T) {
	println("TestListMapKeys")

	// Créez une carte de test
	// testMap := map[string]Cat{
	// 	"id1": {},
	// 	"id2": {},
	// 	"id3": {},
	// }

	// Appelez la fonction listMapKeys
	// keys := listMapKeys(testMap)

	// Vérifiez si les clés retournées sont correctes
	// expectedKeys := []string{"id1", "id2", "id3"}
	
	// if !reflect.DeepEqual(keys, expectedKeys) {
	// 	t.Errorf("Les clés retournées sont incorrectes. Attendu: %v, Obtenu: %v", expectedKeys, keys)
	// }
}

func TestListMapKeys_EmptyMap(t *testing.T) {
	println("TestListMapKeys_EmptyMap")

	// Create an empty test map
	testMap := make(map[string]Cat)

	// Call the listMapKeys function
	keys := listMapKeys(testMap)

	// Verify if the returned keys are correct
	expectedKeys := []string{}
	
	if !reflect.DeepEqual(keys, expectedKeys) {
		t.Errorf("The returned keys are incorrect. Expected: %v, Got: %v", expectedKeys, keys)
	}
}