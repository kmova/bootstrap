
# set PATH so it includes user's private bin directories
PATH="$HOME/bin:$HOME/.local/bin:$PATH"
PATH="$HOME/go/src/github.com/kmova/bootstrap/git:$PATH"
PATH="$HOME/go/src/github.com/kmova/bootstrap/gke-openebs/hack:$PATH"

export GOPATH="$HOME/go"
export GOROOT="/usr/local/go/"
export PATH="$GOROOT:$GOPATH/bin:$PATH"
