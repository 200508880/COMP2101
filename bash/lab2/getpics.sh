#!/bin/bash
#
# this script gets some picture files for our personal web pages, which are kept in public_html
# the pictures are put into a subdirectory of public_html named pics
# it does some error checking
# it summarizes the public_html/pics directory when it is done
#
# It should not be run as root
[ "$(whoami)" = "root" ] && echo "Not to be run as root" && exit 1

# Task 1: Improve this script to also retrieve and install the files kept in the https://zonzorp.net/pics.tgz tarfile
#   - use the same kind of testing that is already in the script to only download the tarfile if you don't already have it and
#     to make sure the download and extraction commands work
#     then delete the local copy of the tarfile if the extraction was successful

# Adding echoes so I know that it's working
echo "Downloading files..."

# make sure we have a clean pics directory to start with
rm -rf ~/public_html/pics
mkdir -p ~/public_html/pics || (echo "Failed to make a new pics directory" && exit 1)

# download a zipfile of pictures to our Pictures directory - assumes you are online
# unpack the downloaded zipfile if the download succeeded - assumes we have an unzip command on this system
# delete the local copy of the zipfile after a successful unpack of the zipfile
wget -q -O ~/public_html/pics/pics.zip http://zonzorp.net/pics.zip && unzip -d ~/public_html/pics -o -q ~/public_html/pics/pics.zip && rm ~/public_html/pics/pics.zip

# Task 1: Improve this script to also retrieve and install the files kept in the https://zonzorp.net/pics.tgz tarfile
#     test to make sure the download and extraction commands work
#     then delete the local copy of the tarfile if the extraction was successful

# Using the same kind of testing (found: test -d, using test -f)
# tar eXtract Zee Files
if [[ -f ~/public_html/pics/pics.tgz ]]; then
  echo "Archive found, not downloading."
else
# man tar says -C extracts to specified directory
  wget -q -O ~/public_html/pics/pics.tgz https://zonzorp.net/pics.tgz
  tar xzf ~/public_html/pics/pics.tgz -C ~/public_html/

  # It looks like pics.tgz also contains its own pics folder
  # It looks a little messy to have a pics/pics so I'm choosing to
  # assume it's meant to be merged with the pics directory created above

  # Test with one image we know to be in the archive:
  # This is not explicitly conclusive but should serve us for now
  if [[ -f ~/public_html/pics/hillpan_apollo15_big.jpg ]]; then
    rm ~/public_html/pics/pics.tgz
  else
    echo "Extraction incomplete. Unable to extract pics.tgz."
  fi
fi

echo "Done."

# Make a report on what we have in the Pictures directory
test -d ~/public_html/pics && cat <<EOF
Found $(find ~/public_html/pics -type f|wc -l) files in the public_html/pics directory.
The public_html/pics directory uses $(du -sh ~/public_html/pics|awk '{print $1}') space on the disk.
EOF
