#Set the project to use
gcloud config set project $1

#Create a bucket
export BUCKET_NAME=terraform-training${RANDOM}
gsutil mb -l europe-west1 gs://${BUCKET_NAME}
echo $BUCKET_NAME
