# WordPress Docker devcontainer

A docker devcontainer with Codespaces support for local and remote development of WordPress plugins and themes.

## Useful reference

```sh
# get plugin versions
for dir in */; do grep -H "Stable tag: [0-9]*\.[0-9]*" "$dir/readme.txt"; done;
```

## Custom or premium plugins

"advanced-custom-fields-pro": {
    "version": "5.10"
},
"compare": {
    "version": "compare"
}
