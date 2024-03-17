#! /bin/bash

hugo=~/Documents/devel/repos/hugo-blog
public=~/Documents/devel/repos/ac1965.github.io

abort ()
{
    echo -e "\033[1;30m>\033[0;31m>\033[1;31m> ERROR:\033[0m${@}\n" && exit
}

info ()
{
    echo -e "\033[1;30m>\033[0;36m>\033[1;36m> \033[0m${@}\n"
}

warn ()
{
    echo -e "\033[1;30m>\033[0;33m>\033[1;33m> \033[0m${@}\n"
}

test -d ${hugo} && cd ${hugo} || abort "${hogo} directory not found."
# clean public
rm -fr public

info "Deploying updates to GitHub..."

# Build the project.
hugo # if using a theme, replace with `hugo -t <YOURTHEME>`

# Go To Public folder
test -d ${public} && cd ${public} || exit
info "rsync.."
rsync -at --delete --exclude=".git" ${hugo}/public/. .

# Add changes to git.
git add .
git commit -avm "update:$(env LANG=C date)" && git push
