package main

import (
	"context"
	"fmt"
	"log"
	"os"

	"github.com/google/go-github/github"
	"golang.org/x/oauth2"
)

var client *github.Client
var ctx = context.Background()

func main() {
	token := os.Getenv("GITHUB_AUTH_TOKEN")
	if token == "" {
		log.Fatal("Unauthorized: No token present. Set env GITHUB_AUTH_TOKEN with valid token")
	}

	ts := oauth2.StaticTokenSource(&oauth2.Token{AccessToken: token})
	tc := oauth2.NewClient(ctx, ts)
	client = github.NewClient(tc)

	openebsRepos := [...]string{ "openebs", "node-disk-manager","linux-utils",
					"maya", "external-storage",
					"gotgt", "jiva", "jiva-csi", "jiva-operator",
					"cstor", "libcstor", "cstor-csi", "velero-plugin", "istgt",
					"zfs-localpv",
					"openebs-docs", "website",
					"charts", "helm-operator",
					"MayaStor", "vhost-user", "spdk-sys",
					"elves", "soc", "community",
					"performance-benchmark",
					"chitrakala" }

	stars := 0
	watchers := 0
	forks := 0
	for _, reponame := range  openebsRepos {
		repo, _, err := client.Repositories.Get(ctx, "openebs", reponame)
		if err != nil {
			fmt.Println(err)
			continue
		}

		stars += repo.GetStargazersCount()
		watchers += repo.GetWatchersCount()
		forks += repo.GetForksCount()
	}
	fmt.Println("Stars: ", stars)
	fmt.Println("Watchers: ", watchers)
	fmt.Println("Forks:", forks)
}
