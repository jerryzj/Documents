# Download Google Drive files via wget

## Setup

1. Add this code to your `~/.bash_aliases` file.
```
function gdrive_download () {
  CONFIRM=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate "https://docs.google.com/uc?export=download&id=$1" -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')
  wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$CONFIRM&id=$1" -O $2
  rm -rf /tmp/cookies.txt
}
```
2. Get fileid from google share link

The link has the form like `https://docs.google.com/open?id=[ID]` or `https://drive.google.com/file/d/[ID]`

3. Download the file by the following command:
```
gdrive_download google_drive_file_id filename.ext
```
