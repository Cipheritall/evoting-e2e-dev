# Run an Election Event in a local Docker Development Environment

**The Secure Data Manager must be installed on a Windows machine. An installation on Linux or macOS is currently not supported.**\
**In order to facilitate the testing in a local development environment this guide simplifies certain configurations.**\
**All keys, certificates and passwords provided are pregenerated for the purpose of these tests only.**\
**Make sure the system is ready using the ```docker ps``` command to check that all docker containers are healthy.**

**Placeholders:**

- INSTANCE: ConfigSDM | OnlineSDM | TallySDM
- N: Number 1..2

## Instances of the SDM

Running an Election Event requires three separate instances of the Secure Data Manager (SDM), normally deployed on different machines.\
To facilitate testing, this guide describes how to run a test when all three instances of the SDM are deployed on a single machine:

- ```C:/tmp/secure-data-manager-<version>/ConfigSDM/win64/SecureDataManager.exe```
- ```C:/tmp/secure-data-manager-<version>/OnlineSDM/win64//SecureDataManager.exe```
- ```C:/tmp/secure-data-manager-<version>/TallySDM/win64//SecureDataManager.exe```

### One instance of the SDM is deployed on a machine connected to the internet:

- Online SDM: Instance of the SDM which connects to the voter-portal

![Online SDM](../.gitlab/media/online-sdm.png)

### Two instances of the SDM are deployed on airgapped machines:

- **Config SDM**: Instance of the SDM which generates the Election Event configuration

![Config SDM](../.gitlab/media/config-sdm.png)

- **Tally SDM**: Instance of the SDM which performs the offline mixing and decryption after an Election Event

![Tally SDM](../.gitlab/media/tally-sdm.png)

---

## Day 1 - Setting up the election event

### Online SDM - Import test data:

![Online SDM](../.gitlab/media/online-sdm.png)

**Workflow:**
1. Launch the Online SDM in ```C:/tmp/secure-data-manager-<version>/OnlineSDM/win64/SecureDataManager.exe```
2. Click **IMPORT**
3. Navigate and select the Testdata previously downloaded at: [TESTDATA](../testdata/testdata-external/sdm/import-me.sdm)
4. Click **Open**

---

### Online SDM - Request and import the CC-Keys
This function provides the public keys of the control components.
These keys are crucial for verifiability and privacy protection in the cryptographic protocol.

**Workflow:**
1. Click **Election Events** to select your election event in the SDM
2. Select ```Post_E2E_DEV```
3. Click on **REQUEST CC KEYS** to start the import.
4. Wait for successful confirmation by the SDM.

---

### Online SDM - Export Election Event

**Workflow:**
1. Click **Election Events**
2. Select **Post_E2E_DEV**
3. Click **EXPORT**
4. **Select all items**
5. Enter the password of the ```integration_online.p12```(*The password for the integration_online.p12 provided for tests is "222222"*)
6. Click **EXPORT**
7. Select an arbitrary location for the Election Event, e.g. ```C:/tmp/1-export-Post_E2E_DEV```
8. Wait until all data has successfully been exported
9. Close the Online SDM

---

### Config SDM - Import Election Event

![Config SDM](../.gitlab/media/config-sdm.png)

**Workflow:**
1. Launch the Config SDM in ```C:/tmp/secure-data-manager-<version>/ConfigSDM/win64/SecureDataManager.exe```
2. Click **IMPORT**
3. Select the Election Event previously exported to ```C:/tmp/1-export-Post_E2E_DEV```
4. Click **Open**

---

### Config SDM - Constitute the Admin Board

In order to make testing accessible, this guide describes a special configuration for automated E2E Tests where the Smart Cards are simulated and no physical hardware is required.\
This configuration is activated by the property ```smartcards.profile=e2e``` in ```C:/tmp/secure-data-manager-<version>/win64/sdm/sdmConfig/sdm.properties```\
The threshold of the number of Administration Board members required to activate the Administration Board is configurable.\
In order to simplify testing a single member of the Administration Board can activate the Administration Board in the current configuration.

