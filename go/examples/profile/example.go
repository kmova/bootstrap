package main

import (
	"flag"
	//"os"
	//"time"

	//"github.com/rakyll/autopprof"
	"github.com/pkg/profile"

	"net/http"
	_ "net/http/pprof"
)

func ExampleStart() {
	// start a simple CPU profile and register
	// a defer to Stop (flush) the profiling data.
	defer profile.Start().Stop()
}

func ExampleCPUProfile() {
	// CPU profiling is the default profiling mode, but you can specify it
	// explicitly for completeness.
	defer profile.Start(profile.CPUProfile).Stop()
}

func ExampleMemProfile() {
	// use memory profiling, rather than the default cpu profiling.
	defer profile.Start(profile.MemProfile).Stop()
}

func ExampleMemProfileRate() {
	// use memory profiling with custom rate.
	defer profile.Start(profile.MemProfileRate(2048)).Stop()
}

func ExampleProfilePath() {
	// set the location that the profile will be written to
	defer profile.Start(profile.ProfilePath("/tmp")).Stop()
	//defer profile.Start(profile.ProfilePath(os.Getenv("HOME"))).Stop()
	println("ExampleProfilePath fired!")
	nums := []int{2, 3, 4}
	sum := 0
	for _, num := range nums {
		sum += num
	}
}

func ExampleNoShutdownHook() {
	// disable the automatic shutdown hook.
	defer profile.Start(profile.NoShutdownHook).Stop()
}

func ExampleStart_withFlags() {
	// use the flags package to selectively enable profiling.
	mode := flag.String("profile.mode", "", "enable profiling mode, one of [cpu, mem, mutex, block]")
	flag.Parse()
	switch *mode {
	case "cpu":
		defer profile.Start(profile.CPUProfile).Stop()
	case "mem":
		defer profile.Start(profile.MemProfile).Stop()
	case "mutex":
		defer profile.Start(profile.MutexProfile).Stop()
	case "block":
		defer profile.Start(profile.BlockProfile).Stop()
	default:
		// do nothing
	}
}

func main() {
	//ExampleProfilePath()
	//autopprof.Capture(autopprof.CPUProfile{
	//    Duration: 15 * time.Second,
	//})
	http.HandleFunc("/", serveHTTP)
	http.ListenAndServe(":9664", nil)
	println("Server Started!")
}

func serveHTTP(w http.ResponseWriter, r *http.Request) {
    w.Write([]byte("Hello, world"))
}

