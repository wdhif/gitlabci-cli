# Getting started on gitlab 8.X

Control your GitlabCI workflow from your terminal

## Getting data from Gitlab

### Project ID
The Project ID is not clearly displayed by Gitlab 8. You will have to search in the menu of a project, for the Triggers section.
In it you will have various code example like this one:
```
curl -X POST \
     -F token=TOKEN \
     -F ref=REF_NAME \
     https://gitlab.fr/api/v3/projects/1234/trigger/builds
```
The project ID is 1234 in this example.

### Private token
The Private token can be generated in "Profile settings" of the user and in "Access token", you will have to generate a token with api access to use this CLI.

### Gitlab URL
Your gitlab server like this: ```https://gitlab.fr```

### Pipeline ID
If needed, you can provide the pipeline ID, you can get it on the "Pipelines" section of your project or with the gitlabci-cli list command.

