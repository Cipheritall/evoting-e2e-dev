# Secure Data Manager Installation

***Note: This guide describes how to install the Secure Data Manager in a local development environment. In order to make testing accessible this guide therefore simplifies certain procedures***
***The Secure Data Manager must be installed on a Windows machine. An installation on Linux or macOS is currently not supported.***

## Installation

1. Create folder ```C:\Users\<USERNAME>\SecureDataManager\```
2. Unzip ```secure-data-manager-package-X.X.X.X.zip``` in ```$EVOTING_HOME\secure-data-manager\packaging\target```
3. Copy the contents of the unzipped subfolder ```win64``` to ```C:\Users\<USERNAME>\SecureDataManager\ONLINE```
4. Copy the contents of ```evoting-e2e-dev\testdata\sdm\config``` into ```C:\Users\<USERNAME>\SecureDataManager\ONLINE\sdm\config```
5. Copy the contents of ```evoting-e2e-dev\testdata\sdm\sdmConfig``` into ```C:\Users\<USERNAME>\SecureDataManager\ONLINE\sdm\sdmConfig```
6. Create the file ```C:\USERS\<USERNAME>\SecureDataManager\ONLINE\sdm\sdmConfig\database_password.properties``` with the following content:

   >   ```bash
   >   password=<yourSDMDatabasePassword>
   >   ```
    **Note: The password must be non-null, have at least one upper case letter, at least one lower case letter, one digit and be at least of size 12**
7. Copy the contents of ```evoting-e2e-dev\testdata\sdm\systemKeys``` into ```C:\Users\<USERNAME>\SecureDataManager\ONLINE\sdm\systemKeys```
8. Copy the contents of ```evoting-e2e-dev\testdata\sdm\application-level-security\signed-http-headers\keystore``` into ```C:\Users\<USERNAME>\SecureDataManager\ONLINE\sdm\config\keystore```
9. Running an election event requires three different instances of the Secure Data Manager normally deployed on separate machines. To facilitate testing this guide describes how to deploy all instances on a single machine
10. Copy the folder ```C:\Users\<USERNAME>\SecureDataManager\ONLINE``` twice and once name it ```PREPROCESSING``` and once name it ```POSTPROCESSING```

## Configuration

### Pre-Processing SDM

Change the following property in ```C:\USERS\<USERNAME>\SecureDataManager\PREPROCESSING\sdm\sdmConfig\voting_portal.properties```

```bash
voting.portal.enabled=false
```

### Post-Processing SDM

Change the following property in ```C:\USERS\<USERNAME>\SecureDataManager\POSTPROCESSING\sdm\sdmConfig\voting_portal.properties```

```bash
voting.portal.enabled=false
```

## Running

Once you installed the Secure Data Manager, continue the instructions in [Run_Election_Event.md](Run_Election_Event.md).
