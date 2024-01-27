# DevExcuse Generator

A simple bash script to generate and store development excuses using the [DevExcus.es](https://devexcus.es/) API.

## Prerequisites

Make sure the following dependencies are installed on your system:

- `curl`
- `jq`

## Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/K4R7IK/devexcuse.git
   cd devexcuse
   ```

2. Make the script executable:

   ```bash
   chmod +x devexcuse.sh
   ```

## Usage

Run the script:

```bash
./devexcuse.sh
```

The script will fetch a development excuse from the DevExcus.es API and store it locally in a JSON file (`~/.config/devExcuse.json`). If an excuse with the same ID already exists in the file, the excuse will not be saved. Also when there is no internet connection the script will fetch a random excuse from local storage.

## Configuration

- `API_URL`: The DevExcus.es API endpoint.
- `DATA_FILE`: The path to the JSON file for storing excuses.

You can configure your desired location where you want to store your devExcuse.json file.

## Acknowledgments

- [DevExcus.es](https://devexcus.es/) for providing the API.

Feel free to contribute or open issues!
