#!/bin/sh

# Downloads Iris Setosa Dataset
echo "Download Iris Setosa Dataset @gist"
curl -k https://gist.githubusercontent.com/netj/8836201/raw/6f9306ad21398ea43cba4f7d537619d0e07d5ae3/iris.csv -o ./data/iris.csv
