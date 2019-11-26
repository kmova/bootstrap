#!/bin/bash
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This script is inspired by the work published by https://github.com/austincunningham
# at https://dev.to/austincunningham/enforcing-git-commit-message-style-4gah
# 
# This script is meant to be included in the CI to verify that 
# the commits made into master follow the following commit format:
# https://github.com/openebs/openebs/blob/master/contribute/git-commit-message.md
# 
# <type>(<subject>): <commit meta text> [TICKET]
#
# <type> can be one of:
#   feat: A new feature
#   fix: A bug fix
#   breaking: A breaking bug fix
#   docs: Documentation only changes
#   style: Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
#   refactor: A code change that neither fixes a bug nor adds a feature
#   perf: A code change that improves performance
#   test: Adding missing tests
#   chore: Changes to the build process or auxiliary tools and libraries such as documentation generation
#


commit_message_check (){
      # Get the current branch and apply it to a variable
      currentbranch=`git branch | grep \* | cut -d ' ' -f2`

      # Gets the commits for the current branch and outputs to file
      git log $currentbranch --pretty=format:"%H" --not master > shafile.txt

      # loops through the file an gets the message
      for i in `cat ./shafile.txt`;
      do 
      # gets the git commit message based on the sha
      gitmessage=`git log --format=%B -n 1 "$i"`

      # Checks gitmessage for string feat, fix, docs and breaking, if the messagecheck var is empty if fails
      messagecheck=$(echo $gitmessage | grep -w "feat\|fix\|docs\|breaking\|style\|refactor\|perf\|test\|chore")
      if [ -z "$messagecheck" ]
      then 
            echo "Your commit message must begin with one of the following"
            echo "  feat(feature-name)"
            echo "  fix(fix-name)"
            echo "  docs(docs-change)"
            echo " "
      fi

      messagecheck=$(echo $gitmessage | grep ": ")
      if  [ -z "$messagecheck" ]
      then 
            echo "Your commit message has a formatting error please take note of special characters '():' position and use in the example below"
            echo "   type(module): some commit descriptive txt (issue number)"
            echo "Where 'type' is fix, feat, docs, breaking, style, refactor, perf, test or chore "
            echo " issue number is optional"
            echo " "
      fi

      # check to see if the messagecheck var is empty
      if [ -z "$messagecheck" ]
      then  
            echo "The commit message with sha: '$i' failed "
            echo "Please review the following :"
            echo " "
            echo $gitmessage
            echo " "
            rm shafile.txt >/dev/null 2>&1
            set -o errexit
      else
            #echo "$messagecheck"
            echo "'$i' commit message format check passed"
      fi  
      done
      rm shafile.txt  >/dev/null 2>&1
}

# Calling the function
commit_message_check 

