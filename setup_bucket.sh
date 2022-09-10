#Set the project to use
gcloud config set project $1

#Create a bucket
export BUCKET_NAME=terraform-training${RANDOM}/
gsutil mb gs://${BUCKET_NAME}
echo Your bucket name is: $BUCKET_NAME
