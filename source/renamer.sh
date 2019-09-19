shopt -s globstar
for file in source/javascripts/templates/**/*.jst.hamlc; do
  mv "$file" "${file%.jst.hamlc}.haml"
done
