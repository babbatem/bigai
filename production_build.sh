JEKYLL_ENV=production jekyll build
echo enter password to rsync
rsync -r _site/* brown:/web/cs/web/sites/bigai/
echo rsync complete
echo enter password to chmod
ssh -t brown "chmod 777 -R /web/cs/web/sites/bigai/*"
