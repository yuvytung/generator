#find src/main/resources/template/backend-nestjs/ -type f  -exec bash -c 'mv $0 $0.ejs ' {} \;
#find src/main/resources/template/frontend-reactjs/ -type f  -exec bash -c 'mv $0 $0.ejs ' {} \;
workdir=$(pwd)
cd "$workdir/build/out/backend-nestjs" && yarn && npm start & \
cd "$workdir/build/out/frontend-reactjs" && yarn && npm start
