from google.cloud import storage
import json
import pandas as pd

def read_json_google_storage(bucket_name, file_path):
    """
    Read JSON data from a text file in Google Cloud Storage.

    Parameters:
    - bucket_name (str): The name of the Google Cloud Storage bucket.
    - file_path (str): The path to the text file within the bucket.

    Returns:
    - pd.DataFrame:  A pandas DataFrame containing concatenated JSON data from all matched files.
    """
    # Initialize a Google Cloud Storage client
    client = storage.Client().from_service_account_json('static-retina-408319-21f8d1135093.json')

    # Get the specified bucket
    bucket = client.get_bucket(bucket_name)
    print(bucket)
    # Get the blob (file) from the bucket
    blobs = bucket.list_blobs(prefix=file_path)
    dfs = []

    for blob in blobs:
    # Download the file content as a string
        file_content = blob.download_as_text(encoding='utf-8-sig')

        # Parse the JSON data
        json_data = json.loads(file_content)
        
        columns = json_data["columns"]
        index = json_data["index"]
        data = json_data["data"]
        df= pd.DataFrame(data, columns=columns, index=index)

        dfs.append(df)
        
    final_df = pd.concat(dfs)

    return final_df