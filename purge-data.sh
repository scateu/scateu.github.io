echo "This will purge all posts and pages!!!"
echo "If it's not what you want, Ctrl-C."
echo "Press enter to proceed..."
read

if [ -d _site ]; then
rm -r ./_site
fi

rm -r ./_pages/*
rm -r ./_posts/*
rm -r ./_drafts/*
rm ./_includes/disqus.html && touch ./_includes/disqus.html
rm -r ./images/*

echo "Press enter to generate a demo post..."
echo "If it's not what you want, Ctrl-C."
read


cat _demo.md >> ./_posts/2016-12-22-my-first-post.md 
