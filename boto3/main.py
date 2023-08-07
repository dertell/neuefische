import boto3
import logging
import time
from botocore.exceptions import ClientError

#session = boto3.Session(profile_name="default")
#s3 = session.client("s3", region_name="us-west-2")
#
#try:
#    s3.create_bucket(Bucket="myfirstboto3bucket1222", CreateBucketConfiguration={'LocationConstraint': "us-west-2"})
#except ClientError as e:
#    logging.error(e)

client = boto3.client('rds')
name = 'mydb'
pw = 'password123'
user = 'Admin'

try:
    response = client.create_db_instance(
        DBName = name,
        DBInstanceIdentifier = name,
        AllocatedStorage = 20,
        DBInstanceClass = 'db.t3.micro',
        Engine = 'mysql',
        MasterUsername = user,
        MasterUserPassword = pw,
        VpcSecurityGroupIds = ['sg-05a922210a8d7af43'],
        DBSubnetGroupName = 'mysubnetgroup',
        EngineVersion = '5.7'
    )
except ClientError as e:
    logging.error(e)

while True:
    time.sleep(60)
    response_desc = client.describe_db_instances(
        DBInstanceIdentifier = name)
    status = response_desc['DBInstances'][0]["DBInstanceStatus"]
    print(status)
    if status == "available":
        break

endpoint = response_desc["DBInstances"][0]["Endpoint"]["Address"]

ec2 = boto3.resource('ec2')

with open("wordpress_server/new-user-data.sh") as f:
    g = f.read()

g = g.replace('{DB}', name)
g = g.replace('{User}', user)
g = g.replace('{PW}', pw)
g = g.replace("{host}", endpoint)
g = g.replace("$", "")

try:
    instance = ec2.create_instances(
        ImageId = 'ami-00970f57473724c10',
        InstanceType = "t3.micro",
        KeyName='vockey',
        MaxCount=1,
        MinCount=1,
        IamInstanceProfile={
        'Name': 'LabInstanceProfile'
        },
        SecurityGroupIds=[
        'sg-05a922210a8d7af43'],
        UserData = g,
        TagSpecifications=[
            {   'ResourceType': 'instance',
                'Tags': [{
                        'Key': 'Name',
                          'Value': 'boto3ec2'},]
            }])
except ClientError as e:
    logging.error(e)