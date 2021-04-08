#!/bin/bash
echo "Update Popularity"
api (){
    url="http://hbm-community-staging.mindship.tech/query"
    curl -sS --request POST \
      --url $url \
      --header 'Content-Type: application/json' \
      --data '{"query":"mutation{\n  updatePopularity(input:{\n    pagination:{\n      page:'$1'\n      limit: '$2'\n    }\n  }){\n    totalPage\n    currentPage\n    totalRecords\n    status\n  }\n}"}'
}
page=1
limit=5
totalPage=$(api $page $limit | awk '{ split($1,a,","); print a[1]}' | awk '{split($1,a,":"); print a[4]}')
while [ $page -le $totalPage ]
do
    echo -n "Processing page $page of $totalPage ..."
    status=$(api $page $limit | awk '{split($1,a,":"); print a[7]}'| awk '{ split($1,ar,"}"); print ar[1]}' )
    echo "Status: $status"
    page=`expr $page + 1`
done
