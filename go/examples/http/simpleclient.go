package main


//This is sample server from:
// https://golang.org/doc/articles/wiki/

import (
    "bytes"
    "fmt"
    "io/ioutil"
    "net/http"
    yaml "gopkg.in/yaml.v2"

)

type VsmSpec struct {
	Kind       string `yaml:"kind"`
	APIVersion string `yaml:"apiVersion"`
	Metadata   struct {
		Name   string `yaml:"name"`
		Labels struct {
			Storage string `yaml:"volumeprovisioner.mapi.openebs.io/storage-size"`
		}
	} `yaml:"metadata"`
	//Spec struct {
	//	AccessModes []string `yaml:"accessModes"`
	//	Resources   struct {
	//		Requests struct {
	//			Storage string `yaml:"storage"`
	//		} `yaml:"requests"`
	//	} `yaml:"resources"`
	//} `yaml:"spec"`
}

func runGet() {
    resp, err := http.Get("http://localhost:8080/tests")
    if err != nil {
	// handle error
    }
    defer resp.Body.Close()
    body, err := ioutil.ReadAll(resp.Body)
    if err != nil {
	// handle error
    }
    fmt.Printf("%s", body)
}

func runPost() {
    var vs VsmSpec
    vs.Kind = "PersistentVolumeClaim"
    vs.APIVersion = "v1"
    vs.Metadata.Name = "demo-vol"
    vs.Metadata.Labels.Storage = "1G"

    //Marshal serializes the value provided into a YAML document
    yamlValue, _ := yaml.Marshal(vs)

    fmt.Printf("VSM Spec Created:\n%v\n", string(yamlValue))

    resp, err := http.Post("http://localhost:8080/tests", "application/yaml", bytes.NewBuffer(yamlValue))
    if err != nil {
	// handle error
    }
    defer resp.Body.Close()
    body, err := ioutil.ReadAll(resp.Body)
    if err != nil {
	// handle error
    }
    fmt.Printf("%s", body)
}

func main() {
    runGet()
    runPost()
}

