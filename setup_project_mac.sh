gcloud config set project $1
find . -type f -name "main.tf" -exec gsed -i "s/project =.*/project = \"$1\"/g" {} +
find . -type f -name "main.tf" -exec gsed -i "s/project_id =.*/project_id = \"$1\"/g" {} +