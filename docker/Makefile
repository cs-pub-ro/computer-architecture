version=1.0.0
registry=gitlab.cs.pub.ro:5050/ac/ac-public
img_name=vivado-fit
tag_name=${registry}/${img_name}:${version}
internal_step_img_name=vivado-final

build:
	docker image build -t ${tag_name} --target ${internal_step_img_name} .

test: build
	docker run --rm --name ${img_name} ${tag_name}

run: build
	docker run --rm -it --name ${img_name} -e QT_DEBUG_PLUGINS=1 ${tag_name} /bin/bash

bash:
	docker exec -it ${img_name} /bin/bash

push:
	docker push ${tag_name}

clean:
	docker rm -f ${img_name}
	docker image rm ${tag_name}

