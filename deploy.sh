# Build images (both latest and GIT_SHA tags for use with imperative command to automatically deploy newest commit by SHA value)
docker build -t danedabomb/multi-client:latest -t danedabomb/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t danedabomb/multi-server:latest -t danedabomb/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t danedabomb/multi-worker:latest -t danedabomb/multi-worker:$SHA -f ./worker/Dockerfile ./worker
# Push images to Docker Hub (already logged in from Travis yaml file)
docker push danedabomb/multi-client:latest
docker push danedabomb/multi-client:$SHA
docker push danedabomb/multi-server:latest
docker push danedabomb/multi-server:$SHA
docker push danedabomb/multi-worker:latest
docker push danedabomb/multi-worker:$SHA
# Apply all configs in k8s folder (kubectl already configured from Travis yaml file)
kubectl apply -f k8s
# Imperatively set latest images on each deployment
kubectl set image deployments/server-deployment server=danedabomb/multi-server:$SHA
kubectl set image deployments/client-deployment client=danedabomb/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=danedabomb/multi-worker:$SHA