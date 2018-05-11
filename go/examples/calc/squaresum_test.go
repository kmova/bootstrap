package calc

import (
	"testing"
)

func TestComplexMath(t *testing.T) {
	tests := []struct {
		as, bs string; result int64
	}{
		{as: "2", bs: "1", result: 5},
		{as: "2", bs: "2", result: 6},
	}
	for _, test := range tests {
		res := ComplexMath(test.as, test.bs)
		if res != test.result {
			t.Errorf("%d.%d => Expected %d, got %d", test.as, test.bs, test.result, res)
		}
	}
}
