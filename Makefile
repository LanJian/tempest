all:
	coffee -o js -c src

watch:
	coffee -o js -cw src

copy:
	cp ~/projects/coffee2d/build/engine-all.js lib/engine-all.js