**Workflow:**
1. Click **Administration Boards**
2. Select **Admin Board**
3. Click **CONSTITUTE**
4. Click **CHOOSE FILE**
5. Select the [tenant key file](../testdata/testdata-external/sdm/tenant/tenant_100.sks)
6. Enter the password of the tenant key (see [tenant_PW.txt](../testdata/testdata-external/sdm/tenant/tenant_PW.txt))
7. Click **Open**
8. Navigate to ```C:/tmp/secure-data-manager-<version>/ConfigSDM/win64/sdm/smart-cards```
9. For each member of the Administration Board (e.g. 2 members):
   + Create an empty text file *smart-card.b64*
   + Enter a PIN (*e.g. "222222" - When simulating Smart Cards the PIN has no effect*)
   + Click **OK**
   + Rename the file ```smart-card.b64``` to ```smart-card.b64.ab<N>``` (*e.g. smart-card.b64.ab1, smart-card.b64..ab2*)
10. The directory ```C:/tmp/secure-data-manager-<version>/ConfigSDM/win64/sdm/smart-cards``` shall contain:
-  *smart-card.b64.ab1*
-  *smart-card.b64.ab2*

---

### Config SDM - Secure the Election Event

**Workflow:**
1. Click **Election Events**
2. Select ```Post_E2E_DEV```
3. Click **SECURE**
4. The status of the Election Event will change to **Ready**

---

### Config SDM - Activate the Administration Board

**Workflow:**
1. Click ```Post_E2E_DEV```
2. Click **Activate Administration Board**
3. Navigate to ```C:/tmp/secure-data-manager-<version>/ConfigSDM/win64/SecureDataManager.exe```
4. For each member of the Administration Board:
   + Rename the corresponding ```AB<N>.b64``` file to ```smart-card.b64```
   + Enter the PIN (*e.g. "222222"*)
   + Click **OK**
   + Rename the file ```smart-card.b64``` back to ```smart-card.b64.<N>``` (*e.g. smart-card.b64.ab1, smart-card.b64.ab2*)
5. For each member of the Administration Board:
   + Click **ACTIVATE**

---

### Config SDM - Prepare Ballot and Voting Card Sets

**Workflow:**
1. Click **Ballots**
2. **Select all Ballots**
3. Click **SIGN**
4. Click **Voting Card Sets**
5. Click **LOCKED**
6. **Select all Voting Card Sets**
7. Click **PRECOMPUTE** (*The status changes to "Pre-computing" - This process can take some time*)

---

### Config SDM - Export Election Event

For real Election Events the export and transfer would be performed with USB Sticks.

**Workflow:**
1. Click **Election Events**
2. Select **Post_E2E_DEV**
3. Click **EXPORT**
4. **Select all items**
5. Enter the password of the ```integration_online.p12``` (*The password for the integration_online.p12 provided for tests is "222222"*)
6. Click **EXPORT**
7. Select an arbitrary location for the Election Event, e.g. ```C:/tmp/2-export-Post_E2E_DEV```
8. Wait until all data has successfully been exported
9. Close the Config SDM

---

### Online SDM - Import Election Event

![Online SDM](../.gitlab/media/online-sdm.png)

**Workflow:**
1. Launch the Online SDM in ```C:/tmp/secure-data-manager-<version>/OnlineSDM/win64/SecureDataManager.exe```
2. Click **IMPORT**
3. Select the Election Event previously exported to ```C:/tmp/2-export-Post_E2E_DEV```
4. Click **Open**

---

### Online SDM - Compute Voting Card Sets

**Workflow:**
1. Click **Election Events**
2. Select ```Post_E2E_DEV```
3. Click **Voting Card Sets**
4. Click **PRE-COMPUTED**
5. **Select all Voting Card Sets**
6. Click **COMPUTE** (*The status changes to "Computing" - This process can take some time*)
7. Click **SYNC** repeatedly until all Voting Card Sets appear under **COMPUTED**
8. Click **COMPUTED**
9. **Select all Voting Card Sets**
10. Click **DOWNLOAD**
11. All Voting Card Sets has been moved to **DOWNLOADED**

---

### Online SDM - Export Election Event

