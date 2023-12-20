{% macro read_json_google_storage(bucket_name, file_path) %}
{{ run_operation("python", sql("macros/read_json_google_storage.py"), kwargs={"bucket_name": bucket_name, "file_path": file_path}) }}
{% endmacro %}
