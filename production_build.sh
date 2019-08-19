JEKYLL_ENV=production jekyll build
rsync -r _site/* brown:/web/cs/web/sites/bigai/
ssh -t brown "chmod 777 -R /web/cs/web/sites/bigai/*"
