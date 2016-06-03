sudo docker run -ti --name ionic-dev -u $(id -u):$(id -g) --privileged -v /dev/bus/usb:/dev/bus/usb -v /home/john/ionic/:/data ionic bash
