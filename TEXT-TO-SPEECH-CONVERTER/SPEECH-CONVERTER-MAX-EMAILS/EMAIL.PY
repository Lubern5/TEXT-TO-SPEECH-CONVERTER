import boto3

s3 = boto3.client('s3')
ses = boto3.client('ses')
sns = boto3.client('sns')

def lambda_handler(event, context):
    # Extract S3 bucket and object information from the event
    bucket = "lamda-text-to-speech-datebase"
    key = "lamda-text-to-speech-datebase"

    # Compose email content
    sender_email = 'lubern5@yahoo.com'
    recipient_email = 'lubern5@yahoo.com'
    subject = 'File Uploaded to S3'
    body = f'A new file {key} has been uploaded to {bucket}.'

    # Send email using SES
    ses_response = ses.send_email(
        Source=sender_email,
        Destination={'ToAddresses': [recipient_email]},
        Message={
            'Subject': {'Data': subject},
            'Body': {'Text': {'Data': body}}
        }
    )

    # Publish a message to SNS
    sns_topic_arn = 'arn:aws:sns:us-east-2:250040685263:TEST'
    sns_message = f'A new file {key} has been uploaded to {bucket}.'
    sns_response = sns.publish(
        TopicArn=sns_topic_arn,
        Message=sns_message
    )

    return {
        'statusCode': 200,
        'body': 'Notification sent successfully.'
    }
