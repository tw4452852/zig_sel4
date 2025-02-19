PYTHON3 ?= python3

default:
	cmake -C ./configs/qemu-arm-virt_64v.cmake -G Ninja -S . -B ./build/ -DPYTHON3=${PYTHON3}
	cmake --build ./build

clean:
	rm -fr ./build

run:
	./build/simulate -i ./build/images/rootserver-image-arm-qemu-arm-virt
