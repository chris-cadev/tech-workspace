# -*- coding: utf-8 -*-
import os
import google_auth_oauthlib.flow
import googleapiclient.discovery
import googleapiclient.errors
from dotenv import load_dotenv
import pysolr

load_dotenv()

scopes = [
    "https://www.googleapis.com/auth/youtube.readonly",
    "https://www.googleapis.com/auth/userinfo.email",
    "openid",
]

# Configure the Solr endpoint
# Example: "http://localhost:8983/solr/youtube_subscriptions"
SOLR_URL = os.environ["SOLR_URL"]


def extract_subs():
    api_service_name = "youtube"
    api_version = "v3"
    client_secrets_file = os.environ["GOOGLE_CREDENTIALS_FILE"]

    # Initialize OAuth flow to authenticate the user
    flow = google_auth_oauthlib.flow.InstalledAppFlow.from_client_secrets_file(
        client_secrets_file, scopes=scopes
    )
    credentials = flow.run_local_server()

    # Build the YouTube and OAuth2 API clients
    youtube_api = googleapiclient.discovery.build(
        api_service_name, api_version, credentials=credentials
    )
    oauth2_api = googleapiclient.discovery.build(
        'oauth2', 'v2', credentials=credentials)

    # Get the user's email
    user_info = oauth2_api.userinfo().get().execute()
    source_user_email = user_info["email"]

    # Get the authenticated user's channel ID and title
    channel_response = youtube_api.channels().list(
        part="snippet",
        mine=True
    ).execute()

    source_channel_id = channel_response["items"][0]["id"] if channel_response.get(
        "items", None) else None
    source_channel_title = channel_response["items"][0]["snippet"]["title"] if channel_response.get(
        "items", None) else None

    # Initialize the Solr client
    solr = pysolr.Solr(SOLR_URL, always_commit=True)

    # Fetch all subscriptions
    subscriptions = []
    next_page_token = None

    while True:
        request = youtube_api.subscriptions().list(
            part="snippet",
            mine=True,
            maxResults=50,
            pageToken=next_page_token
        )
        response = request.execute()
        subscriptions.extend(response["items"])

        next_page_token = response.get("nextPageToken")
        if not next_page_token:
            break

    # Prepare and send data to Solr
    solr_data = []
    for item in subscriptions:
        snippet = item["snippet"]
        solr_data.append({
            "id": snippet["resourceId"]["channelId"],  # Unique ID in Solr
            "sourceUserEmail": source_user_email,
            "sourceChannelId": source_channel_id,
            "sourceChannelTitle": source_channel_title,
            "channelId": snippet["resourceId"]["channelId"],
            "title": snippet["title"],
            "publishedAt": snippet["publishedAt"],
            "description": snippet["description"],
            "thumbnail": snippet["thumbnails"]["high"]["url"],
        })

    # Send all data to Solr
    solr.add(solr_data)


if __name__ == "__main__":
    extract_subs()
