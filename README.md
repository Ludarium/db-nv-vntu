# Deployment Guide for the it_department Database

This guide describes the process of deploying the server side of the database (MySQL) and configuring the client interface (MS Access) to ensure the system works correctly. Please follow the steps strictly in the specified order.

## Part 1. Installing and Configuring MySQL Server

**1. Installing Visual C++ Redistributable**
Install the `vc_redist.x64.exe` package (Microsoft Visual C++ Redistributable). This is a mandatory runtime component; without it, the MySQL server and ODBC drivers may fail to launch or work incorrectly.

**2. Installing MySQL Server**
Run `mysql-installer-community` and choose the **Full** setup type. You may find it here: https://dev.mysql.com/downloads/installer/. I personally recommend to download the .msi version in case you have to install with poor internet connection. Confirm all subsequent operations with the default settings. During the configuration process, create and **make sure to remember** a password for the `root` user — you will need it to connect. The "Full" installation ensures you get both the server itself and the MySQL Workbench application for convenient database management.

**3. Initializing Structure and Data**
Open any MySQL client (for example, the installed MySQL Workbench or HeidiSQL) and connect to your local server. Open and execute the following `.sql` files **strictly in the order listed** to avoid Foreign Key constraint errors:
*   `01_init.sql` — creates tables and relationships.
*   `02_testData.sql` — populates the database with basic and test data.
*   `03_procedures.sql` — creates stored procedures (if applicable).
*   `04_views.sql` — creates "smart" views for user-friendly display in Access.
*   `05_schedules.sql` — configures database schedules and events.

## Part 2. Configuring the ODBC Connection

**4. Installing the ODBC Connector**
Install the `mysql-connector-odbc` driver (x64 version). The architecture of the driver must match the architecture of your MS Office/Access and Windows (64-bit).

**5. Opening the ODBC Data Source Administrator**
Open the Windows Start menu, search for **ODBC Data Sources (64-bit)**, and run the application as an administrator.

**6. Creating a System DSN**
Go to the **System DSN** tab and click the **Add** button. Choosing a System DSN ensures that the connection will work for all users on the computer.

**7. Selecting the Driver**
In the list that appears, select the **MySQL ODBC X.X Unicode Driver** and click "Finish". It is crucial to select *Unicode* rather than *ANSI* so that Cyrillic text (Ukrainian/Russian) is displayed correctly in the database without rendering as random symbols.

**8. Configuring Data Source Parameters**
Fill out the connection form:
*   **Data Source Name (DSN):** Come up with a clear name (e.g., `VNTU_DB`). **Make sure to remember or write down this name**, as it is critically important for MS Access.
*   **TCP/IP Server:** Enter `localhost` or `127.0.0.1`.
*   **User / Password:** Enter your MySQL credentials (e.g., `root` and the password from Step 2).
*   **Database:** Select your database from the dropdown list (e.g., `it_department`).

**9. Critical Flags (Details)**
In the same window, click the **Details >>** button, go to the **Connection** tab (or *Cursors/Results* depending on the version), and **make sure** to check the boxes next to:
*   `Return matched rows instead of affected rows`
*   `Allow big result sets`
*These settings are necessary to prevent MS Access from freezing during complex queries and to ensure records update correctly without throwing a "#DELETED" error.*

**10. Saving**
Click **Test** to ensure the connection is successful, and then click **OK** to save the DSN.

## Part 3. Connecting the Client Application (MS Access)

**11. Launching the Client**
Open the `it_department.accdb` file using Microsoft Access.

**12. Launching the External Data Wizard**
On the top ribbon, navigate to the **External Data** tab -> **New Data Source** -> **From Other Sources** -> **ODBC Database**.

**13. Selecting the Link Type**
In the prompt window, select the second option: **"Link to the data source by creating a linked table"**. This allows Access to work with live data on the server instead of importing a static copy.

**14. Linking Tables and Views**
In the "Select Data Source" window, go to the **Machine Data Source** tab and select the DSN you created in Step 8. A list of all tables and Views from MySQL will appear:
*   Select all the necessary tables and views (`view_...`).
*   Click OK.
*   *Important: If Access asks you to specify a "Unique Record Identifier" for certain Views, be sure to select the `id` field so that the data remains updatable.*

## Part 4. Troubleshooting

**15. ODBC Connection Loss Error**
If you get an ODBC connection error when opening forms or tables (especially if you moved the database to a new PC), you need to refresh the links:
1. Go to: **External Data** -> **Linked Table Manager**.
2. Check the boxes next to all tables with a globe icon.
3. Press 'Edit' and update the **ODBC Connect Str** property to the actual name of your DSN: `DSN=Your DSN Name;...`.
# db-nv-vntu
