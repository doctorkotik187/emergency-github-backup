#!/usr/bin/env nu

# Configuration
let username = "doctorkotik187"
let backup_dir = ($"~/0-doctorkotik/0-core/4-ARCHIVES/web-backups/github" | path expand)

# Create directory if needed
mkdir -v $backup_dir

# Timestamp for backup
let timestamp = (date now | format date "%Y-%m-%d_%H-%M-%S")

# Fetch repos, exclude forks
http get $"https://api.github.com/users/($username)/repos"
| where fork == false
| each {
    |repo|
    let dest = $"($backup_dir)/($repo.name)_($timestamp).zip"
    let zip_url = $"https://github.com/($username)/($repo.name)/archive/refs/heads/($repo.default_branch).zip"

    # Download zip
    http get $zip_url --raw | save $dest

    # Safe print
    print $"Downloaded ($repo.name)"
    print $"Branch: ($repo.default_branch)"
    print $"Saved to: ($dest)"
    print "─"
}
| print $"Backup maybe done."
