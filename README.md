# DevExcuse Generator

A simple bash script to output excuses using the [DevExcus.es](https://api.devexcus.es/) API Database.

## Prerequisites

Make sure the following dependencies are installed on your system:

- `curl`
- `jq`

## Installation

Run the command below:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/K4R7IK/DevExcuse/master/install.sh)"
```
Make sure you have your `~/.local/bin` in your **PATH**

## Usage

Run the script:

```bash
devexcuse
```

~The script will fetch a development excuse from the DevExcus.es API and store it locally in a JSON file (`~/.config/devExcuse.json`). If an excuse with the same ID already exists in the file, the excuse will not be saved. Also when there is no internet connection the script will fetch a random excuse from local storage.~

Now the DB comes with the script. The excuses are fetch locally now.

## Configuration

- `DATA_FILE`: The path to the JSON file for storing excuses.
- If you want to have excuse in French or Italian instead of English you can modify `text_en` to `text_fr` for french and `text_it` for italian in the script.

You can configure your desired location where you want to store your excuse.json file.

## Acknowledgments

- [DevExcus.es](https://api.devexcus.es/) for providing the API & Data.

Feel free to contribute or open issues!
