echo "This will purge all posts and pages!!!"
echo "If it's not what you want, Ctrl-C."
read

rm -r ./_site
rm -r ./_pages/*
rm -r ./_posts/*
rm -r ./_drafts/*
rm ./_includes/disqus.html && touch ./_includes/disqus.html
rm -r ./images/*
