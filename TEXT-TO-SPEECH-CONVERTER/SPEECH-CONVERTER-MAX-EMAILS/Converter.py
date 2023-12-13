import json
from boto3 import Session, resource

def lambda_handler(event, context):
    session = Session(region_name="us-east-2")
    polly = session.client("polly")

    s3 = resource('s3')
    bucket_name = "lamda-text-to-speech"
    bucket = s3.Bucket(bucket_name)

    filename = "mynameis.mp3"
    myText = """
    Action: To set up the pipeline, I first created a GitHub repository to store the source code and used Git for version control. 
    Then, I used Jenkins to configure the pipeline and set up jobs to build and test the code whenever a push was made to the repository. 
    I used Maven to build the code and generate a jar file, and Docker to create a container image of the application and push it to a container registry. 
    I also used SonarQube to analyze the code for quality and security issues, and Kubernetes to deploy the application to a production environment.
    """

    response = polly.synthesize_speech(
        Text=myText,
        OutputFormat="mp3",
        VoiceId="Matthew"
    )
    stream = response["AudioStream"]

    bucket.put_object(Key=filename, Body=stream.read())

    return {
        'statusCode': 3,
        'body': json.dumps('Speech file generated and stored in S3')
    }
