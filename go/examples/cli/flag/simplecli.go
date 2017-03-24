package main

import (
	"flag"
	"fmt"
)

// Example showing the usage of flag to implement a CLI 
//
// This example can be used to provide information about 
// a Golang Book or Article.

type Book struct {
	Name 		string
	ReadTime 	int
	Entry		bool
}

var book *Book

func init() {
	const (
		nameDefault = "Introduction to Go Programming"
		nameDescr   = "Name of the Book or Article "

		readTimeDefault  = 60
		readTimeDescr   = "How much time (in minutes) do you require to read?"

		entryDefault = false
		entryDescr   = "Is this an entry level book?"

	)

	book = &Book{}
	flag.BoolVar(&book.Entry, "entry-level", entryDefault, entryDescr)

	flag.StringVar(&book.Name, "book-name", nameDefault, nameDescr)
	flag.StringVar(&book.Name, "book-title", nameDefault, nameDescr)

	flag.IntVar(&book.ReadTime, "read-time", readTimeDefault, readTimeDescr)

}

func main() {
	flag.Parse()

	if ( 1 > flag.NFlag() ) {
		fmt.Println("Valid arguments are:")
		flag.PrintDefaults()
	} else {
		fmt.Println("Name:", book.Name)
		fmt.Println("Reading Time in minutes:", book.ReadTime)
		fmt.Println("Entry Level?:", book.Entry)
	}

}
