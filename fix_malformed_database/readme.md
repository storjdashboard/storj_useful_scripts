# SQLite Database Fixer Script

This repository contains a bash script designed to fix malformed SQLite database files. The script cycles through each `.db` file in a specified directory, checks its integrity, and attempts to fix any databases that fail the integrity check.

## Disclaimer

***********************************************************
* DISCLAIMER:                                             *
* This script is provided as-is with no warranties.       *
* The script originator takes no responsibility for any   *
* damage that may occur to the databases during its use.  *
* Use at your own risk.                                   *
***********************************************************


## Usage

1. **Clone the repository:**
    ```sh
    git clone https://github.com/storjdashboard/storj_useful_scripts.git
    cd storj_useful_scripts/fix_malformed_database
    ```

2. **Make the script executable:**
    ```sh
    chmod +x fix_script_automated.sh
    ```

3. **Run the script:**
    ```sh
    ./fix_script_automated.sh
    ```

4. **Follow the prompts:**
    - Acknowledge and accept the disclaimer.
    - Enter the directory containing the SQLite database files.
    - Enter the directory where you want to save backups.
    - Enter the directory where you want to save the fixed databases.

The script will then:
- Check the integrity of each `.db` file in the specified directory.
- If a database fails the integrity check, it will:
  - Backup the original database.
  - Export the database to an SQL file.
  - Create a new database from the SQL dump.
  - Check the integrity of the fixed database.
  - If the fixed database passes the integrity check, prompt the user to replace the original database with the fixed version.

## Contributing

Contributions are welcome! If you would like to contribute to this project, please fork the repository and submit a pull request. For major changes, please open an issue first to discuss what you would like to change.

## License

This project is licensed under the MIT License.
