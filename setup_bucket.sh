#Set the project to use
echo "gcloud config set project $1"

#Create a bucket
echo "export BUCKET_NAME=terraform-training${RANDOM}"
echo "gsutil mb -l europe-west1 gs://${BUCKET_NAME}"
echo "echo Your bucket name is: $BUCKET_NAME"
