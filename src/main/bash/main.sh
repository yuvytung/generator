workdir=$(pwd)
cd "$workdir/build/output/backend-nestjs" && yarn && npm start & \
cd "$workdir/build/output/frontend-reactjs" && yarn && npm start
