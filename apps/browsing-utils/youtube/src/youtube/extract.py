# -*- coding: utf-8 -*-
import os
import json

import google_auth_oauthlib.flow
import googleapiclient.discovery
import googleapiclient.errors

scopes = [
    "https://www.googleapis.com/auth/youtube.readonly",
]


def extract_subs():
    # Disable OAuthlib's HTTPS verification when running locally.
    # *DO NOT* leave this option enabled in production.
    os.environ["OAUTHLIB_INSECURE_TRANSPORT"] = "1"

    api_service_name = "youtube"
    api_version = "v3"
    client_secrets_file = os.environ["GOOGLE_CREDENTIALS_FILE"]

    # Get credentials and create an API client
    flow = google_auth_oauthlib.flow.InstalledAppFlow.from_client_secrets_file(
        client_secrets_file, scopes)
    credentials = flow.run_local_server()
    youtube_api = googleapiclient.discovery.build(
        api_service_name, api_version, credentials=credentials)

    # Initialize variables for pagination
    subscriptions = []
    next_page_token = None

    while True:
        # Make the API request to get the subscriptions of the logged-in user
        request = youtube_api.subscriptions().list(
            part="snippet",
            mine=True,
            maxResults=50,
            pageToken=next_page_token  # Use the nextPageToken for pagination
        )
        response = request.execute()

        # Add the subscriptions to the list
        subscriptions.extend(response["items"])

        # Check if there is a nextPageToken to continue
        next_page_token = response.get("nextPageToken")
        if not next_page_token:
            break  # Exit the loop if there are no more pages

    # Print the list of subscriptions (channels)
    # print(f"Total Subscriptions: {len(subscriptions)}")
    for item in subscriptions:
        channel_title = item["snippet"]["title"]
        channel_id = item["snippet"]["resourceId"]["channelId"]
        # print(f"Channel Title: {channel_title}, Channel ID: {channel_id}")
    
    with open('results.json', 'w') as f:
        f.write(json.dumps(subscriptions))


if __name__ == "__main__":
    extract_subs()
