# BEGIN CONFIG
# set the directory to search for OpenSSL libraries in (default: C:\)
$search_directory = “C:\”

# set to $true to show only OpenSSL version vulnerable to this bug
$only_vulnerable = $false
# END CONFIG

echo "starting scan"
    if ($only_vulnerable) {
	    $regex = "OpenSSL\s*3.0.[0-6]"
    }else{
	    $regex = "OpenSSL\s*[0-9].[0-9].[0-9]"
    }

# search for any DLLs whose name begins with libcrypto
Get-ChildItem -Path $search_directory -Include libcrypto*.dll,libssl*.dll -File -Recurse -ErrorAction SilentlyContinue | Foreach-Object {
# use RegEx to parse the dll strings for an OpenSSL Version Number
$openssl_version = select-string -Path $_ -Pattern $regex -AllMatches | % { $_.Matches } | % { $_.Value }
	if ($openssl_version) {
		# Print OpenSSL version number followed by file name
		echo "$openssl_version - $_ "
	    }
    }
