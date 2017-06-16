package main


//This is sample server from:
// https://golang.org/doc/articles/wiki/

import (
    "fmt"
    "net/http"
)

func handler(w http.ResponseWriter, r *http.Request) {
    fmt.Println("Serving ", string(r.Method), string(r.URL.Path))
    fmt.Fprintf(w, "Hi there, I love %s!\n", r.URL.Path[1:])
}

func main() {
    http.HandleFunc("/", handler)
    http.ListenAndServe(":8080", nil)
}
