## Golf_SwingML
###### Leverage Google Cloud's Video Intelligence API to Annotate golf swing video!

![tiger_luis](https://user-images.githubusercontent.com/54315020/127782921-a7865d5b-bc42-46b4-ac52-438115267d3a.png)



Off the tee in the year 1997, the average PGA tour driving distance was 267 yards. At the same time Tiger Woods is outperforming his field by averaging 294 yards drives [(Woods PGA)](https://www.pgatour.com/stats/stat.101.y1997.html).  As of August 2021, the tour average driving distance has caught up to Mr. Woods. Today a normal drive on the men’s tour is a whopping 295 yds. With the number one player hitting an average distance of 320 yds [(DeChambeau PGA)](https://www.pgatour.com/content/pgatour/stats/stat.101.y2021.html). If the pros can increase their driving distance, why can’t you?

This project uses Python and Google’s Video Intelligence Application Interface (API) to analyze golf swing video footage to better understand how the best in the world hit the long ball. Specifically, Google Cloud (GC) offers services that allow programmers to leverage cloud storage and machine learning to annotate video with labels. The GC API produces a Java Script Object Notation (JSON) file that contains a dictionary object that labels coordinates on the video and estimates what the point is, such as eyes, nose, shoulder, elbow and wrist. These annotations are then processed using python pandas, matplotlib, and math libraries to produce a Comma Separated Values (CSV) file that contains a time series of golf wing angles, such as that of the left elbow.

## Google Cloud Bucket Setup 

To setup a Google bucket sign into a google cloud account and browse to the CloudStorage menu. Click on Create Bucket, type a globally unique and permanent name, select region location, select standard storge class for data, and then select uniform access control.  This last step allows for permissions to the resource via Identity Access Management (IAM).  Next, browse to Create Project, click create; note that a project name, organization, and location are setup here. Before the API can access the bucket and video mp4 file configure permissions by browsing to Service Accounts and selecting Create Service Account. Type a service account name, grant the role of owner and select done. Select the service account just created and click on Keys, Add Key, and Create.  Check the downloads folder and there will be a unique alphanumeric JSON file that will allow remote access to the cloud resource. Store this key the same directory used to start virtual environment 

Create [bucket](https://cloud.google.com/storage/docs/creating-buckets), Configure [Service Account](https://cloud.google.com/iam/docs/creating-managing-service-accounts), and [Project](https://cloud.google.com/resource-manager/docs/creating-managing-projects). 

![image](https://user-images.githubusercontent.com/54315020/127780661-e130c244-b94a-4afc-b323-41a79c4c7e50.png)

## Async API Request 

Goolge’s VideoIntelligence_v1 Application Interface (API) parses video and applies a machine learning model to detect a person in the video. Specifically, this project analyzes a video of me at the driving range using hitting 50 golf balls with a driver club on a sunny day in Iowa. The API VideoIntelligenceServiceAsyncClient [(google cloud client libraries)](https://googleapis.dev/python/videointelligence/latest/videointelligence_v1/video_intelligence_service.html) uses the annotation_video method to process a preconfigured request file that contains all the arguments necessary to asynchronously parse the video detect a person and their movements. 

To setup the request, first it is necessary to configure the virtual environment with an access token.  Run the command `export GOOGLE_APPLICATION_CREDENTIALS=”alpha-numeric_key.json”` with the credentials pointing to the file downloaded and now saved in the virtual environment. Once the credentials have been setup create file named request.json using notepad and save the file. This json file contains the parameters that are used to trigger the annotation by the google service. The script can be found in the Google API [documentation](https://cloud.google.com/video-intelligence/docs/people-detection#video_detect_person_gcs-drest). The two most important parameters in this script are the *inputUri* and *features*.  The first parameter `gs://alvarez-golfswingml-bucket/Golf_Swing_Clean.mp4` is the cloud storage bucket and video file to be processed by the annotation algorithm. The second parameter denotes the type of annotation which in this case is `PERSON_DETECTION`.  Note, the google API also has methods that can run facial recognition, track objects, transcribe videos, and much more.


Contents of request.json file 
source: [Cloud_Video_Intelligence_API](https://cloud.google.com/video-intelligence/docs/people-detection#video_detect_person_gcs-drest)

`{
    "inputUri": "gs://alvarez-golfswingml-bucket/Golf_Swing_Clean.mp4",
    "features": ["PERSON_DETECTION"],
    "videoContext": {
      "personDetectionConfig": {
        "includeBoundingBoxes": true,
        "includePoseLandmarks": true,
        "includeAttributes": true
       }
    }
  }
`

Using the terminal proves to be the fastest way of processing the video and has the least number of dependencies.  When compared to setting up the google cloud Software Development Kit a lot less work is needed to process a video.  However, since this project is only running batch processing it is not necessary to setup a full data pipe-line.  With more time and effort the docs clearly explain how this can be accomplished programmatically using languages like python, java and node.js. From the terminal run the following curl command to send a `POST` request to the `annotation_video` method.

`curl -X POST \
-H "Authorization: Bearer "$(gcloud auth application-default print-access-token) \
-H "Content-Type: application/json; charset=utf-8" \
-d @request.json \
https://videointelligence.googleapis.com/v1/videos:annotate`

## Stumbling Block: "What is... name?"
The process will take less than a minute to register with a `name`. While trying to complete this project programmatically using python and jupyter notebook this `name` detail was elusive. Much of the API reference materials reference a name string that can be used to retrieve the parsed data via a python *coroutine*. After stumbling on not being able to find the string name for quite some time I regrouped by researching how to perform this operation using the Command Line. From here I was able to find that the project name-string is returned by the videos:annotate method and in my case it was configured with information I knew except for the unique 24 digit  operation id.  In order to retrieve the information, the API again provides a shell script that can be run after it is configured with the specific information to retrieve the annotations.


###### Response name-string
`{
  "name": "projects/PROJECT_NUMBER/locations/LOCATION_ID/operations/OPERATION_ID"
}`

## Configure Response command: 
* PROJECT_NUMBER: found in google cloud project 
* LOCATION_ID: data center location selected during bucket creation e.g., us-west1
* OPERATION_ID:  unique 24-digit code to identify the long running operation 

`GET response command
curl -X GET \
-H "Authorization: Bearer "$(gcloud auth application-default print-access-token) \
https://videointelligence.googleapis.com/v1/projects/82932726978/locations/us-west1/operations/17480310946357676047 > ML_out.json`

Given more time I believe I can write a python program to automate video annotation using the Google Cloud’s VideoIntelligence_v1API.  Also, an interesting evolution of this project is to use the beta version of this api an annotate video in real time by an application to get instant feedback on golf swing. 




