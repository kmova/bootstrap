ifeq (${MAKE_QUOTED}, )
  MAKE_QUOTED="quote"
  export MAKE_QUOTED
endif

ifeq (${MAKE_UNQUOTED}, )
  MAKE_UNQUOTED=unquote
  export MAKE_UNQUOTED
endif

ifeq (${MAKE_NQUOTED}, )
  MAKE_NQUOTED=$(MAKE_UNQUOTED:u%=%)
  #MAKE_NQUOTED=$(shell go env GOOS)
  export MAKE_NQUOTED
endif

hello:
	./quoted.sh

