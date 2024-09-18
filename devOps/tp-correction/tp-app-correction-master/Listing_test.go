package main

import "testing"

func TestKeysListingEmpty(t *testing.T) {

	input := map[string]Cat{}

	list := listMapKeys(input)

	if len(list) != 0 {
		t.Error("The list should be empy")
	}
}

func TestKeysListingFull(t *testing.T) {

	input := map[string]Cat{
		"id1": Cat{Name: "Toto"},
		"id2": Cat{Name: "Chat"},
	}

	list := listMapKeys(input)

	if len(list) != 2 {
		t.Error("The list should have 2 entries")
	}
}
