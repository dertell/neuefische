import boto3
from botocore.exceptions import ClientError
import logging

session = boto3.Session(profile_name='default')
bucketName = 'nf-rekognition-bucket'
tableName = 'nf-rekognition-table'

def main():
    listOfFiles = get_objects(bucketName)

    for file in listOfFiles:
        labels = detect_labels(bucketName, file)
        save_labels(file, labels)


def get_objects(bucket):
    client = session.client('s3')
    try:
        response = client.list_objects_v2(
            Bucket=bucket,
        )
    except ClientError as e:
        logging.error(e)

    files = [f['Key'] for f in response['Contents']]
    return files


def detect_labels(bucket, file):
    client = session.client('rekognition')
    try:
        response = client.detect_labels(
            Image={
                'S3Object': {
                    'Bucket': bucket,
                    'Name': file,
                }
            },
            MaxLabels=10
        )
    except ClientError as e:
        logging.error(e)

    labels = [label["Name"] for label in response["Labels"]]
    return labels


def save_labels(fileName, labels):
    client = session.client('dynamodb')
    try:
        response = client.put_item(
            TableName= tableName,
            Item={
                'Filename': {
                    'S':fileName
                },
                'Labels': {
                    'SS': labels
                }
            }
        )
    except ClientError as e:
        logging.error(e)


if __name__ == "__main__":
    main()