**Workflow:**
1. Click **Election Events**
2. Select ```Post_E2E_DEV```
3. Click **EXPORT**
4. **Select all items**
5. Enter the password of the ```integration_online.p12```(*The password for the integration_online.p12 provided for tests is "222222"*)
6. Click **EXPORT**
7. Select an arbitrary location for the Election Event, e.g. ```C:/tmp/3-export-Post_E2E_DEV```
8. Wait until all data has successfully been exported
9. Close the Online SDM

---

### Config SDM - Import Election Event

![Config SDM](../.gitlab/media/config-sdm.png)

**Workflow:**
1. Launch the Config SDM in ```C:/tmp/secure-data-manager-<version>/ConfigSDM/win64/SecureDataManager.exe```
2. Click **IMPORT**
3. Select the Election Event previously exported to ```C:/tmp/3-export-Post_E2E_DEV```
4. Click **Open**

---

### Config SDM - Download and generate Voting Card Sets

**Workflow:**
1. Click **Election Events**
2. Select ```Post_E2E_DEV```
3. Click **Voting Card Sets**
4. Click **DOWNLOADED**
5. **Select all Voting Card Sets**
6. Click **GENERATE**
7. All Voting Card Sets has been moved to **GENERATING**
8. Click **UPDATE GENERATING STATUS** repeatedly until all Voting Card Sets appear under **GENERATED**

---

### Config SDM - Sign Voting Card Sets

**Workflow:**
1. Click **Activate Administration Board**
2. Navigate to ```C:/tmp/secure-data-manager-<version>/ConfigSDM/win64/sdm/smart-cards```
3. For each member of the Administration Board:
   + Rename the corresponding ```smart-card.b64.ab<N>``` file to ```smart-card.b64```
   + Enter the PIN (*e.g. "222222"*)
   + Click **OK**
   + Rename the file ```smart-card.b64``` back to ```smart-card.b64.<N>``` (*e.g. smart-card.b64.ab1, smart-card.b64.ab2*)
4. For each member of the Administration Board:
   + Click **ACTIVATE**
5. Click **GENERATED**
6. **Select all Voting Card Sets**
7. Click **SIGN**
8. All Voting Card Sets are now under **SIGNED**

---

### Config SDM - Generate print file

**Workflow:**
1.  Click **SIGNED**
2. **Select all Voting Card Sets**
3. Click **GENERATE PRINT FILE**

---

## Day 2 - Release of the election event

### Config SDM - Constitute Electoral Authorities

**Workflow:**
1. Click **Election Events**
2. Click **Post_E2E_DEV**
3. Click **Electoral Authorities**
4. Select the Electoral Authority *Post_E2E_DEV*
5. Click **CONSTITUTE**
6. Enter two times the EA1 password (*e.g. "E-voting_EA1"*)
7. Click **OK**
8. Enter two times the EA2 password (*e.g. "E-voting_EA2"*)
9. Click **OK**
10. Wait for successful confirmation by the SDM. The status of the Election Event will change to **Ready**

---

### Config SDM - Sign Electoral Authorities

**Workflow:**
1. Click **Electoral Authorities**
2. Select **Post_E2E_DEV**
3. Click **SIGN**
4. Wait for successful confirmation by the SDM.

---


### Config SDM - Sign Test Ballot Boxes

**Workflow:**
1. Click **Election Events**
2. Select **Post_E2E_DEV**
3. Click **Ballot Boxes**
4. Click **READY**
5. Click **TEST**
6. **Select all Ballot Boxes** (*Regular and Test Ballot Boxes*)
7. Click **SIGN**
8. All Ballot Boxes are now under **SIGNED**

---

### Config SDM - Export Election Event and Transfer to the Online SDM

**Workflow:**
1. Click **Election Events**
2. Select **Post_E2E_DEV**
3. Click **EXPORT**
4. **Select all items**
5. Enter the password of the ```integration_online.p12``` (*The password for the integration_online.p12 provided for tests is "222222"*)
6. Click **EXPORT**
7. Select an arbitrary location for the Election Event, e.g. ```C:/tmp/4-export-Post_E2E_DEV```
8. Wait until all data has successfully been exported
9. Close the Config SDM

---

### Online SDM - Import Election Event in the Online SDM

