// Example showing the usage of flag to implement a Book CLI 
//
// This example can be used to input information about 
// a Golang Book or Article.
package flag

import (
	"flag"
)


type Book struct {
	Name 		string
	ReadTime 	int
	Entry		bool
}

// CliBook will hold the data provided via the CLI
var CliBook *Book

func init() {
	const (
		nameDefault = "Introduction to Go Programming"
		nameDescr   = "Name of the Book or Article "

		readTimeDefault  = 60
		readTimeDescr   = "How much time (in minutes) do you require to read?"

		entryDefault = false
		entryDescr   = "Is this an entry level book?"

	)

	CliBook = &Book{}
	flag.BoolVar(&CliBook.Entry, "entry-level", entryDefault, entryDescr)

	flag.StringVar(&CliBook.Name, "book-name", nameDefault, nameDescr)
	flag.StringVar(&CliBook.Name, "book-title", nameDefault, nameDescr)

	flag.IntVar(&CliBook.ReadTime, "read-time", readTimeDefault, readTimeDescr)

}

