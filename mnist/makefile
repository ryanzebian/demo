.SUFFIXES:
wat2wasm = /opt/homebrew/bin/wat2wasm
static/draw.wasm: static/draw.wat
	$(wat2wasm) -o $@ $<


run:
	source .venv/bin/activate && FLASK_APP=server FLASK_ENV=development flask run 