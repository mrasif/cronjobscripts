#!/bin/bash
echo "Headline script"
api (){
    url="https://hbm-staging.mindship.tech/query"
    curl -sS --request POST \
        --url $url \
        --header 'Content-Type: application/json' \
        --data '{"query":"mutation{\n  updateHeadLine(input:{\n    pagination:{\n      page:'$1',\n      limit:'$2'\n    }\n  }){\n    totalPage\n    currentPage\n    totalRecords\n  }\n}"}'
}
page=1
limit=10
totalPage=$(api $page $limit | awk '{ split($1,a,","); print a[1]}' | awk '{split($1,a,":"); print a[4]}')
while [ $page -le $totalPage ]
do
    echo -n "Processing page $page of $totalPage ..."
    status=$(api $page $limit)
    echo "Status: true"
    page=`expr $page + 1`
done