![Online SDM](../.gitlab/media/online-sdm.png)

**Workflow:**
1. Launch the Online SDM in ```C:/tmp/secure-data-manager-<version>/OnlineSDM/win64/SecureDataManager.exe```
2. Click **IMPORT**
3. Select the Election Event previously exported to ```C:/tmp/4-export-Post_E2E_DEV```
4. Click **OK**

---

### Online SDM - Synchronize Election Event

**Workflow:**
1. Click **Election Events**
2. Select **Post_E2E_DEV**
3. Click **SYNC** (*in order to synchronize the Election Event with the voter portal*)
4. Verify that all elements were successfully signed and synchronized:
   + Ballots
   + Voting Card Sets
   + Electoral Authorities
   + Ballot Boxes

Note: If all status are not "synchronized", please click again on **SYNC**, this is a known issue

---

### Online SDM - Export Election Event

**Workflow:**
1. Click **Election Events**
2. Select ```Post_E2E_DEV```
3. Click **EXPORT**
4. **Select all items**
5. Enter the password of the ```integration_online.p12```(*The password for the integration_online.p12 provided for tests is "222222"*)
6. Click **EXPORT**
7. Select an arbitrary location for the Election Event, e.g. ```C:/tmp/5-export-Post_E2E_DEV```
8. Wait until all data has successfully been exported
9. Close the Online SDM

### Voter-portal - Submit Votes

The Election Event ID EEID is a hex number, e.g. ```dfffc06a3ee249fa9b72584507a55fd3```
The current EEID corresponds to the folder name in ```C:/tmp/secure-data-manager-<version>/ConfigSDM/win64/sdm/config```

The voter needs 4 values:
1. Start Voting Key: Initializing (e.g. ihhrubtmb3rpchyu6kvg)
2. Ballot Casting Key: Confirmation
3. Vote Cast Code: Finalisation
4. Date of birth: 2nd factor (e.g. 01011970)

The first 3 values can be found in ```C:/tmp/secure-data-manager-<version>/ConfigSDM/win64/sdm/config/<EEID>/ONLINE/printing/evoting-print_Post_E2E_DEV.xml:```\
![img.png](../.gitlab/media/evoting-print_Post_E2E_DEV.png)

The 4th value can be found in ```C:/tmp/secure-data-manager-<version>/ConfigSDM/win64/sdm/config/<EEID>/ONLINE/printing/<votingCardSetID>/aliases.csv:```\
![img.png](../.gitlab/media/aliases.png)

---

### Web Browser - Submit Votes

**Workflow:**
1. Open the following URL in your browser: http://localhost:7000/vote/#/legal-terms/EEID
2. Acknowledge the **Legal Terms**
3. In order the authenticate yourself as a voter enter:
   + the **Start Voting Key**
   + the **date of birth**
4. Make your selection
5. Validated your choice
6. Confirm your choice with your **Vote Cast Code**

---

## Day 3 - Closing of the election event

![Online SDM](../.gitlab/media/online-sdm.png)

### Online SDM - Import Election Event in the Online SDM

**Workflow:**
1. Launch the Online SDM in ```C:/tmp/secure-data-manager-<version>/OnlineSDM/win64/SecureDataManager.exe```
2. Click **IMPORT**
3. Select the Election Event previously exported to ```C:/tmp/5-export-Post_E2E_DEV```
4. Click **OK**

### Online SDM - Mixing the Ballot Boxes

**Workflow:**
1. Click **Election Events**
2. Select ```Post_E2E_DEV```
3. Click **Ballot Boxes**
4. Click **SIGNED**
5. Select all Ballot Boxes (*Regular and Test Ballot Boxes*)
6. Click **MIX**
7. **Enter the shown Verification Code**
8. Click **CONFIRM** (*This process can take some time*)
9. **Select all Ballot Boxes** (*Regular and Test Ballot Boxes*)
10. Click **MIXING**
11. Click **UPDATE MIXING STATUS** repeatedly until all Ballot Boxes appear under **MIXED**

---

### Online SDM - Download the Ballot Boxes

