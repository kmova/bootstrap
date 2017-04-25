package main

import (
	"os"
	"testing"
)

// Helps to run the main in a separate go-routine.
// TBD - Modify the example to show the need for the main

func TestMain(m *testing.M) {
	os.Exit(m.Run())
}

func TestHello(t *testing.T) {
	expected := "Hello world!"
	actual := hello()
	if actual != expected {
		t.Error("Test failed")
	}
}

func BenchmarkHello(b *testing.B) {
	for i := 0; i < b.N; i++ {
		hello()
	}
}
