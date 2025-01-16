# Define the directories array
$directories = @(
    "E:\media-server\qbittorrent\config"
    "E:\media-server\downloads"
    "E:\media-server\radarr\config"
    "E:\media-server\radarr"
    "E:\media-server\sonarr\config"
    "E:\media-server\sonarr"
    "E:\media-server\lidarr\config"
    "E:\media-server\lidarr"
    "E:\media-server\prowlarr\config" # New directory for Prowlarr
    "E:\media-server\overseerr\config" # New directory for Overseerr
    "E:\media-server\homarr\config" # New directory for Homarr
)

# Create directories if they do not exist
foreach ($dir in $directories) {
    if (-Not (Test-Path -Path $dir)) {
        New-Item -ItemType Directory -Path $dir
    }
}

# Change ownership to the current user for all directories
foreach ($dir in $directories) {
    $acl = Get-Acl $dir
    $acl.SetOwner([System.Security.Principal.NTAccount]::new("$env:USERNAME"))
    Set-Acl $dir $acl
}

# Set appropriate permissions for directories and subdirectories
foreach ($dir in $directories) {
    $acl = Get-Acl $dir
    $permission = "$env:USERNAME", "FullControl", "ContainerInherit, ObjectInherit", "None", "Allow"
    $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission
    $acl.SetAccessRule($accessRule)
    Set-Acl $dir $acl
}

Write-Output "Directories created and permissions set."