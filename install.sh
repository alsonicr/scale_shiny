# Make sure you are in the directory with the Dockerfile
# Replace 'myshinyapp' with the name you want for your Docker image.
docker build -t myshinyapp .
docker run -d -p 80:3838 --name myshinyapp_container myshinyapp