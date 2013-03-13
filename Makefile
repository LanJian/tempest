all:
	coffee -o js -c src
	cp ~/projects/coffee2d/build/engine-all.js lib/engine-all.js

watch:
	coffee -o js -cw src