**Workflow:**
1. Click **Ballot Boxes**
2. Click **MIXED**
3. Select all Ballot Boxes (*Regular and Test Ballot Boxes*)
4. Click **DOWNLOAD**
5. Wait until all Ballot Boxes appear under **DOWNLOADED**

---

### Online SDM - Export and Transfer the Election Event to the Post-Processing SDM

**Workflow:**
1. Click **Election Events**
2. Select **Post_E2E_DEV**
3. Click **EXPORT**
4. **Select all items**
5. Enter the password of the ```integration_online.p12``` (*The password for the integration_online.p12 provided for tests is "222222"*)
6. Click **EXPORT**
7. Select an arbitrary location for the Election Event, e.g. ```C:/tmp/6-export-Post_E2E_DEV```
8. Wait until all data has successfully been exported
9. Close the Online SDM

---

### Tally SDM - Import Election Event

![Tally SDM](../.gitlab/media/tally-sdm.png)

**Workflow:**
1. Launch the Tally SDM in ```C:/tmp/secure-data-manager-<version>/TallySDM/win64/SecureDataManager.exe```
2. Click **IMPORT**
3. Select the Election Event previously exported to ```C:/tmp/6-export-Post_E2E_DEV```
4. Click **OK**

---

### Tally SDM - Activate the Administration Board

**Workflow:**
1. Copy the simulated smart cards of the Administration Board and Electoral Authority from
   + C:/tmp/secure-data-manager-<version>/ConfigSDM/win64/sdm/smart-cards to
   + C:/tmp/secure-data-manager-<version>/TallySDM/win64/sdm/smart-cards
2. Click **Election Events**
3. Select **Post_E2E_DEV**
4. Click **Activate Administration Board**
5. Navigate to ```C:/tmp/secure-data-manager-verison/TallySDM/win64/sdm/smart-cards```
6. For each member of the Administration Board:
   + Rename the corresponding ```smart-card.b64.ab<N>``` file to ```smart-card.b64```
   + Enter the PIN (*e.g. "222222"*)
   + Click **OK**
   + Rename the file ```smart-card.b64``` back to ```smart-card.b64.ab<N>``` (*e.g. smart-card.b64.ab1, smart-card.b64.ab2*)
7. For each member of the Administration Board:
   + Click **ACTIVATE**

---

### Tally SDM - Offline Mixing and Decryption

**Workflow:**
1. Click **Ballot Boxes**
2. Click **DOWNLOADED**
3. Select all Ballot Boxes (*Regular and Test Ballot Boxes*)
4. Click **DECRYPT**
5. Enter two times the EA1 password (*e.g. "E-voting_EA1"*)
6. Click **OK**
7. Enter two times the EA2 password (*e.g. "E-voting_EA2"*)
8. Click **OK**
9. Wait until all data has successfully been decrypted

Note: Steps 5 to 8 can take some time.


---

### Tally SDM - Election Results

The list of prime numbers corresponding to the chosen voting options can be found in the file decompressedVotes.csv under
```C:/tmp/secure-data-manager-<version>/TallySDM/wind64/sdm/config/<EEID>/ONLINE/electionInformation/ballots/<ballotID>/ballotBoxes/<ballotBoxID>```

**Workflow:**
1. Click **DECRYPTED**
2. Verify that all Ballot Boxes appear

---

### Tally SDM - Generate tally files

**Workflow:**
1. Verify that all Ballot Boxes appear
2. **Select all Voting Card Sets**
3. Click **GENERATE TALLY FILES**

---

## Day 4 - Data deletion

### Cleanup
In order to re-run the Election Event a cleanup of the previous Election Event is needed.

**Workflow:**
For each SDM instance <INSTANCE> (ConfigSDM, OnlineSDM, TallySDM) delete following files and directories:
- ```C:/tmp/secure-data-manager-<version>/<INSTANCE>/win64/sdm/config/*.*```
- ```C:/tmp/secure-data-manager-<version>/<INSTANCE>/win64/sdm/logs```
- ```C:/tmp/secure-data-manager-<version>/<INSTANCE>/win64/sdm/sdmConfig/elections_config.json```
- ```C:/tmp/secure-data-manager-<version>/<INSTANCE>/win64/sdm/smdDB```