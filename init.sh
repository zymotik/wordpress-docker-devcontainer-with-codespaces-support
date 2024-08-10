#!/bin/bash

# set -e
set -o pipefail

# Read the configuration.json file
config_file="./configuration.json"
plugin_names=$(jq -r '.plugins | keys[]' "$config_file")
plugin_dir="./www/wp-content/plugins"
blank_theme="blankslate.2024.2.zip"
blanktheme_dir="./src/theme"

mkdir -p "$plugin_dir"

# Loop through each plugin name
for plugin_name in $plugin_names; do
    # Get the version attribute for the plugin
    version=$(jq -r --arg name "$plugin_name" '.plugins[$name].version' "$config_file")
    
    # Print the version to the screen
    # Check if version has a value and print it
    plugin_filename=""
    if [[ -n $version ]]; then
        plugin_filename="$plugin_name.$version.zip"
    else
        plugin_filename="$plugin_name.zip"
    fi

    if [[ ! -d "$plugin_dir/$plugin_name" ]]; then
        if [[ ! -f "./downloads/plugins/$plugin_filename" ]]; then
            echo "Downloading $plugin_filename: $version"
            wget -P ./downloads/plugins "https://downloads.wordpress.org/plugin/$plugin_filename"
        fi
        
        download_exit_status=$?
        if [[ $download_exit_status -ne 0 ]]; then
            echo "Error occurred while downloading $plugin_filename."
        else
            echo "Unzipping $plugin_filename to $plugin_dir/$plugin_name..."
            sudo unzip -d "$plugin_dir/$plugin_name" "./downloads/plugins/$plugin_filename"
        fi
    else
        echo "Plugin $plugin_name already exists."
    fi
done

if [[ ! -d "./src/theme" ]]; then
    echo "Setting up a blank theme..."
    wget -P ./downloads/themes "https://downloads.wordpress.org/theme/$blank_theme"
    
    unzip -j -d "$blanktheme_dir" "./downloads/themes/$blank_theme"
fi

# TODO install the plugins
# docker-compose run --rm wpcli WORDPRESS_COMMAND ? or copy them to the plugin directory
