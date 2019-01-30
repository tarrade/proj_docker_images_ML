
https://cloud.google.com/sdk/gcloud/reference/builds/submit

- standard timeout is 10min (not sufficient for large env here)

```
gcloud builds submit . --tag gcr.io/ml-productive-pipeline-53122/bigplay-image --timeout=1h  --disk-size=200gb
```
