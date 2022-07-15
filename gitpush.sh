git add .
echo -n "What was changed?"
read;
git commit -m "${REPLY}"
git push
