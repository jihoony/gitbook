# vagrant를 사용한 vm 설치 방법

## Prerequisite

1. virtualbox([https://www.virtualbox.org](https://www.virtualbox.org)) 설치
2. virtualbox extension([https://www.virtualbox.org/wiki/Downloads](https://www.virtualbox.org/wiki/Downloads)) 설치
3. vargrant([https://www.vagrantup.com](https://www.vagrantup.com)) 설치
4. vagrant plugin 설치

```bash
vagrant plugin install vagrant-vbguest
```

## How to use vagrant

1. 폴더 생성

```bash
mkdir test
cd test
```

1. vm 환경 생성

Ubuntu 20.04를 설치하는것 기준으로 작성한다. 다른 이미지를 설치하고 싶으면 구글 검색에 vagrant centos7 같이 찾으면 확인 가능하다.

```bash
vagrant init ubuntu/focal64
```

`vagrant init`이후 생성되는 `Vagrantfile` 의 `config.vm.box`내용을 직접 수정해서 이미지 이름을 작성할 수도 있다.

하위에 생성되는 `Vargrantfile`파일에 `config.vm.provider` 항목을 찾아 virtualbox 이미지의 내용을 수정한다.

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/focal64"
  
	config.vm.provider "virtualbox" do |vb|
  	vb.cpus = 2
	  vb.memory = 2048
  	vb.name = "my-server"
	end
end
```

1. vm provisioning and run

Virtual machine을 다음의 명령어를 통해 초기 세팅 및 구동을 진행한다.

```bash
vagrant up
```

중간에 `Vagrantfile`의 내용을 수정해서 다시 반영하고 싶은 경우에는 `vagrant up --provision` 명령어를 통하여 provisioning 을 수행한다.

1. vm 접속

```bash
vagrant ssh
```

1. vm 정지

```bash
vagrant halt
```

1. vm 삭제

```bash
vagrant destroy
```

## vagrant default 설정

* Disk Mount
  * host의 `Vagrantfile` 파일이 있는 디렉토리가 guest의 `/vagrant` 에 자동으로 마운트 된다.

## Reference

{% embed url="https://www.vagrantup.com/docs" %}
