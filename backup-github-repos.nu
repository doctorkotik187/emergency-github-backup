#!/usr/bin/env nu

# Configuration
let username = "doctorkotik187"
let backup_dir = ($"~/Downloads" | path expand)

# Create directory if needed
mkdir create $backup_dir

# Timestamp for backup
let timestamp = (date now | format date "%Y-%m-%d_%H-%M-%S")

# Fetch repos without let binding - direct pipeline
http get $"https://api.github.com/users/($username)/repos"
| each {
    |repo|
    let dest = $"($backup_dir)/($repo.name)_($timestamp).zip"
    let zip_url = $"https://github.com/($username)/($repo.name)/archive/refs/heads/($repo.default_branch).zip"

    # Download zip
    http get $zip_url --raw | save $dest

    # Safe print - concatenate strings instead of complex interpolation
    print $"Downloaded ($repo.name)"
    print $"Branch: ($repo.default_branch)"
    print $"Saved to: ($dest)"
    print "─"
}
