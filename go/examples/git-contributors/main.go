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

func listContributors(owner, repo string) {
	opt := &github.ListContributorsOptions{}
	opt.PerPage = 500
	contributors, _, err := client.Repositories.ListContributors(ctx, owner, repo, opt)

	if err != nil {
		fmt.Println(err)
		return
	}

	for _, contributor := range contributors {
		fmt.Println(*contributor.Login)
	}
}

func main() {
	token := os.Getenv("GITHUB_AUTH_TOKEN")
	if token == "" {
		log.Fatal("Unauthorized: No token present. Set env GITHUB_AUTH_TOKEN with valid token")
	}

	ts := oauth2.StaticTokenSource(&oauth2.Token{AccessToken: token})
	tc := oauth2.NewClient(ctx, ts)
	client = github.NewClient(tc)

	listContributors("openebs", "openebs")
	listContributors("openebs", "node-disk-manager")
	listContributors("openebs", "maya")
	listContributors("openebs", "external-storage")
	listContributors("openebs", "gotgt")
	listContributors("openebs", "jiva")
	listContributors("openebs", "jiva-csi")
	listContributors("openebs", "jiva-operator")
	listContributors("openebs", "cstor")
	listContributors("openebs", "libcstor")
	listContributors("openebs", "cstor-csi")
	listContributors("openebs", "velero-plugin")
	listContributors("openebs", "istgt")
	listContributors("openebs", "zfs-localpv")
	listContributors("openebs", "linux-utils")
	listContributors("openebs", "openebs-docs")
	listContributors("openebs", "website")
	listContributors("openebs", "charts")
	listContributors("openebs", "helm-operator")
	listContributors("openebs", "MayaStor")
	listContributors("openebs", "vhost-user")
	listContributors("openebs", "spdk-sys")
	listContributors("openebs", "elves")
	listContributors("openebs", "performance-benchmark")
	listContributors("openebs", "soc")
	listContributors("openebs", "community")
	listContributors("openebs", "chitrakala")
}
