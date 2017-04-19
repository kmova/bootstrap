package greetings

import (
	"testing"
)

func TestSelfIntro(t *testing.T){
	expected := "Hello, I am from your greetings go package!"
	actual := SelfIntro()
	if actual != expected {
		t.Error("Test failed")
	}
}
