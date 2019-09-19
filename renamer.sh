find source/stylesheets -depth -name "*.css.sass" -exec sh -c 'mv "$1" "${1%.css.sass}.sass"' _ {} \;
