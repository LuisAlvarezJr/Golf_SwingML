#!/bin/sh


# Set API access token credentials
export GOOGLE_APPLICATION_CREDENTIALS="golfswingml-b92ada60eb03.json"

# Source: https://cloud.google.com/video-intelligence/docs/people-detection#video_detect_person_gcs-drest
# request annotate_video method to label video
curl -X POST \
-H "Authorization: Bearer "$(gcloud auth application-default print-access-token) \
-H "Content-Type: application/json; charset=utf-8" \
-d @request.json \
https://videointelligence.googleapis.com/v1/videos:annotate

# Get response from api with labled json file
curl -X GET \
-H "Authorization: Bearer "$(gcloud auth application-default print-access-token) \
https://videointelligence.googleapis.com/v1/projects/82932726978/locations/us-west1/operations/12834128508130435308 > tiger.json
