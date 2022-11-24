ITCHIO_USERNAME=tducasse
ITCHIO_GAME=team-work-makes-the-dream-work

mkdir -v -p build/web
godot -v --export "HTML5" build/web/index.html
butler push ./build/web ${ITCHIO_USERNAME}/${ITCHIO_GAME}:web

mkdir -v -p build/windows
godot -v --export "Windows Desktop" build/windows/$EXPORT_NAME.exe
butler push ./build/windows ${ITCHIO_USERNAME}/${ITCHIO_GAME}:windows
